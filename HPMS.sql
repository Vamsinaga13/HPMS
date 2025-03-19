-- Create the database
CREATE DATABASE IF NOT EXISTS HealthcareManagementSystem;
USE HealthcareManagementSystem;

-- ==============================
-- 1. Create Tables
-- ==============================

-- Patients Table
CREATE TABLE IF NOT EXISTS Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Age INT NOT NULL CHECK (Age >= 0),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Contact VARCHAR(10) NOT NULL CHECK (LENGTH(Contact) = 10 AND Contact REGEXP '^[0-9]+$'),
    InsuranceDetails VARCHAR(255)
);

-- Doctors Table
CREATE TABLE IF NOT EXISTS Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Contact VARCHAR(10) NOT NULL CHECK (LENGTH(Contact) = 10 AND Contact REGEXP '^[0-9]+$')
);

-- Appointments Table
CREATE TABLE IF NOT EXISTS Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    TimeSlot TIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    UNIQUE (DoctorID, AppointmentDate, TimeSlot) -- Prevent double bookings
);

-- Billing Table
CREATE TABLE IF NOT EXISTS Billing (
    BillingID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount >= 0),
    PaymentStatus ENUM('Paid', 'Pending', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
);

-- Pharmacy Table
CREATE TABLE IF NOT EXISTS Pharmacy (
    MedicineID INT AUTO_INCREMENT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity >= 0),
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0)
);

-- Prescriptions Table
CREATE TABLE IF NOT EXISTS Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    MedicineID INT NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    DateIssued DATE NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID),
    FOREIGN KEY (MedicineID) REFERENCES Pharmacy(MedicineID)
);

-- ==============================
-- 2. Insert Sample Data
-- ==============================

-- Patients
INSERT INTO Patients (Name, Age, Gender, Contact, InsuranceDetails) VALUES
('John Doe', 30, 'Male', '1234567890', 'Health Insurance A'),
('Jane Smith', 25, 'Female', '0987654321', 'Health Insurance B'),
('Harish Kumar', 25, 'Male', '8801800041', 'Health Insurance C'),
('Harikrishna Reddy', 24, 'Male', '9801800041', 'Health Insurance D');

-- Doctors
INSERT INTO Doctors (Name, Specialization, Contact) VALUES
('Dr. Alice Johnson', 'Cardiology', '1112223333'),
('Dr. Bob Brown', 'Neurology', '4445556666');

-- Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, TimeSlot, Status) VALUES
(1, 1, '2023-10-15', '10:00:00', 'Scheduled'),
(2, 2, '2023-10-16', '11:00:00', 'Scheduled');

-- Billing
INSERT INTO Billing (PatientID, Amount, PaymentStatus) VALUES
(1, 150.00, 'Pending'),
(2, 200.00, 'Paid');

-- Pharmacy
INSERT INTO Pharmacy (MedicineName, Quantity, Price) VALUES
('Aspirin', 100, 5.00),
('Ibuprofen', 50, 10.00);

-- Prescriptions
INSERT INTO Prescriptions (PatientID, DoctorID, MedicineID, Dosage, DateIssued) VALUES
(1, 1, 1, '1 tablet daily', '2023-10-15'),
(2, 2, 2, '2 tablets daily', '2023-10-16');

-- ==============================
-- 3. Indexing for Performance
-- ==============================

CREATE INDEX idx_patient_id ON Appointments(PatientID);
CREATE INDEX idx_doctor_id ON Appointments(DoctorID);
CREATE INDEX idx_appointment_date ON Appointments(AppointmentDate);

-- ==============================
-- 4. Stored Procedures
-- ==============================

DELIMITER //

-- Procedure to schedule an appointment
CREATE PROCEDURE ScheduleAppointment(
    IN p_PatientID INT, 
    IN p_DoctorID INT, 
    IN p_AppointmentDate DATE, 
    IN p_TimeSlot TIME
)
BEGIN
    DECLARE appointment_exists INT;

    SELECT COUNT(*) INTO appointment_exists
    FROM Appointments
    WHERE DoctorID = p_DoctorID AND AppointmentDate = p_AppointmentDate AND TimeSlot = p_TimeSlot;

    IF appointment_exists = 0 THEN
        INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, TimeSlot, Status)
        VALUES (p_PatientID, p_DoctorID, p_AppointmentDate, p_TimeSlot, 'Scheduled');
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Time slot already booked!';
    END IF;
END //

DELIMITER ;

-- ==============================
-- 5. Triggers
-- ==============================

DELIMITER //

-- Automatically update appointment status when bill is paid
CREATE TRIGGER UpdatePaymentStatus
AFTER UPDATE ON Billing
FOR EACH ROW
BEGIN
    IF NEW.PaymentStatus = 'Paid' THEN
        UPDATE Appointments
        SET Status = 'Completed'
        WHERE PatientID = NEW.PatientID;
    END IF;
END //

DELIMITER ;

-- ==============================
-- 6. Advanced Reporting Queries
-- ==============================

-- Patient Billing Summary Report
SELECT 
    p.Name AS PatientName, 
    b.BillingID, 
    b.Amount, 
    b.PaymentStatus
FROM Billing b
JOIN Patients p ON b.PatientID = p.PatientID
ORDER BY b.BillingID DESC;

-- Total Revenue by Doctor
SELECT 
    d.Name AS DoctorName, 
    SUM(b.Amount) AS TotalRevenue
FROM Billing b
JOIN Appointments a ON b.PatientID = a.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE b.PaymentStatus = 'Paid'
GROUP BY d.DoctorID;

-- ==============================
-- 7. Export Reports (CSV)
-- ==============================

SELECT * FROM Billing
INTO OUTFILE '/var/lib/mysql-files/BillingReport.csv'
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n';
