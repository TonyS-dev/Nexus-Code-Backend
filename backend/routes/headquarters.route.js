// backend/routes/Headquarter.route.js
// Defines URL endpoints for the 'Headquarter' entity and maps them to controller functions.
import express from 'express';
import * as headquarterController from '../controllers/headquarters.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// route to get all Headquarter and create a new role

router
    .route('/')
    .get(headquarterController.getAllHeadquarters)
    .post(headquarterController.createHeadquarter);


// Route to get, update, and soft-delete a supecific Headquarter by their ID

router
    .route('/:id')
    .get(headquarterController.getHeadquarterById)
    .put(headquarterController.updateHeadquarter) // put for full 
    //.delete(headquarterController.deleteHeadquarter)
    //.patch(headquarterController.softDeleteHeadquarter); // patch is ideal for partial update like soft delete

export default router;