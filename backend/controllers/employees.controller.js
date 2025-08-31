// backend/controllers/employees.controller.js
// Responsibility: To handle HTTP requests, validate input, and orchestrate responses for the 'employees' entity.
import * as EmployeeService from '../services/employees.service.js';

// Get all non-deleted employees
export const getAllEmployees = async (req, res, next) => {
    const employees = await EmployeeService.findAll();
    res.status(200).json(employees);
};

// Get a single employee by their UUID
export const getEmployeeById = async (req, res, next) => {
    const { id } = req.params;
    const employee = await EmployeeService.findById(id);
    if (!employee) {
        return res.status(404).json({ message: 'Employee not found' });
    }
    res.status(200).json(employee);
};

// Create a new employee
export const createEmployee = async (req, res, next) => {
    // The service now handles transactions, so the controller is simpler.
    // It passes the entire body, and the service decides what to do with it.
    const {
        employee_code,
        first_name,
        last_name,
        email,
        password,
        phone,
        birth_date,
        identification_type_id,
        identification_number,
        gender_id,
        access_level_id,
        headquarters_id,
        status_id,
        hire_date,
    } = req.body;
    
    // Validate required fields (now includes the new NOT NULL fields)
    if (
        !employee_code?.trim() ||
        !first_name?.trim() ||
        !last_name?.trim() ||
        !email?.trim() ||
        !password?.trim() ||
        !phone?.trim() ||
        !birth_date?.trim() ||
        !identification_type_id?.trim() ||
        !identification_number?.trim() ||
        !gender_id?.trim() ||
        !access_level_id?.trim() ||
        !headquarters_id?.trim() ||
        !status_id?.trim() ||
        !hire_date?.trim()
    ) {
        return res.status(400).json({ 
            message: 'Missing or empty required fields: employee_code, first_name, last_name, email, password, phone, birth_date, identification_type_id, identification_number, gender_id, access_level_id, headquarters_id, status_id, hire_date' 
        });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        return res.status(400).json({ message: 'Invalid email format' });
    }

    // Validate password length
    if (password.trim().length < 6) {
        return res.status(400).json({ message: 'Password must be at least 6 characters long' });
    }

    // Validate date format (YYYY-MM-DD) for both dates
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(hire_date)) {
        return res.status(400).json({ message: 'hire_date must be in YYYY-MM-DD format' });
    }
    
    if (!dateRegex.test(birth_date)) {
        return res.status(400).json({ message: 'birth_date must be in YYYY-MM-DD format' });
    }

    // Validate phone format (basic validation for numbers and common formats)
    const phoneRegex = /^[\+]?[\d\s\-\(\)]{7,20}$/;
    if (!phoneRegex.test(phone)) {
        return res.status(400).json({ message: 'Invalid phone number format' });
    }

    try {
        // The create service handles the employee table insertion.
        // Role and salary are added via their own dedicated endpoints.
        const newEmployeeId = await EmployeeService.create(req.body);
        res.status(201).json({
            id: newEmployeeId,
            message: 'Employee created successfully. You can now assign roles and salaries.',
        });
    } catch (error) {
        console.error('Error creating employee:', error);
        res.status(500).json({ 
            message: 'Failed to create employee',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Update an existing employee
export const updateEmployee = async (req, res, next) => {
    const { id } = req.params;
    const employeeData = req.body;

    // Validate required fields (now includes all the new NOT NULL fields)
    const {
        employee_code,
        first_name,
        last_name,
        email,
        phone,
        birth_date,
        identification_type_id,
        identification_number,
        gender_id,
        access_level_id,
        headquarters_id,
        status_id,
        hire_date,
    } = employeeData;
    
    if (
        !employee_code?.trim() ||
        !first_name?.trim() ||
        !last_name?.trim() ||
        !email?.trim() ||
        !phone?.trim() ||
        !birth_date?.trim() ||
        !identification_type_id?.trim() ||
        !identification_number?.trim() ||
        !gender_id?.trim() ||
        !access_level_id?.trim() ||
        !headquarters_id?.trim() ||
        !status_id?.trim() ||
        !hire_date?.trim()
    ) {
        return res.status(400).json({ 
            message: 'Missing or empty required fields: employee_code, first_name, last_name, email, phone, birth_date, identification_type_id, identification_number, gender_id, access_level_id, headquarters_id, status_id, hire_date' 
        });
    }

    // Validate email format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        return res.status(400).json({ message: 'Invalid email format' });
    }

    // Validate date format (YYYY-MM-DD) for both dates
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(hire_date)) {
        return res.status(400).json({ message: 'hire_date must be in YYYY-MM-DD format' });
    }
    
    if (!dateRegex.test(birth_date)) {
        return res.status(400).json({ message: 'birth_date must be in YYYY-MM-DD format' });
    }

    // Validate phone format (basic validation for numbers and common formats)
    const phoneRegex = /^[\+]?[\d\s\-\(\)]{7,20}$/;
    if (!phoneRegex.test(phone)) {
        return res.status(400).json({ message: 'Invalid phone number format' });
    }

    try {
        const updatedEmployee = await EmployeeService.update(id, employeeData);
        if (!updatedEmployee) {
            return res.status(404).json({ message: 'Employee not found' });
        }
        res.status(200).json({
            id: updatedEmployee.id,
            message: 'Employee updated successfully',
        });
    } catch (error) {
        console.error('Error updating employee:', error);
        res.status(500).json({ 
            message: 'Failed to update employee',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

// Soft delete an employee
export const softDeleteEmployee = async (req, res, next) => {
    const { id } = req.params;
    const result = await EmployeeService.softDelete(id);
    if (result === 0) {
        return res.status(404).json({ message: 'Employee not found' });
    }
    res.status(204).send();
};
