// backend/routes/users.routes.js
// Responsibility: To define the URL routes for the 'users' entity and map them to controller methods.

import express from 'express';
import * as usersController from '../controllers/usersController.js';

const router = express.Router();


// Route to get all users and create a new user
router.route('/')
    .get(usersController.getAllUsers)
    .post(usersController.createUser);
    
// Route to get, update, and delete a specific user by their ID
router.route('/:id')
    .get(usersController.getUserById)


export default router;
