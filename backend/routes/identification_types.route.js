// backend/routes/identification_type.route.js
// Defines URL endpoints for the 'employees' entity and maps them to controller functions.
import express from 'express';
import * as identificationTypeController from '../controllers/identification_types.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// Route to get all identification type and create a new identification type

router
    .route('/')
    .get(identificationTypeController.getAllIdentificationType)
    .post(identificationTypeController.createIdentificationType)

// Route to get, update, a specific identification type by their ID

router
    .route('/:id')
    .get(identificationTypeController.getIdentificationTypeById)
    .put(identificationTypeController.updateIdentificationType)

export default router;