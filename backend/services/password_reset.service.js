/**
 * @file password_reset.service.js
 * @description Service for handling password reset functionality (PostgreSQL)
 */

import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { pool } from '../config/database.js';
import { logger } from '../utils/logger.js';

export class PasswordResetService {
    /**
     * Generates a password reset token for a user
     * @param {string} email - User email
     * @returns {Object} Result object with success status and token (or error)
     */
    static async generateResetToken(email) {
        try {
            // Check if user exists
            const userResult = await pool.query(
                'SELECT id, email, first_name FROM employees WHERE email = $1 AND status_id = 1',
                [email]
            );

            if (userResult.rows.length === 0) {
                // Don't reveal if email exists for security
                return {
                    success: true,
                    message:
                        'If the email exists, a password reset link has been sent.',
                };
            }

            const user = userResult.rows[0];

            // Generate JWT token with 1 hour expiration
            const resetToken = jwt.sign(
                {
                    userId: user.id,
                    email: user.email,
                    type: 'password_reset',
                },
                process.env.JWT_SECRET,
                { expiresIn: '1h' }
            );

            // Store token in database (PostgreSQL syntax)
            await pool.query(
                `INSERT INTO password_reset_tokens (user_id, email, token, expires_at, created_at) 
                 VALUES ($1, $2, $3, NOW() + INTERVAL '1 hour', NOW()) 
                 ON CONFLICT (user_id) 
                 DO UPDATE SET token = $3, expires_at = NOW() + INTERVAL '1 hour', created_at = NOW()`,
                [user.id, user.email, resetToken]
            );

            logger.info(`Password reset token generated for user: ${email}`);

            return {
                success: true,
                message: 'Password reset token generated successfully',
                token: resetToken, // In production, send this via email instead
                user: {
                    email: user.email,
                    first_name: user.first_name,
                },
            };
        } catch (error) {
            logger.error('Error generating reset token:', error);
            throw new Error('Failed to generate reset token');
        }
    }

    /**
     * Validates a reset token
     * @param {string} token - Reset token
     * @returns {Object} Decoded token data or throws error
     */
    static async validateResetToken(token) {
        try {
            // Verify JWT token
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            if (decoded.type !== 'password_reset') {
                throw new Error('Invalid token type');
            }

            // Check if token exists in database and is not expired
            const tokenResult = await pool.query(
                'SELECT * FROM password_reset_tokens WHERE token = $1 AND expires_at > NOW()',
                [token]
            );

            if (tokenResult.rows.length === 0) {
                throw new Error('Token not found or expired');
            }

            return {
                success: true,
                userId: decoded.userId,
                email: decoded.email,
            };
        } catch (error) {
            if (error.name === 'JsonWebTokenError') {
                throw new Error('Invalid reset token');
            }
            if (error.name === 'TokenExpiredError') {
                throw new Error('Reset token has expired');
            }
            throw error;
        }
    }

    /**
     * Resets user password using valid token
     * @param {string} token - Reset token
     * @param {string} newPassword - New password
     * @returns {Object} Result object
     */
    static async resetPassword(token, newPassword) {
        try {
            // Validate token
            const validation = await this.validateResetToken(token);
            if (!validation.success) {
                throw new Error('Invalid or expired token');
            }

            const { userId, email } = validation;

            // Hash new password
            const hashedPassword = await bcrypt.hash(newPassword, 10);

            // Update user password
            await pool.query(
                'UPDATE employees SET password = $1, updated_at = NOW() WHERE id = $2',
                [hashedPassword, userId]
            );

            // Invalidate the reset token
            await pool.query(
                'DELETE FROM password_reset_tokens WHERE user_id = $1',
                [userId]
            );

            logger.info(`Password reset successful for user: ${email}`);

            return {
                success: true,
                message: 'Password reset successfully',
            };
        } catch (error) {
            logger.error('Error resetting password:', error);
            throw error;
        }
    }

    /**
     * Clean up expired tokens (should be run periodically)
     */
    static async cleanupExpiredTokens() {
        try {
            const result = await pool.query(
                'DELETE FROM password_reset_tokens WHERE expires_at < NOW()'
            );
            logger.info(`Cleaned up ${result.rowCount} expired reset tokens`);
        } catch (error) {
            logger.error('Error cleaning up expired tokens:', error);
        }
    }
}
