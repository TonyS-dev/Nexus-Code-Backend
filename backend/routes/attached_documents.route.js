// backend/routes/attached_documents.routes.js
// Responsibility: Define routes for document attachment endpoints
import express from 'express';
import * as attachedDocumentsController from '../controllers/attached_documents.controller.js';

const router = express.Router();

// Routes for general document operations
router
    .route('/')
    .get(attachedDocumentsController.getAllDocuments)
    .post(attachedDocumentsController.uploadDocument);

// Routes for documents by specific request
router
    .route('/request/:requestId')
    .get(attachedDocumentsController.getDocumentsByRequest);

// Routes for documents by uploader
router
    .route('/uploader/:uploaderId')
    .get(attachedDocumentsController.getDocumentsByUploader);

// Routes for specific document by ID (must be last to avoid conflicts)
router
    .route('/:id')
    .get(attachedDocumentsController.getDocumentById)
    .put(attachedDocumentsController.updateDocument)
    //.delete(attachedDocumentsController.deleteDocument);

export default router;