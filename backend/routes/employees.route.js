// backend/routes/employees.route.js
// Defines URL endpoints for the 'employees' entity and maps them to controller functions.
import express from 'express';
import * as employeesController from '../controllers/employees.controller.js';

const router = express.Router();

// Route to get all employees and create a new employee
router
    .route('/')
    .get(employeesController.getAllEmployees)
    .post(employeesController.createEmployee);

// Route to get, update, and soft-delete a specific employee by their ID
router
    .route('/:id')
    .get(employeesController.getEmployeeById)
    .put(employeesController.updateEmployee) // PUT for full update
    .patch(employeesController.softDeleteEmployee); // PATCH is ideal for partial updates like soft delete

export default router;
