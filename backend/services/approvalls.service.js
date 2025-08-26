// backend/services/approvals.service.js
// Responsibility: Handle approval workflow for requests
import { query } from '../models/db_connection.js';

// Find all approvals
export const findAll = async () => {
    const res = await query(`
        SELECT 
            a.id,
            a.request_id,
            a.approver_id,
            a.status_id,
            a.comments,
            a.approval_date,
            r.request_type,
            e.first_name as approver_first_name,
            e.last_name as approver_last_name,
            rs.status_name
        FROM approvals a
        JOIN requests r ON a.request_id = r.id
        JOIN employees e ON a.approver_id = e.id
        JOIN request_statuses rs ON a.status_id = rs.id
        ORDER BY a.approval_date DESC
    `);
    return res.rows;
};

// Find approval by ID
export const findById = async (id) => {
    const res = await query(`
        SELECT 
            a.*,
            r.request_type,
            e.first_name as approver_first_name,
            e.last_name as approver_last_name,
            rs.status_name
        FROM approvals a
        JOIN requests r ON a.request_id = r.id
        JOIN employees e ON a.approver_id = e.id
        JOIN request_statuses rs ON a.status_id = rs.id
        WHERE a.id = $1
    `, [id]);
    return res.rows[0];
};

// Find approvals by request ID
export const findByRequestId = async (requestId) => {
    const res = await query(`
        SELECT 
            a.*,
            e.first_name as approver_first_name,
            e.last_name as approver_last_name,
            rs.status_name
        FROM approvals a
        JOIN employees e ON a.approver_id = e.id
        JOIN request_statuses rs ON a.status_id = rs.id
        WHERE a.request_id = $1
        ORDER BY a.approval_date DESC
    `, [requestId]);
    return res.rows;
};

// Create approval and update request status (transactional)
export const approveRequest = async (approvalData) => {
    const client = await query.connect?.() || { query: query };
    
    try {
        await client.query('BEGIN');

        // 1. Create approval record
        const approvalRes = await client.query(`
            INSERT INTO approvals (request_id, approver_id, status_id, comments)
            VALUES ($1, $2, $3, $4)
            RETURNING id
        `, [
            approvalData.request_id,
            approvalData.approver_id,
            approvalData.status_id,
            approvalData.comments
        ]);

        const approvalId = approvalRes.rows[0].id;

        // 2. Update request status
        await client.query(`
            UPDATE requests 
            SET status_id = $1, updated_at = now()
            WHERE id = $2
        `, [approvalData.status_id, approvalData.request_id]);

        // 3. If approved and it's a vacation request, update vacation balance
        if (approvalData.status_id === 'approved_status_id') { // You'll need to use actual approved status ID
            const requestRes = await client.query(`
                SELECT request_type FROM requests WHERE id = $1
            `, [approvalData.request_id]);

            if (requestRes.rows[0]?.request_type === 'vacation') {
                const vacationRes = await client.query(`
                    SELECT vr.days_requested, r.employee_id
                    FROM vacation_requests vr
                    JOIN requests r ON vr.id = r.id
                    WHERE vr.id = $1
                `, [approvalData.request_id]);

                if (vacationRes.rows.length > 0) {
                    const { days_requested, employee_id } = vacationRes.rows[0];
                    
                    await client.query(`
                        UPDATE vacation_balances 
                        SET days_taken = days_taken + $1
                        WHERE employee_id = $2 AND year = $3
                    `, [days_requested, employee_id, new Date().getFullYear()]);
                }
            }
        }

        await client.query('COMMIT');
        return approvalId;

    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        if (client.release) client.release();
    }
};

// Update approval
export const update = async (id, approvalData) => {
    const res = await query(`
        UPDATE approvals SET
            status_id = $1,
            comments = $2
        WHERE id = $3
        RETURNING *
    `, [
        approvalData.status_id,
        approvalData.comments,
        id
    ]);
    return res.rows[0];
};

// Find approvals by approver
export const findByApproverId = async (approverId) => {
    const res = await query(`
        SELECT 
            a.*,
            r.request_type,
            e.first_name as employee_first_name,
            e.last_name as employee_last_name,
            rs.status_name
        FROM approvals a
        JOIN requests r ON a.request_id = r.id
        JOIN employees e ON r.employee_id = e.id
        JOIN request_statuses rs ON a.status_id = rs.id
        WHERE a.approver_id = $1
        ORDER BY a.approval_date DESC
    `, [approverId]);
    return res.rows;
};