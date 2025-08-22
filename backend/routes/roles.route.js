

import express from 'express';
import * as rolesController from '../controllers/roles.controller.js';

const router = express.Router();

// route to get all roles and create a new role

router
    .route('/')
    .get(rolesController.getAllRoles)
    .post(rolesController.createRole);


// Route to get, update, and soft-delete a supecific employee by their ID

router
    .route('/:id')
    .get(rolesController.getRoleById)
    .put(rolesController.updateRole) // put for full update
    //.patch(rolesController.softDeleteRole); // patch is ideal for partial update like soft delete

export default router;