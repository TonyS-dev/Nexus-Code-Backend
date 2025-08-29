// backend/routes/request_statuses.route.js
// Responsibility: Define routes for request statuses endpoints
import express from 'express';
import * as requestStatusesController from '../controllers/request_statuses.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();

router.use(protect);

// Routes for general request statuses operations
router
    .route('/')
    .get(requestStatusesController.getAllRequestStatuses)
    .post(requestStatusesController.createRequestStatus);

// Routes for specific request status by ID
router
    .route('/:id')
    .get(requestStatusesController.getRequestStatusById)
    .put(requestStatusesController.updateRequestStatus);

export default router;