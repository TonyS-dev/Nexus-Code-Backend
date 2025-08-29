// backend/routes/employees.route.js
import express from 'express';
import * as employeesController from '../controllers/employees.controller.js';
import { protect } from '../middleware/auth.middleware.js';
import employeeRolesRouter from './roles.route.js';
import employeeSalariesRouter from './employee_salaries.route.js';
import * as historyController from '../controllers/employee_histories.controller.js';

const router = express.Router();

// Apply protection to all employee routes
router.use(protect);

// --- Nested Routes ---
// Any route starting with /:employeeId/roles will be handled by employeeRolesRouter
router.use('/:employeeId/roles', employeeRolesRouter);
// Any route starting with /:employeeId/salaries will be handled by employeeSalariesRouter
router.use('/:employeeId/salaries', employeeSalariesRouter);

router
    .route('/:employeeId/history')
    .get(historyController.getHistoryByEmployeeId);

// --- Main Employee Routes ---
router
    .route('/')
    .get(employeesController.getAllEmployees)
    .post(employeesController.createEmployee);

router
    .route('/:id')
    .get(employeesController.getEmployeeById)
    .put(employeesController.updateEmployee)
    .patch(employeesController.softDeleteEmployee);

export default router;
