// backend/routes/notifications.routes.js
// Responsibility: Define routes for notifications endpoints
import express from 'express';
import * as notificationsController from '../controllers/notifications.controller.js';

const router = express.Router();

// Routes for general notification operations
router
    .route('/')
    .get(notificationsController.getAllNotifications)
    .post(notificationsController.createNotification);

// Routes for notification counts by user (must be before /user/:userId to avoid conflicts)
router
    .route('/user/:userId/counts')
    .get(notificationsController.getNotificationCounts);

// Routes for marking all notifications as read for a user
router
    .route('/user/:userId/read')
    .patch(notificationsController.markAllNotificationsAsRead);

// Routes for notifications by specific user
router
    .route('/user/:userId')
    .get(notificationsController.getNotificationsByUser);

// Routes for marking a specific notification as read
router
    .route('/:id/read')
    .patch(notificationsController.markNotificationAsRead);

// Routes for specific notification by ID (must be last to avoid conflicts)
router
    .route('/:id')
    .get(notificationsController.getNotificationById)
    //.delete(notificationsController.deleteNotification);

export default router;