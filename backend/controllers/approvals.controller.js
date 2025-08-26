// backend/controllers/approvals.controller.js
// Responsibility: Handle HTTP requests for approvals
import * as approvalsService from '../services/approvals.service.js';

// GET /api/approvals - Get all approvals
export const getAllApprovals = async (req, res, next) => {
    const approvals = await approvalsService.findAll();
    res.status(200).json(approvals);
};

// GET /api/approvals/:id - Get a single approval by ID
export const getApprovalById = async (req, res, next) => {
    const { id } = req.params;
    const approval = await approvalsService.findById(id);
    
    if (!approval) {
        return res.status(404).json({ error: 'Approval not found' });
    }
    
    res.status(200).json(approval);

};

// GET /api/approvals/request/:requestId - Get approvals for a specific request
export const getApprovalsByRequest = async (req, res, next) => {
    const { requestId } = req.params;
    const approvals = await approvalsService.findByRequestId(requestId);
    res.status(200).json(approvals);

};

// POST /api/requests/:id/approve - Approve/reject a request
export const approveRequest = async (req, res, next) => {
    const { id: requestId } = req.params;
    const { approver_id, status_id, comments } = req.body;
    // Validation
    if (
        !approver_id || 
        !status_id
    ) {
        return res.status(400).json({ 
            error: 'approver_id and status_id are required' 
        });
    }
    const approvalData = {
        request_id: requestId,
        approver_id,
        status_id,
        comments: comments?.trim() || null
    };
    const approvalId = await approvalsService.approveRequest(approvalData);
    const newApproval = await approvalsService.findById(approvalId);
    
    res.status(201).json({
        message: 'Request processed successfully',
        approval: newApproval
    });

};

// PUT /api/approvals/:id - Update an approval
export const updateApproval = async (req, res, next) => {
    const { id } = req.params;
    const { status_id, comments } = req.body;
    // Check if approval exists
    const existingApproval = await approvalsService.findById(id);
    if (!existingApproval) {
        return res.status(404).json({ error: 'Approval not found' });
    }
    // Validation
    if (!status_id) {
        return res.status(400).json({ error: 'status_id is required' });
    }
    const approvalData = {
        status_id,
        comments: comments?.trim()
    };
    const updatedApproval = await approvalsService.update(id, approvalData);
    res.status(200).json(updatedApproval);

};

// GET /api/approvals/approver/:approverId - Get approvals by approver
export const getApprovalsByApprover = async (req, res, next) => {
    const { approverId } = req.params;
    const approvals = await approvalsService.findByApproverId(approverId);
    res.status(200).json(approvals);
};