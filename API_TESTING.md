# API Testing Documentation - Riwi Nexus Backend

## 📋 Project Information
- **Project:** Riwi Nexus - Backend API
- **Team:** Nexus-code
- **Testing Date:** [Current Date]
- **API Version:** 1.0.0

---

## 🎯 API Testing Objectives

This document outlines the manual testing procedures for the Riwi Nexus backend API to ensure all endpoints function correctly, handle errors appropriately, and maintain security standards.

---

## 🔐 Authentication Endpoints Testing

### API-001: POST /api/auth/login
**Objective:** Verify user authentication works correctly

**Request Body:**
```json
{
  "email": "admin@riwi.co",
  "password": "password123"
}
```

**Expected Response (200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "admin@riwi.co",
    "first_name": "Admin",
    "access_level": "Admin"
  }
}
```

### API-002: POST /api/auth/login (Invalid Credentials)
**Request Body:**
```json
{
  "email": "invalid@test.com",
  "password": "wrongpassword"
}
```

**Expected Response (401):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

### API-003: GET /api/auth/profile
**Headers:** `Authorization: Bearer [valid_token]`

**Expected Response (200):**
```json
{
  "success": true,
  "user": {
    "id": "uuid",
    "first_name": "Admin",
    "last_name": "User",
    "email": "admin@riwi.co"
  }
}
```

---

## 👥 Employee Management Endpoints

### API-004: GET /api/employees
**Headers:** `Authorization: Bearer [admin_token]`

**Expected Response (200):**
```json
{
  "success": true,
  "employees": [
    {
      "id": "uuid",
      "first_name": "John",
      "last_name": "Doe",
      "email": "john.doe@company.com",
      "role": "Developer",
      "status": "Active"
    }
  ]
}
```

### API-005: POST /api/employees
**Headers:** `Authorization: Bearer [admin_token]`

**Request Body:**
```json
{
  "first_name": "New",
  "last_name": "Employee",
  "email": "new.employee@company.com",
  "identification_number": "12345678",
  "gender_id": "uuid",
  "headquarters_id": "uuid",
  "role_id": "uuid",
  "access_level_id": "uuid"
}
```

**Expected Response (201):**
```json
{
  "success": true,
  "message": "Employee created successfully",
  "employee": { ... }
}
```

### API-006: GET /api/employees/:id
**Test with valid UUID**

**Expected Response (200):** Employee details

**Test with invalid UUID**

**Expected Response (404):** "Employee not found"

---

## 📝 Request Management Endpoints

### API-007: POST /api/requests/vacation
**Headers:** `Authorization: Bearer [employee_token]`

**Request Body:**
```json
{
  "vacation_type_id": "uuid",
  "start_date": "2024-12-20",
  "end_date": "2024-12-27",
  "days_requested": 7,
  "comments": "Annual vacation",
  "employee_id": "uuid",
  "status_id": "pending_status_uuid"
}
```

**Expected Response (201):**
```json
{
  "success": true,
  "message": "Vacation request created successfully",
  "request": { ... }
}
```

### API-008: POST /api/requests/leave
**Request Body:**
```json
{
  "leave_type_id": "uuid",
  "start_date": "2024-12-15T09:00:00",
  "end_date": "2024-12-15T17:00:00",
  "reason": "Medical appointment",
  "employee_id": "uuid",
  "status_id": "pending_status_uuid"
}
```

### API-009: POST /api/requests/certificate
**Request Body:**
```json
{
  "certificate_type_id": "uuid",
  "comments": "For bank procedures",
  "employee_id": "uuid",
  "status_id": "pending_status_uuid"
}
```

### API-010: GET /api/requests/employee/:employeeId
**Objective:** Verify employee can view their own requests

**Expected Response (200):** List of employee's requests

---

## 🔍 Catalog Endpoints Testing

### API-011: GET /api/vacation-types
**Expected Response (200):**
```json
{
  "success": true,
  "vacation_types": [
    {
      "id": "uuid",
      "name": "Annual Vacation",
      "description": "Yearly vacation entitlement"
    }
  ]
}
```

### API-012: GET /api/leave-types
### API-013: GET /api/certificate-types
### API-014: GET /api/request-statuses
### API-015: GET /api/headquarters
### API-016: GET /api/genders
### API-017: GET /api/access-levels

**All should return appropriate catalog data**

---

## 🔔 Notification Endpoints

### API-018: GET /api/notifications
**Headers:** `Authorization: Bearer [user_token]`

**Expected Response (200):**
```json
{
  "success": true,
  "notifications": [
    {
      "id": "uuid",
      "title": "Request Approved",
      "message": "Your vacation request has been approved",
      "is_read": false,
      "created_at": "2024-12-01T10:00:00Z"
    }
  ]
}
```

### API-019: GET /api/notifications/unread-count
**Expected Response (200):**
```json
{
  "success": true,
  "unread_count": 3
}
```

---

## 🛡️ Security Testing

### API-020: Access Without Token
**Test all protected endpoints without Authorization header**

**Expected Response (401):**
```json
{
  "success": false,
  "message": "Access token required"
}
```

### API-021: Invalid Token
**Test with malformed or expired token**

**Expected Response (401):**
```json
{
  "success": false,
  "message": "Invalid or expired token"
}
```

### API-022: Role-Based Access Control
**Test employee accessing admin-only endpoints**

**Expected Response (403):**
```json
{
  "success": false,
  "message": "Insufficient permissions"
}
```

---

## 🧪 Error Handling Testing

### API-023: Invalid Request Body
**Send malformed JSON or missing required fields**

**Expected Response (400):**
```json
{
  "success": false,
  "message": "Validation error",
  "errors": ["Field 'email' is required"]
}
```

### API-024: Database Constraint Violations
**Test duplicate email registration**

**Expected Response (409):**
```json
{
  "success": false,
  "message": "Email already exists"
}
```

---

## 📊 Performance Testing

### API-025: Response Time Testing
**Objective:** Verify API responses are within acceptable limits

**Endpoints to Test:**
- GET /api/employees (should respond < 500ms)
- GET /api/requests (should respond < 1000ms)
- POST /api/requests/vacation (should respond < 2000ms)

### API-026: Concurrent Request Testing
**Test multiple simultaneous requests to same endpoint**

---

## 🔧 Testing Tools & Environment

### Manual Testing Tools
- **Postman:** For API endpoint testing
- **Browser DevTools:** For network inspection
- **curl:** For command-line testing

### Test Environment Setup
```bash
# Start test database
docker-compose -f docker-compose.dev.yml up -d

# Seed test data
npm run seed

# Start API server
npm run dev
```

### Test Data Requirements
- At least 3 employees with different roles
- Sample vacation types, leave types, certificate types
- Test requests in different states (pending, approved, rejected)

---

## 📋 API Testing Checklist

### Authentication
- [ ] Valid login returns JWT token
- [ ] Invalid credentials rejected
- [ ] Token expiration handled
- [ ] Logout functionality working

### Employee Management
- [ ] Create employee (Admin only)
- [ ] Read employee data
- [ ] Update employee information
- [ ] Soft delete employee
- [ ] Access control enforced

### Request System
- [ ] Create vacation request
- [ ] Create leave request
- [ ] Create certificate request
- [ ] View personal requests
- [ ] Request approval workflow

### Catalog Data
- [ ] All catalog endpoints returning data
- [ ] Data structure consistent
- [ ] No sensitive information exposed

### Security
- [ ] All protected endpoints require authentication
- [ ] Role-based permissions enforced
- [ ] No SQL injection vulnerabilities
- [ ] CORS properly configured

### Error Handling
- [ ] 400 errors for bad requests
- [ ] 401 errors for authentication issues
- [ ] 403 errors for authorization failures
- [ ] 404 errors for not found resources
- [ ] 500 errors handled gracefully

---

## 🐛 Common Issues to Test

1. **Date Handling:** Ensure timezone consistency
2. **File Uploads:** If implementing document attachments
3. **Email Notifications:** Verify email sending works
4. **Database Transactions:** Ensure data consistency
5. **Memory Leaks:** Monitor resource usage during extended testing

---

## 📈 Test Results Template

| Endpoint | Method | Expected Status | Actual Status | Result | Notes |
|----------|--------|----------------|---------------|---------|-------|
| /api/auth/login | POST | 200 | 200 | ✅ Pass | Working correctly |
| /api/employees | GET | 200 | 500 | ❌ Fail | Database connection error |
| ... | ... | ... | ... | ... | ... |

**Testing Summary:**
- Total Tests: [Number]
- Passed: [Number]
- Failed: [Number]
- Success Rate: [Percentage]