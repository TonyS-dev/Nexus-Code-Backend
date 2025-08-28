// backend/routes/leave_type.route.js
// Defines URL endpoints for the 'leave_type' entity and maps them to controller functions.
import express from 'express';
import * as leaveTypeController from '../controllers/leave_types.controller.js';

const router = express.Router();

// route to get all leave type and create a new role

router
    .route('/')
    .get(leaveTypeController.getAllLeaveType)
    .post(leaveTypeController.createLeaveType);


// Route to get, update, a supecific leave type by their ID

router
    .route('/:id')
    .get(leaveTypeController.getLeaveTypeById)
    .put(leaveTypeController.updateLeaveType) // put for full 
    // .delete(rolesController.deleteRole)
    //.patch(rolesController.softDeleteRole); // patch is ideal for partial update like soft delete

export default router;