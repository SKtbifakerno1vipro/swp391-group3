# Sales Process Digitalization System

## 📚 Table of Contents

- [📖 Introduction](#-introduction)
- [🎯 Main Objectives](#-main-objectives)
- [🏗️ System Modules](#️-system-modules)
- [🔄 System Workflow](#-system-workflow)
- [👥 System Roles](#-system-roles)
- [🧩 Technologies Used](#-technologies-used)
- [🗂️ Project Structure](#️-project-structure)
- [🗃️ Database Entities](#️-database-entities)
- [🔐 Authentication & Authorization](#-authentication--authorization)
- [📊 Dashboard](#-dashboard)
- [🚀 Future Improvements](#-future-improvements)
- [⚙️ Installation](#️-installation)
- [🧪 Database Setup](#-database-setup)
- [📄 Documents](#-documents)
- [📜 License](#-license)
- [📬 Contact](#-contact)

## 📌 Introduction

The **Sales Process Digitalization System** is a web-based application designed to help small and micro enterprises manage and digitalize their sales workflow.

The system focuses on:

* Customer management
* Contract management
* Sales workflow tracking
* Revenue statistics
* Reporting system
* Role-based management

This project is developed for academic and practical business management purposes.

---

## 🎯 Main Objectives

* Replace manual sales tracking processes
* Improve workflow transparency
* Centralize business data
* Manage contracts and orders efficiently
* Generate business reports automatically
* Support managers in monitoring sales performance

---

## 🏗️ System Modules

### 1. User Management

Manage system users and permissions.

#### Features

* Login / Logout
* Role-based authorization
* Employee account management
* Role assignment

#### Roles

* Admin
* Manager
* Sales Staff
* Provider

---

### 2. Customer Management

Manage customer information and sales interactions.

#### Features

* Create customer profiles
* Update customer information
* Track customer status
* View customer history

---

### 3. Contract & Workflow Management

Manage contracts and sales processes.

#### Workflow Example

```text
Lead
↓
Customer
↓
Contract Draft
↓
Pending Approval
↓
Approved
↓
Assigned
↓
In Progress
↓
Completed
```

#### Features

* Create contracts
* Approve contracts
* Assign tasks
* Track workflow status
* Manage order progress

---

### 4. Revenue & Sales Statistics

Analyze business performance.

#### Features

* Revenue dashboard
* Monthly statistics
* Sales performance tracking
* Contract statistics

---

### 5. Reporting System

Generate reports for business monitoring.

#### Features

* Revenue reports
* Employee reports
* Contract reports
* Customer reports

---

## 🧩 Technologies Used

| Technology              | Purpose         |
| ----------------------- | --------------- |
| Java / Spring Boot      | Backend         |
| ReactJS / NextJS        | Frontend        |
| SQL Server / PostgreSQL | Database        |
| JWT Authentication      | Security        |
| RESTful API             | Communication   |
| GitHub                  | Version Control |

---

## 🗂️ Project Structure

```bash
project-root/
│
├── backend/
│   ├── controllers/
│   ├── services/
│   ├── repositories/
│   ├── entities/
│   └── configs/
│
├── frontend/
│   ├── components/
│   ├── pages/
│   ├── layouts/
│   └── services/
│
├── database/
│   ├── schema/
│   └── seed/
│
├── documents/
│   ├── SRS/
│   ├── ERD/
│   └── UML/
│
└── README.md
```

---

## 🗃️ Core Entities

Main entities in the system:

* User
* Role
* Employee
* Customer
* Contract
* Order
* Provider
* Payment

---

## 🔐 Authentication & Authorization

The system uses:

* JWT Authentication
* Role-Based Access Control (RBAC)

#### Permission Examples

| Role        | Permissions                |
| ----------- | -------------------------- |
| Admin       | Full access                |
| Manager     | Manage contracts & reports |
| Sales Staff | Manage customers & orders  |
| Provider    | View assigned tasks/orders |

---

## 📊 Dashboard Overview

The dashboard provides:

* Revenue overview
* Contract statistics
* Order tracking
* Employee performance
* Workflow status monitoring

---

## 🚀 Future Improvements

* AI sales assistant
* Automated notifications
* Customer portal
* Online contract signing
* Real-time analytics
* Mobile application

---

## ⚙️ Installation

### Backend

```bash
cd backend
mvn spring-boot:run
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

---

## 🧪 Database Setup

```sql
CREATE DATABASE sales_management_system;
```

Update your database configuration in:

```properties
application.properties
```

---

## 📌 Development Workflow

```text
Requirement Analysis
↓
System Design
↓
Database Design
↓
Backend Development
↓
Frontend Development
↓
Testing
↓
Deployment
```

---

## 👨‍💻 Team Roles

| Role        | Responsibility                 |
| ----------- | ------------------------------ |
| Admin       | System management              |
| Manager     | Contract approval & monitoring |
| Sales Staff | Customer handling              |
| Provider    | Service/product support        |

---

## 📄 Documents

Project documents include:

* SRS
* ERD
* Use Case Diagram
* Context Diagram
* Activity Diagram
* Sequence Diagram

---

## 📈 Business Domain

Domain: **Sales Management & Business Process Digitalization**

Target users:

* Small enterprises (SMEs)
* Micro businesses
* Sales teams
* Business managers

---

## 🤝 Contributing

Contributions are welcome.

```bash
git checkout -b feature/new-feature
git commit -m "Add new feature"
git push origin feature/new-feature
```

---

## 📜 License

This project is for educational and academic purposes.

---

## 📬 Contact

If you have any questions or suggestions:

* Email: [nguyenkhanhson03@gmail.com](mailto:nguyenkhanhson03@gmail.com)
* GitHub: SonwNguyen

---

## ⭐ Project Status

🚧 Currently in development.
