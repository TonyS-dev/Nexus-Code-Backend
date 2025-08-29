// backend/controllers/requests.controller.js
// Responsibility: Handle HTTP requests for the requests business logic
import * as requestsService from '../services/requests.service.js';

// GET /api/requests - Get all requests
export const getAllRequests = async (req, res, next) => {
    const requests = await requestsService.findAll();
    res.status(200).json(requests);
};

// GET /api/requests/:id - Get a single request with specific data
export const getRequestById = async (req, res, next) => {
    const { id } = req.params;
    const request = await requestsService.findById(id);
    
    if (!request) {
        return res.status(404).json({ error: 'Request not found' });
    }
    
    res.status(200).json(request);
    
};

// POST /api/requests/vacation - Create a vacation request
export const createVacationRequest = async (req, res, next) => {
    const {
        employee_id,
        vacation_type_id,
        start_date,
        end_date,
        days_requested,
        comments,
        is_paid,
        payment_amount,
        status_id
    } = req.body;
    // Validation
    if (
        !employee_id || 
        !vacation_type_id || 
        !start_date || 
        !end_date || 
        !days_requested || 
        !status_id
    ) {
        return res.status(400).json({ 
            error: 'employee_id, vacation_type_id, start_date, end_date, days_requested, and status_id are required' 
        });
    }
    if (days_requested <= 0) {
        return res.status(400).json({ error: 'days_requested must be greater than 0' });
    }
    if (new Date(end_date) < new Date(start_date)) {
        return res.status(400).json({ error: 'end_date must be after start_date' });
    }
    const requestData = {
        employee_id,
        vacation_type_id,
        start_date,
        end_date,
        days_requested: parseInt(days_requested),
        comments: comments?.trim() || null,
        is_paid: is_paid || false,
        payment_amount: payment_amount || null,
        status_id
    };
    const requestId = await requestsService.createVacationRequest(requestData);
    
    res.status(201).json({
        id: requestId,
        message: 'Vacation request created successfully'
    });

};

// POST /api/requests/leave - Create a leave request
export const createLeaveRequest = async (req, res, next) => {
    const {
        employee_id,
        leave_type_id,
        start_date,
        end_date,
        reason,
        is_paid,
        payment_amount,
        status_id
    } = req.body;
    // Validation
    if (
        !employee_id || 
        !leave_type_id || 
        !start_date || 
        !end_date || 
        !reason || 
        !status_id
    ) {
        return res.status(400).json({ 
            error: 'employee_id, leave_type_id, start_date, end_date, reason, and status_id are required' 
        });
    }
    if (reason.trim() === '') {
        return res.status(400).json({ error: 'reason cannot be empty' });
    }
    if (new Date(end_date) < new Date(start_date)) {
        return res.status(400).json({ error: 'end_date must be after start_date' });
    }
    const requestData = {
        employee_id,
        leave_type_id,
        start_date,
        end_date,
        reason: reason.trim(),
        is_paid: is_paid || false,
        payment_amount: payment_amount || null,
        status_id
    };
    const requestId = await requestsService.createLeaveRequest(requestData);
    
    res.status(201).json({
        id: requestId,
        message: 'Leave request created successfully'
    });
};

// POST /api/requests/certificate - Create a certificate request
export const createCertificateRequest = async (req, res, next) => {

    const {
        employee_id,
        certificate_type_id,
        comments,
        status_id
    } = req.body;
    // Validation
    if (
        !employee_id || 
        !certificate_type_id || 
        !status_id
    ) {
        return res.status(400).json({ 
            error: 'employee_id, certificate_type_id, and status_id are required' 
        });
    }
    const requestData = {
        employee_id,
        certificate_type_id,
        comments: comments?.trim() || null,
        status_id
    };
    const requestId = await requestsService.createCertificateRequest(requestData);
    
    res.status(201).json({
        id: requestId,
        message: 'Certificate request created successfully'
    });

};

// PUT /api/requests/:id/status - Update request status
export const updateRequestStatus = async (req, res, next) => {

    const { id } = req.params;
    const { status_id } = req.body;
    // Validation
    if (!status_id) {
        return res.status(400).json({ error: 'status_id is required' });
    }
    // Check if request exists
    const existingRequest = await requestsService.findById(id);
    if (!existingRequest) {
        return res.status(404).json({ error: 'Request not found' });
    }
    const updatedRequest = await requestsService.updateRequestStatus(id, status_id);
    res.status(200).json(updatedRequest);

};

// GET /api/requests/employee/:employeeId - Get requests by employee
export const getRequestsByEmployee = async (req, res, next) => {

    const { employeeId } = req.params;
    const requests = await requestsService.findByEmployeeId(employeeId);
    res.status(200).json(requests);
};

