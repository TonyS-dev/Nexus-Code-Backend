// backend/controllers/attached_documents.controller.js
// Responsibility: Handle HTTP requests for document attachments
import * as attachedDocumentsService from '../services/attached_documents.service.js';

// GET /api/documents - Get all attached documents
export const getAllDocuments = async (req, res, next) => {
    const documents = await attachedDocumentsService.findAll();
    res.status(200).json(documents);
};

// GET /api/documents/:id - Get a single document by ID
export const getDocumentById = async (req, res, next) => {
    const { id } = req.params;
    const document = await attachedDocumentsService.findById(id);
    
    if (!document) {
        return res.status(404).json({ error: 'Document not found' });
    }
    
    res.status(200).json(document);
};

// GET /api/documents/request/:requestId - Get documents for a specific request
export const getDocumentsByRequest = async (req, res, next) => {
    const { requestId } = req.params;
    const documents = await attachedDocumentsService.findByRequestId(requestId);
    res.status(200).json(documents);
};

// POST /api/documents - Upload a document for a request
export const uploadDocument = async (req, res) => {
    const {
        request_id,
        file_name,
        file_url,
        file_type,
        file_size,
        uploaded_by
    } = req.body;
    // Validation
    if (
        !request_id || 
        !file_name || 
        !file_url || 
        !uploaded_by
    ) {
        return res.status(400).json({ 
            error: 'request_id, file_name, file_url, and uploaded_by are required' 
        });
    }
    if (file_name.trim() === '') {
        return res.status(400).json({ error: 'file_name cannot be empty' });
    }
    if (file_url.trim() === '') {
        return res.status(400).json({ error: 'file_url cannot be empty' });
    }
    if (file_size && file_size < 0) {
        return res.status(400).json({ error: 'file_size must be non-negative' });
    }
    const documentData = {
        request_id,
        file_name: file_name.trim(),
        file_url: file_url.trim(),
        file_type: file_type?.trim() || null,
        file_size: file_size || null,
        uploaded_by
    };
    const documentId = await attachedDocumentsService.create(documentData);
    const newDocument = await attachedDocumentsService.findById(documentId);
    
    res.status(201).json(newDocument);
};

// PUT /api/documents/:id - Update document metadata
export const updateDocument = async (req, res, next) => {
    const { id } = req.params;
    const { file_name, file_url, file_type, file_size } = req.body;
    // Check if document exists
    const existingDocument = await attachedDocumentsService.findById(id);
    if (!existingDocument) {
        return res.status(404).json({ error: 'Document not found' });
    }
    // Validation
    if (
        !file_name || 
        !file_url
    ) {
        return res.status(400).json({ error: 'file_name and file_url are required' });
    }
    if (file_name.trim() === '') {
        return res.status(400).json({ error: 'file_name cannot be empty' });
    }
    if (file_url.trim() === '') {
        return res.status(400).json({ error: 'file_url cannot be empty' });
    }
    if (file_size && file_size < 0) {
        return res.status(400).json({ error: 'file_size must be non-negative' });
    }
    const documentData = {
        file_name: file_name.trim(),
        file_url: file_url.trim(),
        file_type: file_type?.trim() || null,
        file_size: file_size || null
    };
    const updatedDocument = await attachedDocumentsService.update(id, documentData);
    res.status(200).json(updatedDocument);
};


// GET /api/documents/uploader/:uploaderId - Get documents by uploader
export const getDocumentsByUploader = async (req, res, next) => {
    const { uploaderId } = req.params;
    const documents = await attachedDocumentsService.findByUploaderId(uploaderId);
    res.status(200).json(documents);
};