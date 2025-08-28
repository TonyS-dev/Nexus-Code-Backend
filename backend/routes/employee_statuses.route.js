// backend/routes/gender.route.js
// Defines URL endpoints for the 'employee status' entity and maps them to controller functions.
import express from 'express';
import * as employeeStatusesController from '../controllers/employee_statuses.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// route to get all employee status and create a new role

router
    .route('/')
    .get(employeeStatusesController.getAllEmployeeStatuses)
    .post(employeeStatusesController.createEmployeeStatus);


// Route to get, update, and soft-delete a supecific employee status by their ID

router
    .route('/:id')
    .get(employeeStatusesController.getEmployeeStatusById)
    .put(employeeStatusesController.updateEmployeeStatus) // put for full 
    //.delete(employeeStatusesController.deleteEmployeeStatus)
    //.patch(employeeStatusesController.softDeleteEmployeeStatus); // patch is ideal for partial update like soft delete

export default router;