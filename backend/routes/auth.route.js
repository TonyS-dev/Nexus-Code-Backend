// backend/routes/auth.route.js
import express from 'express';
import * as authController from '../controllers/auth.controller.js';
import { EmailService } from '../services/email.service.js';

const router = express.Router();

router.post('/login', authController.login);
router.post('/register', authController.register);

// Test email endpoint
router.get('/test-email', async (req, res) => {
    try {
        console.log('🧪 Starting email test...');
        console.log('Environment check:');
        console.log('  RESEND_API_KEY:', process.env.RESEND_API_KEY ? `${process.env.RESEND_API_KEY.substring(0, 6)}...` : 'MISSING');
        console.log('  EMAIL_FROM:', process.env.EMAIL_FROM);
        
        const result = await EmailService.testConnection();
        res.json({
            success: result.success,
            message: result.success ? 'Email service working!' : 'Email service failed',
            messageId: result.messageId,
            error: result.error
        });
    } catch (error) {
        console.error('🚨 Test endpoint error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
});

export default router;
