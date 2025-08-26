// backend/services/attached_documents.service.js
// Responsibility: Handle document attachments for requests
import { query } from '../models/db_connection.js';

// Find all attached documents
export const findAll = async () => {
    const res = await query(`
        SELECT 
            ad.*,
            r.request_type,
            e.first_name as uploader_first_name,
            e.last_name as uploader_last_name
        FROM attached_documents ad
        JOIN requests r ON ad.request_id = r.id
        JOIN employees e ON ad.uploaded_by = e.id
        ORDER BY ad.created_at DESC
    `);
    return res.rows;
};

// Find document by ID
export const findById = async (id) => {
    const res = await query(`
        SELECT 
            ad.*,
            r.request_type,
            e.first_name as uploader_first_name,
            e.last_name as uploader_last_name
        FROM attached_documents ad
        JOIN requests r ON ad.request_id = r.id
        JOIN employees e ON ad.uploaded_by = e.id
        WHERE ad.id = $1
    `, [id]);
    return res.rows[0];
};

// Find documents by request ID
export const findByRequestId = async (requestId) => {
    const res = await query(`
        SELECT 
            ad.*,
            e.first_name as uploader_first_name,
            e.last_name as uploader_last_name
        FROM attached_documents ad
        JOIN employees e ON ad.uploaded_by = e.id
        WHERE ad.request_id = $1
        ORDER BY ad.created_at DESC
    `, [requestId]);
    return res.rows;
};

// Upload document for a request
export const create = async (documentData) => {
    const {
        request_id,
        file_name,
        file_url,
        file_type,
        file_size,
        uploaded_by
    } = documentData;

    const res = await query(`
        INSERT INTO attached_documents (
            request_id, file_name, file_url, file_type, file_size, uploaded_by
        ) VALUES ($1, $2, $3, $4, $5, $6)
        RETURNING id
    `, [request_id, file_name, file_url, file_type, file_size, uploaded_by]);
    
    return res.rows[0].id;
};

// Update document metadata
export const update = async (id, documentData) => {
    const {
        file_name,
        file_url,
        file_type,
        file_size
    } = documentData;

    const res = await query(`
        UPDATE attached_documents SET
            file_name = $1,
            file_url = $2,
            file_type = $3,
            file_size = $4
        WHERE id = $5
        RETURNING *
    `, [file_name, file_url, file_type, file_size, id]);
    
    return res.rows[0];
};

// Delete document
//export const deleteDocument = async (id) => {
//    const res = await query(
//        'DELETE FROM attached_documents WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};

// Find documents by uploader
export const findByUploaderId = async (uploaderId) => {
    const res = await query(`
        SELECT 
            ad.*,
            r.request_type
        FROM attached_documents ad
        JOIN requests r ON ad.request_id = r.id
        WHERE ad.uploaded_by = $1
        ORDER BY ad.created_at DESC
    `, [uploaderId]);
    return res.rows;
};