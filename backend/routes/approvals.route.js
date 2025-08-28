// backend/routes/approvals.routes.js
// Responsibility: Define routes for approvals endpoints
import express from 'express';
import * as approvalsController from '../controllers/approvals.controller.js';
import { protect } from '../middleware/auth.middleware.js';

const router = express.Router();
router.use(protect);

// Routes for general approval operations
router
    .route('/')
    .get(approvalsController.getAllApprovals);

// Routes for approving/rejecting requests
router
    .route('/requests/:id/approve')
    .post(approvalsController.approveRequest);

// Routes for approvals by specific request
router
    .route('/request/:requestId')
    .get(approvalsController.getApprovalsByRequest);

// Routes for approvals by approver
router
    .route('/approver/:approverId')
    .get(approvalsController.getApprovalsByApprover);

// Routes for specific approval by ID (must be last to avoid conflicts)
router
    .route('/:id')
    .get(approvalsController.getApprovalById)
    .put(approvalsController.updateApproval);

export default router;