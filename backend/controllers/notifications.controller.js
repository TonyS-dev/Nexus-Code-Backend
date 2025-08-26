// backend/controllers/notifications.controller.js
// Responsibility: Handle HTTP requests for notifications (simplified CRUD as per requirements)
import * as notificationsService from '../services/notifications.service.js';

// GET /api/notifications - Get all notifications
export const getAllNotifications = async (req, res, next) => {
        const notifications = await notificationsService.findAll();
        res.status(200).json(notifications);
};

// GET /api/notifications/:id - Get a single notification by ID
export const getNotificationById = async (req, res) => {
    const { id } = req.params;
    const notification = await notificationsService.findById(id);
    
    if (!notification) {
        return res.status(404).json({ error: 'Notification not found' });
    }
    
    res.status(200).json(notification);
};

// GET /api/notifications/user/:userId - Get notifications for a specific user
export const getNotificationsByUser = async (req, res, next) => {
    const { userId } = req.params;
    const { unread_only } = req.query;
    
    let notifications;
    if (unread_only === 'true') {
        notifications = await notificationsService.findUnreadByRecipientId(userId);
    } else {
        notifications = await notificationsService.findByRecipientId(userId);
    }
    
    res.status(200).json(notifications);
};

// GET /api/notifications/user/:userId/counts - Get notification counts for a user
export const getNotificationCounts = async (req, res, next) => {
    const { userId } = req.params;
    const counts = await notificationsService.getNotificationCounts(userId);
    res.status(200).json(counts);
};

// POST /api/notifications - Create a notification
export const createNotification = async (req, res, next) => {
    const { recipient_id, message, related_url } = req.body;
    // Validation
    if (
        !recipient_id || 
        !message
    ) {
        return res.status(400).json({ 
            error: 'recipient_id and message are required' 
        });
    }
    if (message.trim() === '') {
        return res.status(400).json({ error: 'message cannot be empty' });
    }
    const notificationData = {
        recipient_id,
        message: message.trim(),
        related_url: related_url?.trim() || null
    };
    const notificationId = await notificationsService.create(notificationData);
    const newNotification = await notificationsService.findById(notificationId);
    
    res.status(201).json(newNotification);
};

// PATCH /api/notifications/:id/read - Mark notification as read
export const markNotificationAsRead = async (req, res, next) => {
    const { id } = req.params;
    // Check if notification exists
    const existingNotification = await notificationsService.findById(id);
    if (!existingNotification) {
        return res.status(404).json({ error: 'Notification not found' });
    }
    const updatedNotification = await notificationsService.markAsRead(id);
    res.status(200).json(updatedNotification);
};

// PATCH /api/notifications/user/:userId/read - Mark all notifications as read for a user
export const markAllNotificationsAsRead = async (req, res, next) => {
    const { userId } = req.params;
    const updatedCount = await notificationsService.markAllAsReadForUser(userId);
    
    res.status(200).json({ 
        message: 'All notifications marked as read',
        updated_count: updatedCount
    });
};

//// DELETE /api/notifications/:id - Delete a notification
//export const deleteNotification = async (req, res, next) => {
//    const { id } = req.params;
//    // Check if notification exists
//    const existingNotification = await notificationsService.findById(id);
//    if (!existingNotification) {
//        return res.status(404).json({ error: 'Notification not found' });
//    }
//    const rowsAffected = await notificationsService.deleteNotification(id);
//    
//    if (rowsAffected === 0) {
//        return res.status(404).json({ error: 'Notification not found' });
//    }
//    res.status(200).json({ message: 'Notification deleted successfully' });
//};