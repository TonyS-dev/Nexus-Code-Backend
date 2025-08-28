// backend/routes/access_levels.route.js
// Defines URL endpoints for the 'access_level' entity and maps them to controller functions.
import express from 'express';
import * as accessLevelsController from '../controllers/access_levels.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();
router.use(protect);

// route to get all roles and create a new access level

router
    .route('/')
    .get(accessLevelsController.getAllAccessLevels)
    .post(accessLevelsController.createAccesLeavel);


// Route to get, update, and soft-delete a supecific access level by their ID

router
    .route('/:id')
    .get(accessLevelsController.getAccesLevelById)
    .put(accessLevelsController.updateAccessLeavel) // put for full 
    //.delete(accessLevelsController.deleteAccessLevel)
    //.patch(accessLevelsController.softDeleteAccessLevel); // patch is ideal for partial update like soft delete

export default router;