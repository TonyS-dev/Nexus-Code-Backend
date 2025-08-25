// backend/routes/gender.route.js
// Defines URL endpoints for the 'gender' entity and maps them to controller functions.
import express from 'express';
import * as genderController from '../controllers/genders.controller.js';

const router = express.Router();

// route to get all gender and create a new role

router
    .route('/')
    .get(genderController.getAllGenders)
    .post(genderController.createGender);


// Route to get, update, and soft-delete a supecific gender by their ID

router
    .route('/:id')
    .get(genderController.getGenderById)
    .put(genderController.updateGender) // put for full 
    //.delete(genderController.deleteGender)
    //.patch(genderController.softDeleteGender); // patch is ideal for partial update like soft delete

export default router;