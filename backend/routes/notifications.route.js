/**
 * @file notifications.routes.js
 * @description Routes for notifications management
 */
import { Router } from 'express';
import { authenticateToken } from '../middleware/auth.middleware.js';
import * as notificationsController from '../controllers/notifications.controller.js';

const router = Router();

// All notification routes require authentication
router.use(authenticateToken);

// Get all notifications for current user
router.get('/', notificationsController.getUserNotifications);

// Get unread count
router.get('/unread-count', notificationsController.getUnreadCount);

// Mark notification as read
router.patch('/:id/read', notificationsController.markAsRead);

// Mark all notifications as read
router.patch('/mark-all-read', notificationsController.markAllAsRead);

export default router;
