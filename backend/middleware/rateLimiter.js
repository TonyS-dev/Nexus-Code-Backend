/**
 * @file rateLimiter.js
 * @description Rate limiting middleware to prevent abuse
 */

const attempts = new Map();

/**
 * Simple in-memory rate limiter
 * @param {number} windowMs - Time window in milliseconds
 * @param {number} maxAttempts - Maximum attempts per window
 */
export function createRateLimiter(windowMs = 15 * 60 * 1000, maxAttempts = 5) {
    return (req, res, next) => {
        const key = req.ip || req.connection.remoteAddress;
        const now = Date.now();
        
        // Clean up old entries
        for (const [ip, data] of attempts.entries()) {
            if (now - data.firstAttempt > windowMs) {
                attempts.delete(ip);
            }
        }
        
        // Get current attempts for this IP
        const current = attempts.get(key) || { count: 0, firstAttempt: now };
        
        // Reset if window has passed
        if (now - current.firstAttempt > windowMs) {
            current.count = 0;
            current.firstAttempt = now;
        }
        
        // Check if limit exceeded
        if (current.count >= maxAttempts) {
            const timeLeft = Math.ceil((windowMs - (now - current.firstAttempt)) / 1000);
            return res.status(429).json({
                success: false,
                message: `Too many attempts. Please try again in ${timeLeft} seconds.`,
                retryAfter: timeLeft
            });
        }
        
        // Increment counter
        current.count++;
        attempts.set(key, current);
        
        next();
    };
}

// Default rate limiter for password reset (5 attempts per 15 minutes)
export const rateLimiter = createRateLimiter(15 * 60 * 1000, 5);