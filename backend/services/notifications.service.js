/**
 * @file notifications.service.js
 * @description Database service for notifications management
 */
import { query } from '../models/db_connection.js';

// Get notifications for a specific user
export const findByRecipientId = async (recipientId) => {
    const res = await query(`
        SELECT 
            id,
            recipient_id,
            message,
            is_read,
            related_url,
            sent_date
        FROM notifications 
        WHERE recipient_id = $1
        ORDER BY sent_date DESC
    `, [recipientId]);
    return res.rows;
};

// Mark notification as read
export const markAsRead = async (notificationId) => {
    const res = await query(`
        UPDATE notifications 
        SET is_read = true
        WHERE id = $1
        RETURNING *
    `, [notificationId]);
    return res.rows[0];
};

// Mark all notifications as read for a user
export const markAllAsReadByRecipient = async (recipientId) => {
    const res = await query(`
        UPDATE notifications 
        SET is_read = true
        WHERE recipient_id = $1 AND is_read = false
        RETURNING count(*) as updated_count
    `, [recipientId]);
    return res.rows[0];
};

// Create a new notification
export const create = async (notificationData) => {
    const { recipient_id, message, related_url } = notificationData;
    const res = await query(`
        INSERT INTO notifications (recipient_id, message, related_url)
        VALUES ($1, $2, $3)
        RETURNING *
    `, [recipient_id, message, related_url || null]);
    return res.rows[0];
};

// Get unread count for a user
export const getUnreadCount = async (recipientId) => {
    const res = await query(`
        SELECT COUNT(*) as unread_count
        FROM notifications 
        WHERE recipient_id = $1 AND is_read = false
    `, [recipientId]);
    return parseInt(res.rows[0].unread_count);
};

// Delete a notification
export const deleteById = async (notificationId) => {
    const res = await query(`
        DELETE FROM notifications 
        WHERE id = $1
        RETURNING *
    `, [notificationId]);
    return res.rows[0];
};