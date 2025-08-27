// backend/routes/employeeSalaries.route.js
import express from 'express';
import * as employeeSalariesController from '../controllers/employee_salaries.controller.js';

// { mergeParams: true } allows this router to access :employeeId from the parent route
const router = express.Router({ mergeParams: true });

// GET and POST on /employees/:employeeId/salaries
router
    .route('/')
    .get(employeeSalariesController.getEmployeeSalaries)
    .post(employeeSalariesController.addSalaryForEmployee);

export default router;
