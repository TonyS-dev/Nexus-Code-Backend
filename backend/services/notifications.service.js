// backend/services/notifications.service.js
// Responsibility: Handle in-app notifications for users (not full CRUD as mentioned in requirements)
import { query } from '../models/db_connection.js';

// Find all notifications
export const findAll = async () => {
    const res = await query(`
        SELECT 
            n.*,
            e.first_name,
            e.last_name,
            e.email
        FROM notifications n
        JOIN employees e ON n.recipient_id = e.id
        WHERE e.is_deleted = false
        ORDER BY n.sent_date DESC
    `);
    return res.rows;
};

// Find notification by ID
export const findById = async (id) => {
    const res = await query(`
        SELECT 
            n.*,
            e.first_name,
            e.last_name,
            e.email
        FROM notifications n
        JOIN employees e ON n.recipient_id = e.id
        WHERE n.id = $1 AND e.is_deleted = false
    `, [id]);
    return res.rows[0];
};

// Find notifications by recipient
export const findByRecipientId = async (recipientId) => {
    const res = await query(`
        SELECT * FROM notifications 
        WHERE recipient_id = $1 
        ORDER BY sent_date DESC
    `, [recipientId]);
    return res.rows;
};

// Find unread notifications by recipient
export const findUnreadByRecipientId = async (recipientId) => {
    const res = await query(`
        SELECT * FROM notifications 
        WHERE recipient_id = $1 AND is_read = false 
        ORDER BY sent_date DESC
    `, [recipientId]);
    return res.rows;
};

// Create notification
export const create = async (notificationData) => {
    const {
        recipient_id,
        message,
        related_url
    } = notificationData;

    const res = await query(`
        INSERT INTO notifications (recipient_id, message, related_url)
        VALUES ($1, $2, $3)
        RETURNING id
    `, [recipient_id, message, related_url]);
    
    return res.rows[0].id;
};

// Mark notification as read
export const markAsRead = async (id) => {
    const res = await query(`
        UPDATE notifications 
        SET is_read = true 
        WHERE id = $1
        RETURNING *
    `, [id]);
    return res.rows[0];
};

// Mark all notifications as read for a user (PATCH route)
export const markAllAsReadForUser = async (recipientId) => {
    const res = await query(`
        UPDATE notifications 
        SET is_read = true 
        WHERE recipient_id = $1 AND is_read = false
        RETURNING count(*)
    `, [recipientId]);
    return res.rowCount;
};

//// Delete notification
//export const deleteNotification = async (id) => {
//    const res = await query(
//        'DELETE FROM notifications WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};

// Get notification count for user
export const getNotificationCounts = async (recipientId) => {
    const res = await query(`
        SELECT 
            COUNT(*) as total_notifications,
            COUNT(CASE WHEN is_read = false THEN 1 END) as unread_count,
            COUNT(CASE WHEN is_read = true THEN 1 END) as read_count
        FROM notifications 
        WHERE recipient_id = $1
    `, [recipientId]);
    return res.rows[0];
};

//// Helper function to create notifications for request events
//export const createRequestNotification = async (requestId, recipientId, eventType, requestType) => {
//    let message = '';
//    let relatedUrl = `/requests/${requestId}`;
//
//    switch (eventType) {
//        case 'created':
//            message = `New ${requestType} request has been submitted and is pending approval.`;
//            break;
//        case 'approved':
//            message = `Your ${requestType} request has been approved.`;
//            break;
//        case 'rejected':
//            message = `Your ${requestType} request has been rejected.`;
//            break;
//        case 'needs_approval':
//            message = `A ${requestType} request requires your approval.`;
//            relatedUrl = `/approvals/pending`;
//            break;
//        default:
//            message = `Update on your ${requestType} request.`;
//    }
//
//    return await create({
//        recipient_id: recipientId,
//        message,
//        related_url: relatedUrl
//    });
//};