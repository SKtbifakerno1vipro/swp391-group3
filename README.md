# Bakery Ingredient Contract & Sales Management System

## 1. Project Overview
The **Bakery Ingredient Contract & Sales Management System** is a web-based application designed for direct B2B/B2C sales of bakery ingredients. The system manages the entire lifecycle from Quotation to Contract Signing and Payment.

## 2. Core Roles & Responsibilities
*   **Sale Staff:** Manage quotations and negotiate prices.
*   **Manager:** Approve/Reject contracts and requests for changes.
*   **Admin Officer:** Generate drafts, edit contract text, and manage invoices/PDFs.
*   **Warehouse Staff:** Manage inventory and stock control.
*   **Customer:** View quotations, sign contracts via email/OTP, and make payments.

## 3. Workflow Lifecycle (6 Stages)
1.  **Quotation:** Sale Staff creates and negotiates quotations.
2.  **Drafting:** Admin Officer generates a contract draft from an accepted quotation.
3.  **Approval Workflow:** Manager reviews and approves, or requests changes.
4.  **Signature:** Customer signs electronically via email/OTP portal.
5.  **Payment & Invoice:** Customer pays via VNPay; Admin Officer issues VAT invoice.
6.  **Reporting & Audit:** System logs all contract versions and status changes for audit.

## 4. Key Architecture Decisions
*   **Contract Templates:** Use static HTML templates instead of DB-based CRUD to ensure legal consistency.
*   **Audit Trail:** Robust versioning (contract_version) and status logging (contract_status_log).
*   **Security:** SQL Injection prevention using Parameterized Queries and Role-Based Access Control (RBAC).

## 5. Technology Stack
*   Java Web (Servlet/JSP)
*   MS SQL Server
*   VNPay Integration
*   Gmail SMTP (OTP/Notifications)
*   PDF/Excel Libraries (iText/Apache POI)

## 6. Installation
1.  Database setup: Run SQL scripts to create the database.
2.  Configuration: Update pplication.properties (database, email, VNPay).
3.  Deploy: Deploy to Tomcat server.

---
