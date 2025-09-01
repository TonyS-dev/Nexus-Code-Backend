# Riwi Nexus - Backend API

A robust RESTful API built for Riwi Nexus, a comprehensive web platform that centralizes and streamlines internal human resources management. This backend service handles employee data, vacation requests, leave applications, certificate generation, and provides a complete audit trail for all personnel procedures.

The system features a **Node.js Express architecture** with **PostgreSQL database**, **JWT authentication**, and **Docker containerization** for scalable deployment. It demonstrates enterprise-level patterns with automated database seeding, comprehensive logging, and role-based access control.

---

## 📋 Project Information

- **Project:** Riwi Nexus - HR Management Platform
- **Team:** Nexus-code
- **Repository:** Backend API Service

---

## 🎯 Core Features

- ✅ **RESTful API Architecture:** Complete Express.js REST API with standardized endpoints and HTTP status codes
- ✅ **JWT Authentication & Authorization:** Secure token-based authentication with role-based access control (Employee, Leader, HR Admin)
- ✅ **Comprehensive HR Modules:** Full CRUD operations for employees, requests, certificates, notifications, and employee histories
- ✅ **Database Integration:** PostgreSQL connection with parameterized queries and transaction support
- ✅ **Automated Database Seeding:** Python-based scripts for automatic database initialization and sample data population
- ✅ **Security Features:** Password encryption with bcrypt, CORS middleware, and input validation
- ✅ **Enterprise Logging:** HTTP request logging with Morgan for debugging and monitoring
- ✅ **Email Integration:** Automated email notifications using Resend service
- ✅ **Docker Ready:** Complete containerization with Docker Compose for development and production environments
- ✅ **CSV Data Import:** Bulk data import capabilities for employee and organizational data

---

## �️ Technologies Used

- **Runtime:** Node.js (>=18)
- **Framework:** Express.js ^5.1.0
- **Database:** PostgreSQL (>=14)
- **Database Client:** pg ^8.16.3
- **Authentication:** JSON Web Tokens (jsonwebtoken ^9.0.2)
- **Security:** bcrypt ^6.0.0 for password hashing
- **Development:** nodemon ^3.1.10 for hot reload
- **Containerization:** Docker & Docker Compose
- **Automation:** Python scripts for seeding and deployment

## 📁 Project Structure

```
Nexus-Code-Backend/
├── .env.example                 # Environment variables template
├── .gitattributes              # Git attributes configuration
├── .gitignore                  # Git ignore rules
├── LICENSE                     # Project license
├── README.md                   # This documentation
├── api_seeder.py              # Python script for API data seeding
├── create_seeds.sh            # Shell script for seed creation
├── docker-compose.dev.yml     # Docker development configuration
├── docker-compose.yml         # Docker production configuration
├── package.json               # Root package configuration
├── restart_db.sh              # Database restart utility
├── run_all_seeds.sh           # Execute all seeding scripts
├── start-dev.py              # Development environment starter
├── start-prod.py             # Production environment starter
├── stop-dev.py               # Development environment stopper
├── stop-prod.py              # Production environment stopper
├── .github/
│   └── CODEOWNERS            # Repository ownership rules
└── backend/
    ├── Dockerfile            # Container configuration
    ├── package.json          # Backend dependencies
    ├── package-lock.json     # Dependency lock file
    ├── server.js             # Main application entry point
    ├── config/
    │   └── database.js       # Database connection configuration
    ├── controllers/          # Request handlers and business logic
    │   ├── access_levels.controller.js
    │   ├── approvals.controller.js
    │   ├── attached_documents.controller.js
    │   ├── auth.controller.js
    │   ├── certificate_types.controller.js
    │   ├── employee_histories.controller.js
    │   ├── employee_salaries.controller.js
    │   ├── employee_statuses.controller.js
    │   ├── employees.controller.js
    │   ├── genders.controller.js
    │   ├── headquarters.controller.js
    │   ├── identification_types.controller.js
    │   ├── index.controller.js
    │   ├── leave_types.controller.js
    │   ├── notifications.controller.js
    │   └── requests.controller.js
    ├── middleware/           # Authentication and validation middleware
    │   ├── auth.middleware.js
    │   └── validation.middleware.js
    ├── models/              # Database models and schemas
    ├── routes/              # API route definitions
    │   ├── auth.routes.js
    │   ├── employees.routes.js
    │   ├── requests.routes.js
    │   └── index.routes.js
    ├── services/            # Business logic and data access layer
    ├── utils/               # Utility functions and helpers
    └── seeds/               # Database seeding scripts
        ├── employees.sql
        ├── requests.sql
        └── master_data.sql
```

## � Dependencies & Versions

### Core Dependencies

- **express** ^5.1.0 → High-performance web framework for Node.js
- **pg** ^8.16.3 → PostgreSQL client for Node.js
- **pg-format** ^1.0.4 → Safe parameterized SQL query formatting
- **bcrypt** ^6.0.0 → Industry-standard password hashing library
- **jsonwebtoken** ^9.0.2 → JSON Web Token implementation for secure authentication
- **cors** ^2.8.5 → Cross-Origin Resource Sharing middleware
- **morgan** ^1.10.1 → HTTP request logger middleware
- **csv-parser** ^3.2.0 → Streaming CSV parser for bulk data import
- **resend** ^3.2.0 → Modern email API for transactional emails
- **cross-env** ^10.0.0 → Cross-platform environment variable handling

### Development Dependencies

- **nodemon** ^3.1.10 → Development server with automatic restart on file changes

---

## ⚙️ Prerequisites

- **Node.js** >=18.0.0
- **PostgreSQL** >=14.0
- **Docker** >=20.0 (optional, for containerized deployment)
- **Python** >=3.8 (for seeding scripts)

---

## 🚀 Installation & Setup

### 🔹 Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/TonyS-dev/Nexus-Code-Backend.git
   cd Nexus-Code-Backend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   cd backend && npm install
   ```

3. **Configure environment variables:**
   Create a `.env` file in the root directory based on `.env.example`:
   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_USER=your_db_user
   DB_PASSWORD=your_password
   DB_NAME=riwi_nexus
   DB_PORT=5432
   
   # Server Configuration
   PORT=3000
   NODE_ENV=development
   
   # Authentication
   JWT_SECRET=your_super_secret_jwt_key
   JWT_EXPIRES_IN=1h
   
   # Email Configuration
   RESEND_API_KEY=your_resend_api_key
   EMAIL_FROM=onboarding@resend.dev
   FRONTEND_URL=https://...
   ```

4. **Set up the database:**
   ```bash
   # Create database and run migrations
   npm run db:setup
   
   # Seed the database with sample data
   npm run seed
   ```

5. **Start the development server:**
   ```bash
   npm run dev
   ```
   The API will be available at `http://localhost:3000`

### 🔹 Docker Development

1. **Start with Docker Compose:**
   ```bash
   # Development environment
   docker-compose -f docker-compose.dev.yml up
   
   # Production environment
   docker-compose up
   ```

2. **Run database seeding:**
   ```bash
   python api_seeder.py
   ```

---

## 🌐 API Endpoints

### Authentication

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| `POST` | `/api/auth/login` | User authentication | Public |
| `POST` | `/api/auth/register` | User registration | Public |
| `POST` | `/api/auth/logout` | User logout | Authenticated |
| `GET` | `/api/auth/profile` | Get current user profile | Authenticated |

### Employee Management

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| `GET` | `/api/employees` | Get all employees | HR Admin, Leader |
| `POST` | `/api/employees` | Create new employee | HR Admin |
| `GET` | `/api/employees/:id` | Get employee by ID | Authenticated |
| `PUT` | `/api/employees/:id` | Update employee | HR Admin |
| `DELETE` | `/api/employees/:id` | Delete employee | HR Admin |

### Request Management

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| `GET` | `/api/requests` | Get all requests | HR Admin, Leader |
| `POST` | `/api/requests` | Create new request | Employee |
| `GET` | `/api/requests/:id` | Get request by ID | Owner, Leader, HR Admin |
| `PUT` | `/api/requests/:id` | Update request status | Leader, HR Admin |
| `DELETE` | `/api/requests/:id` | Cancel request | Owner |

### Advanced Reporting

| Method | Endpoint | Description | Access |
|--------|----------|-------------|--------|
| `GET` | `/api/reports/employee-summary` | Employee performance summary | HR Admin |
| `GET` | `/api/reports/request-analytics` | Request analytics and trends | HR Admin, Leader |
| `GET` | `/api/notifications/unread` | Get unread notifications | Authenticated |

---

## 🔐 Security Features

- **Password Encryption:** bcrypt with salt rounds for secure password storage
- **JWT Authentication:** Stateless authentication with configurable expiration
- **Role-Based Access Control:** Three-tier access levels (Employee, Leader, HR Admin)
- **CORS Protection:** Configurable cross-origin resource sharing
- **Input Validation:** Comprehensive request validation middleware
- **SQL Injection Prevention:** Parameterized queries using pg-format

---

## 📊 Database Schema

The system uses a normalized PostgreSQL database with the following core entities:

- **Employees:** Complete employee profiles with hierarchical relationships
- **Requests:** Vacation, leave, and certificate requests with approval workflows
- **Notifications:** Real-time notification system for request updates
- **Audit Trails:** Complete history tracking for all personnel changes
- **Master Data:** Configurable catalogs for headquarters, departments, and roles

---

## 🐳 Docker Deployment

### Development Environment
```bash
# Start development containers
python start-dev.py

# Stop development containers
python stop-dev.py
```

### Production Environment
```bash
# Start production containers
python start-prod.py

# Stop production containers
python stop-prod.py
```

---

## 🔧 Available Scripts

- `npm run dev` → Start development server with hot reload
- `npm start` → Start production server
- `npm run seed` → Execute database seeding scripts
- `npm run db:reset` → Reset and reseed database
- `npm test` → Run test suite
- `npm run lint` → Run ESLint code analysis

---

## 📝 Code Quality & Architecture

- **MVC Pattern:** Clear separation between Models, Views, and Controllers
- **Service Layer:** Business logic abstraction for better testability
- **Middleware Pipeline:** Modular request processing with authentication and validation
- **Error Handling:** Centralized error handling with appropriate HTTP status codes
- **Async/Await:** Modern JavaScript patterns for clean asynchronous operations
- **Environment Configuration:** Flexible configuration management for different deployment environments

---

## 📋 Team

**Team:** Nexus-code  
**Repository:** Backend API Service