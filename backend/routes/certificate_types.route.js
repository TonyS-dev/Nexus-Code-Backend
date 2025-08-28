// backend/routes/certificate_type.route.js
// Defines URL endpoints for the 'roles' entity and maps them to controller functions.
import express from 'express';
import * as certificateTypeController from '../controllers/certificate_types.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);
// route to get all certificate type and create a new certificate type

router
    .route('/')
    .get(certificateTypeController.getAllCertificateType)
    .post(certificateTypeController.createCertificateType);


// Route to get, update, a supecific certificate type by their ID

router
    .route('/:id')
    .get(certificateTypeController.getCertificateTypeById)
    .put(certificateTypeController.updatedCertificateType) // put for full 


export default router;