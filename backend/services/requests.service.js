// backend/services/requests.service.js
// Responsibility: Handle the business logic for requests (supertype/subtype pattern)
import { query } from '../models/db_connection.js';

// Find all requests with their specific data (JOIN with subtypes)
export const findAll = async () => {
    const res = await query(`
        SELECT 
            r.id,
            r.employee_id,
            r.request_type,
            r.status_id,
            r.created_at,
            r.updated_at,
            e.first_name,
            e.last_name,
            rs.name
        FROM requests r
        JOIN employees e ON r.employee_id = e.id
        JOIN request_statuses rs ON r.status_id = rs.id
        ORDER BY r.created_at DESC
    `);
    return res.rows;
};

// Find a single request by ID with its specific subtype data
export const findById = async (id) => {
    const res = await query(`
        SELECT 
            r.id,
            r.employee_id,
            r.request_type,
            r.status_id,
            r.created_at,
            r.updated_at,
            e.first_name,
            e.last_name,
            e.email,
            rs.name
        FROM requests r
        JOIN employees e ON r.employee_id = e.id
        JOIN request_statuses rs ON r.status_id = rs.id
        WHERE r.id = $1
    `, [id]);
    
    const request = res.rows[0];
    if (!request) return null;

    // Get specific subtype data based on request_type
    let specificData = null;
    switch (request.request_type) {
        case 'vacation':
            specificData = await getVacationRequestData(id);
            break;
        case 'leave':
            specificData = await getLeaveRequestData(id);
            break;
        case 'certificate':
            specificData = await getCertificateRequestData(id);
            break;
    }

    return {
        ...request,
        specific_data: specificData
    };
};

// Create a vacation request (transactional)
export const createVacationRequest = async (requestData) => {
    const client = await query.connect?.() || { query: query };
    
    await client.query('BEGIN');

    // 1. Check vacation balance
    const balanceRes = await client.query(`
        SELECT available_days, days_taken 
        FROM vacation_balances 
        WHERE employee_id = $1 AND year = $2
    `, [requestData.employee_id, new Date().getFullYear()]);

    if (balanceRes.rows.length === 0) {
        await client.query('ROLLBACK');
        if (client.release) client.release();
        throw new Error('No vacation balance found for current year');
    }

    const balance = balanceRes.rows[0];
    const remainingDays = balance.available_days - balance.days_taken;

    if (remainingDays < requestData.days_requested) {
        await client.query('ROLLBACK');
        if (client.release) client.release();
        throw new Error(`Insufficient vacation days. Available: ${remainingDays}, Requested: ${requestData.days_requested}`);
    }

    // 2. Insert into requests table
    const requestRes = await client.query(`
        INSERT INTO requests (employee_id, request_type, status_id)
        VALUES ($1, 'vacation', $2)
        RETURNING id
    `, [requestData.employee_id, requestData.status_id]);

    const requestId = requestRes.rows[0].id;

    // 3. Insert into vacation_requests table
    await client.query(`
        INSERT INTO vacation_requests (
            id, vacation_type_id, start_date, end_date, 
            days_requested, comments, is_paid, payment_amount
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    `, [
        requestId,
        requestData.vacation_type_id,
        requestData.start_date,
        requestData.end_date,
        requestData.days_requested,
        requestData.comments,
        requestData.is_paid || false,
        requestData.payment_amount
    ]);

    await client.query('COMMIT');
    if (client.release) client.release();
    
    return requestId;
};

// Create a leave request (transactional)
export const createLeaveRequest = async (requestData) => {
    const client = await query.connect?.() || { query: query };
    
    await client.query('BEGIN');

    // 1. Insert into requests table
    const requestRes = await client.query(`
        INSERT INTO requests (employee_id, request_type, status_id)
        VALUES ($1, 'leave', $2)
        RETURNING id
    `, [requestData.employee_id, requestData.status_id]);

    const requestId = requestRes.rows[0].id;

    // 2. Insert into leave_requests table
    await client.query(`
        INSERT INTO leave_requests (
            id, leave_type_id, start_date, end_date, 
            reason, is_paid, payment_amount
        ) VALUES ($1, $2, $3, $4, $5, $6, $7)
    `, [
        requestId,
        requestData.leave_type_id,
        requestData.start_date,
        requestData.end_date,
        requestData.reason,
        requestData.is_paid || false,
        requestData.payment_amount
    ]);

    await client.query('COMMIT');
    if (client.release) client.release();
    
    return requestId;
};

// Create a certificate request (transactional)
export const createCertificateRequest = async (requestData) => {
    const client = await query.connect?.() || { query: query };
    
    await client.query('BEGIN');

    // 1. Insert into requests table
    const requestRes = await client.query(`
        INSERT INTO requests (employee_id, request_type, status_id)
        VALUES ($1, 'certificate', $2)
        RETURNING id
    `, [requestData.employee_id, requestData.status_id]);

    const requestId = requestRes.rows[0].id;

    // 2. Insert into certificate_requests table
    await client.query(`
        INSERT INTO certificate_requests (id, certificate_type_id, comments)
        VALUES ($1, $2, $3)
    `, [requestId, requestData.certificate_type_id, requestData.comments]);

    await client.query('COMMIT');
    if (client.release) client.release();
    
    return requestId;
};

// Update request status
export const updateRequestStatus = async (id, statusId) => {
    const res = await query(`
        UPDATE requests 
        SET status_id = $1, updated_at = now()
        WHERE id = $2
        RETURNING *
    `, [statusId, id]);
    return res.rows[0];
};

// Get requests by employee
export const findByEmployeeId = async (employeeId) => {
    const res = await query(`
        SELECT 
            r.id,
            r.request_type,
            r.status_id,
            r.created_at,
            rs.name
        FROM requests r
        JOIN request_statuses rs ON r.status_id = rs.id
        WHERE r.employee_id = $1
        ORDER BY r.created_at DESC
    `, [employeeId]);
    return res.rows;
};

// Helper functions to get specific request type data
const getVacationRequestData = async (requestId) => {
    const res = await query(`
        SELECT 
            vr.*,
            vt.name as vacation_type_name
        FROM vacation_requests vr
        JOIN vacation_types vt ON vr.vacation_type_id = vt.id
        WHERE vr.id = $1
    `, [requestId]);
    return res.rows[0];
};

const getLeaveRequestData = async (requestId) => {
    const res = await query(`
        SELECT 
            lr.*,
            lt.name as leave_type_name
        FROM leave_requests lr
        JOIN leave_types lt ON lr.leave_type_id = lt.id
        WHERE lr.id = $1
    `, [requestId]);
    return res.rows[0];
};

const getCertificateRequestData = async (requestId) => {
    const res = await query(`
        SELECT 
            cr.*,
            ct.name as certificate_type_name
        FROM certificate_requests cr
        JOIN certificate_types ct ON cr.certificate_type_id = ct.id
        WHERE cr.id = $1
    `, [requestId]);
    return res.rows[0];
};
