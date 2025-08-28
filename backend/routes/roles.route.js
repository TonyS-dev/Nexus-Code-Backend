// backend/routes/roles.route.js
// Defines URL endpoints for the 'roles' entity and maps them to controller functions.
import express from 'express';
import * as rolesController from '../controllers/roles.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// route to get all roles and create a new role

router
    .route('/')
    .get(rolesController.getAllRoles)
    .post(rolesController.createRole);

// Route to get, update, and soft-delete a supecific role by their ID

router
    .route('/:id')
    .get(rolesController.getRoleById)
    .put(rolesController.updateRole) // put for full 
    // .delete(rolesController.deleteRole)
    //.patch(rolesController.softDeleteRole); // patch is ideal for partial update like soft delete

export default router;