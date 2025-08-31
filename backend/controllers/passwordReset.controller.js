/**
 * @file passwordReset.controller.js
 * @description Controller for password reset functionality
 */

import { PasswordResetService } from '../services/passwordReset.service.js';
import { logger } from '../utils/logger.js';

// Simple validation functions
function validateEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function validatePassword(password) {
    return password && password.length >= 6;
}

export class PasswordResetController {
    /**
     * Request password reset token
     * POST /auth/forgot-password
     */
    static async requestPasswordReset(req, res) {
        try {
            const { email } = req.body;

            // Validate input
            if (!email) {
                return res.status(400).json({
                    success: false,
                    message: 'Email is required',
                });
            }

            if (!validateEmail(email)) {
                return res.status(400).json({
                    success: false,
                    message: 'Please provide a valid email address',
                });
            }

            // Generate reset token
            const result = await PasswordResetService.generateResetToken(
                email.toLowerCase()
            );

            // In production, you would send the token via email instead of returning it
            res.json({
                success: true,
                message: result.message,
                // Remove this in production - send via email instead
                reset_token: result.token,
                user: result.user,
            });
        } catch (error) {
            logger.error('Error in requestPasswordReset:', error);
            res.status(500).json({
                success: false,
                message: 'Internal server error',
            });
        }
    }

    /**
     * Validate reset token
     * POST /auth/validate-reset-token
     */
    static async validateResetToken(req, res) {
        try {
            const { token } = req.body;

            if (!token) {
                return res.status(400).json({
                    success: false,
                    message: 'Reset token is required',
                });
            }

            const validation = await PasswordResetService.validateResetToken(
                token
            );

            res.json({
                success: true,
                message: 'Token is valid',
                email: validation.email,
            });
        } catch (error) {
            logger.error('Error in validateResetToken:', error);

            if (
                error.message.includes('Invalid') ||
                error.message.includes('expired')
            ) {
                return res.status(400).json({
                    success: false,
                    message: error.message,
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
            });
        }
    }

    /**
     * Reset password
     * POST /auth/reset-password
     */
    static async resetPassword(req, res) {
        try {
            const { token, password, confirmPassword } = req.body;

            // Validate input
            if (!token || !password || !confirmPassword) {
                return res.status(400).json({
                    success: false,
                    message:
                        'Token, password, and password confirmation are required',
                });
            }

            if (password !== confirmPassword) {
                return res.status(400).json({
                    success: false,
                    message: 'Passwords do not match',
                });
            }

            if (!validatePassword(password)) {
                return res.status(400).json({
                    success: false,
                    message: 'Password must be at least 6 characters long',
                });
            }

            // Reset password
            const result = await PasswordResetService.resetPassword(
                token,
                password
            );

            res.json({
                success: true,
                message: result.message,
            });
        } catch (error) {
            logger.error('Error in resetPassword:', error);

            if (
                error.message.includes('Invalid') ||
                error.message.includes('expired')
            ) {
                return res.status(400).json({
                    success: false,
                    message: error.message,
                });
            }

            res.status(500).json({
                success: false,
                message: 'Internal server error',
            });
        }
    }
}
