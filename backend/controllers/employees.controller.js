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
    const {
        employee_code,
        first_name,
        last_name,
        email,
        password,
        headquarters_id,
        status_id,
    } = req.body;
    if (
        !employee_code ||
        !first_name ||
        !last_name ||
        !email ||
        !password ||
        !headquarters_id ||
        !status_id
    ) {
        return res
            .status(400)
            .json({ message: 'Missing required fields.' });
    }

    // The service will handle hashing the password
    const newEmployeeId = await EmployeeService.create(req.body);
    res.status(221).json({
        id: newEmployeeId,
        message: 'Employee created successfully',
    });
};


// Update an existing employee
export const updateEmployee = async (req, res, next) => {
    const { id } = req.params;
    const employeeData = req.body;

    const updatedEmployee = await EmployeeService.update(id, employeeData);
    if (!updatedEmployee) {
        return res.status(404).json({ message: 'Employee not found' });
    }
    res.status(200).json({
        id: updatedEmployee.id,
        message: 'Employee updated successfully',
    });
};

// Soft delete an employee (change is_deleted to true)
export const softDeleteEmployee = async (req, res, next) => {
    const { id } = req.params;
    const result = await EmployeeService.softDelete(id);
    if (result === 0) {
        return res.status(404).json({ message: 'Employee not found' });
    }
    // 204 No Content is a standard response for successful deletions with no body
    res.status(204).send();
};
