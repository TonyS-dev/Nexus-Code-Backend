// backend/routes/vacation_type.router.js
// Defines URL endpoints for the 'vacation_type' entity and maps them to controller functions.
import express from 'express';
import * as vacationTypeController from '../controllers/vacation_types.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// route to get all vacation types and create a new role

router
    .route('/')
    .get(vacationTypeController.getAllVactionType)
    .post(vacationTypeController.createVacationType);


// Route to get, update, a supecific vacation type by their ID

router
    .route('/:id')
    .get(vacationTypeController.getVacationTypeById)
    .put(vacationTypeController.updateVacationType) // put for full 

export default router;