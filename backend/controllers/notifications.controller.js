/**
 * @file notifications.controller.js
 * @description Controller for notifications endpoints
 */
import * as notificationsService from '../services/notifications.service.js';

// Get all notifications for the current user
export const getUserNotifications = async (req, res) => {
    const userId = req.user.id;
    const notifications = await notificationsService.findByRecipientId(userId);
    res.json({
        success: true,
        data: notifications
    });
};

// Get unread notification count
export const getUnreadCount = async (req, res) => {
    const userId = req.user.id;
    const count = await notificationsService.getUnreadCount(userId);
    res.json({
        success: true,
        data: { unread_count: count }
    });
};

// Mark notification as read
export const markAsRead = async (req, res) => {
    const { id } = req.params;
    const notification = await notificationsService.markAsRead(id);

    if (!notification) {
        return res.status(404).json({
            success: false,
            error: 'Notification not found'
        });
    }

    res.json({
        success: true,
        data: notification
    });
};

// Mark all notifications as read
export const markAllAsRead = async (req, res) => {
    const userId = req.user.id;
    const result = await notificationsService.markAllAsReadByRecipient(userId);
    res.json({
        success: true,
        data: result
    });
};

// Create a new notification (admin/system use)
export const createNotification = async (req, res) => {
    const { recipient_id, message, related_url } = req.body;

    if (!recipient_id || !message) {
        return res.status(400).json({
            success: false,
            error: 'Recipient ID and message are required'
        });
    }

    const notification = await notificationsService.create({
        recipient_id,
        message,
        related_url
    });

    res.status(201).json({
        success: true,
        data: notification
    });
};
