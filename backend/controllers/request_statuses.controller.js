// backend/controllers/request_statuses.controller.js
// Responsibility: Handle HTTP requests for request statuses management
import * as requestStatusesService from '../services/request_statuses.service.js';

// GET /api/request-statuses - Get all request statuses
export const getAllRequestStatuses = async (req, res, next) => {
    const statuses = await requestStatusesService.findAll();
    res.status(200).json(statuses);
};

// GET /api/request-statuses/:id - Get a single request status by ID
export const getRequestStatusById = async (req, res, next) => {
    const { id } = req.params;
    const status = await requestStatusesService.findById(id);
    
    if (!status) {
        return res.status(404).json({ error: 'Request status not found' });
    }
    
    res.status(200).json(status);
};

// POST /api/request-statuses - Create a new request status
export const createRequestStatus = async (req, res, next) => {
    const { name } = req.body;
    
    if (!name) {
        return res.status(400).json({ error: 'name is required' });
    }
    
    const statusData = { name: name.trim() };
    const statusId = await requestStatusesService.create(statusData);
    const newStatus = await requestStatusesService.findById(statusId);
    
    res.status(201).json(newStatus);
};

// PUT /api/request-statuses/:id - Update a request status
export const updateRequestStatus = async (req, res, next) => {
    const { id } = req.params;
    const { name } = req.body;
    
    if (!name) {
        return res.status(400).json({ error: 'name is required' });
    }
    
    const existingStatus = await requestStatusesService.findById(id);
    if (!existingStatus) {
        return res.status(404).json({ error: 'Request status not found' });
    }
    
    const statusData = { name: name.trim() };
    const updatedStatus = await requestStatusesService.update(id, statusData);
    
    res.status(200).json(updatedStatus);
};