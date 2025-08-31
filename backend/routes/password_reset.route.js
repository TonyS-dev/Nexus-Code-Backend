/**
 * @file passwordReset.routes.js
 * @description Routes for password reset functionality
 */

import express from 'express';
import { PasswordResetController } from '../controllers/password_reset.controller.js';
import { rateLimiter } from '../middleware/rateLimiter.js';

const router = express.Router();

/**
 * @route POST /auth/forgot-password
 * @desc Request password reset token
 * @access Public
 * Rate limited: 5 attempts per 15 minutes
 */
router.post(
    '/forgot-password',
    rateLimiter,
    PasswordResetController.requestPasswordReset
);

/**
 * @route POST /auth/validate-reset-token
 * @desc Validate reset token
 * @access Public
 */
router.post(
    '/validate-reset-token',
    PasswordResetController.validateResetToken
);

/**
 * @route POST /auth/reset-password
 * @desc Reset password with token
 * @access Public
 * Rate limited: 5 attempts per 15 minutes
 */
router.post(
    '/reset-password',
    rateLimiter,
    PasswordResetController.resetPassword
);

export default router;
