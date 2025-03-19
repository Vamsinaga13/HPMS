# Hospital Patient Management System (HPMS)

## 📋 Project Overview
The **Hospital Patient Management System (HPMS)** is a database-driven system designed to manage hospital operations efficiently. It automates patient data storage, appointment scheduling, doctor assignments, billing, and prescription management.

## 🌐 Key Features
- **Patient Management:** Stores patient details, medical history, and admission records.
- **Doctor Management:** Assigns doctors to patients and tracks their schedules.
- **Appointment System:** Manages patient appointments, rescheduling, and cancellations.
- **Billing System:** Handles automated invoicing and payment tracking.
- **Prescription Management:** Doctors can store and retrieve prescriptions for patients.
- **Role-Based Access Control:** Ensures different levels of user access for security.
- **Medical Records Storage:** Maintains patient diagnosis, treatments, and test results.
- **Discharge Summary:** Records and generates discharge details for patients.

## 💻 Technology Stack
- **Database:** MySQL for structured patient, doctor, and hospital data storage.
- **Backend:** SQL queries for data handling and hospital management.
- **Version Control:** Git & GitHub for tracking changes.
- **Hosting:** Local or cloud-based MySQL server for data accessibility.

## 📁 Database Schema Overview
```
/hospital-management-system
├── hospital_db.sql    # MySQL database schema
├── tables/            # SQL scripts for individual tables
│   ├── patients.sql   # Table structure for patient details
│   ├── doctors.sql    # Table structure for doctor details
│   ├── appointments.sql  # Manages patient appointments
│   ├── billing.sql    # Stores invoice and payment records
│   ├── prescriptions.sql  # Stores patient prescriptions
│   ├── medical_records.sql  # Tracks patient treatments and diagnoses
│   ├── discharge.sql  # Stores discharge summaries
└── README.md          # Project documentation
```

## 🚀 Getting Started
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/hospital-management-system.git
   ```
2. **Set Up the Database:**
   - Import `hospital_db.sql` into MySQL using PHPMyAdmin or a MySQL client.
3. **Verify the Tables:**
   - Ensure that all required tables (`patients`, `doctors`, `appointments`, etc.) exist.
4. **Run Queries:**
   - Execute SQL queries to insert, update, and retrieve hospital records.

## 📌 Future Enhancements
- Adding real-time data visualization for hospital reports.
- Implementing triggers and stored procedures for automation.
- Expanding patient record tracking with advanced analytics.
- Integrating insurance claim processing in the billing system.


## 📧 Contact Information
**Gumparthi Naga Vamsi**  
📍 Hyderabad, Telangana  
📞 +91 9701454574  
📩 vamsigumparthi@gmail.com  

---

> This project is licensed under the [MIT License](LICENSE).
