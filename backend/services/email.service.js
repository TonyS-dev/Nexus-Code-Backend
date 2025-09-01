/**
 * @file email.service.js
 * @description Email service using Resend API
 */

import { Resend } from 'resend';

export class EmailService {
    static resend = new Resend(process.env.RESEND_API_KEY);

    static initialize() {
        if (!this.resend && process.env.RESEND_API_KEY) {
            this.resend = new Resend(process.env.RESEND_API_KEY);
            console.log('✅ Resend email service initialized');
        }
    }

    /**
     * Send password reset email
     * @param {string} email - Recipient email
     * @param {string} token - Reset token
     * @param {string} userName - User's first name
     */
    static async sendPasswordReset(email, token, userName) {
        try {
            this.initialize();
            
            const resetUrl = `${process.env.FRONTEND_URL}/reset-password?token=${token}`;
            
            console.log('📧 Sending password reset email to:', email);

            const result = await this.resend.emails.send({
                from: process.env.EMAIL_FROM || 'onboarding@resend.dev',
                to: email,
                subject: '🔑 Reset Your Password - Riwi Nexus',
                html: `
                    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
                        <div style="background: #f8fafc; padding: 40px; border-radius: 8px;">
                            <h1 style="color: #1f2937; text-align: center;">🔑 Riwi Nexus</h1>
                            <h2 style="color: #374151;">Hi ${userName}!</h2>
                            
                            <p style="color: #6b7280; line-height: 1.6;">
                                You requested to reset your password for your Riwi Nexus account. 
                                Click the button below to set a new password:
                            </p>
                            
                            <div style="text-align: center; margin: 30px 0;">
                                <a href="${resetUrl}" 
                                   style="background: #3b82f6; color: white; padding: 12px 24px; 
                                          text-decoration: none; border-radius: 6px; display: inline-block;
                                          font-weight: 600;">
                                    Reset My Password
                                </a>
                            </div>
                            
                            <p style="color: #9ca3af; font-size: 14px;">
                                ⏰ This link expires in 1 hour for security reasons.
                            </p>
                            
                            <p style="color: #9ca3af; font-size: 12px; margin-top: 20px;">
                                If you didn't request this password reset, please ignore this email.
                            </p>
                        </div>
                    </div>
                `,
                text: `
                    Hi ${userName}!
                    
                    You requested to reset your password for your Riwi Nexus account.
                    
                    Click this link to reset your password: ${resetUrl}
                    
                    This link expires in 1 hour.
                    
                    If you didn't request this, please ignore this email.
                    
                    - Riwi Nexus Team
                `
            });

            console.log('✅ Password reset email sent successfully:', result.data.id);
            return { success: true, messageId: result.data.id };

        } catch (error) {
            console.error('❌ Resend email error:', error);
            throw new Error(`Failed to send password reset email: ${error.message}`);
        }
    }

    /**
     * Test email service connection
     */
    static async testConnection() {
        try {
            this.initialize();
            
            console.log('🧪 Testing Resend connection...');
            console.log('API Key configured:', !!process.env.RESEND_API_KEY);
            console.log('Email from:', process.env.EMAIL_FROM);

            const result = await this.resend.emails.send({
                from: process.env.EMAIL_FROM || 'onboarding@resend.dev',
                to: 'test@example.com',
                subject: 'Resend Test Email',
                html: '<p>✅ Resend is working correctly!</p>'
            });

            console.log('✅ Resend connection test successful:', result.data.id);
            return { success: true, messageId: result.data.id };

        } catch (error) {
            console.error('❌ Resend connection test failed:', error);
            return { success: false, error: error.message };
        }
    }
}