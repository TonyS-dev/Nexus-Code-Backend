// backend/routes/requests.routes.js
// Responsibility: Define routes for requests endpoints
import express from 'express';
import * as requestsController from '../controllers/requests.controller.js';

const router = express.Router();

// Routes for general requests operations
router
    .route('/')
    .get(requestsController.getAllRequests);

// Routes for specific request types
router
    .route('/vacation')
    .post(requestsController.createVacationRequest);

router
    .route('/leave')
    .post(requestsController.createLeaveRequest);

router
    .route('/certificate')
    .post(requestsController.createCertificateRequest);

// Routes for employee-specific requests
router
    .route('/employee/:employeeId')
    .get(requestsController.getRequestsByEmployee);

// Routes for specific request by ID
router
    .route('/:id')
    .get(requestsController.getRequestById);

// Routes for request status updates
router
    .route('/:id/status')
    .put(requestsController.updateRequestStatus);

export default router;