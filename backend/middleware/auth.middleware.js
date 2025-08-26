// backend/middleware/auth.middleware.js
import jwt from 'jsonwebtoken';

export const protect = (req, res, next) => {
    let token;

    if (
        req.headers.authorization &&
        req.headers.authorization.startsWith('Bearer')
    ) {
        try {
            // 1. Extract the token from the 'Bearer <token>' header
            token = req.headers.authorization.split(' ')[1];

            // 2. Verify the token using the jwt secret
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            // 3. Attach the user to the request object
            req.user = decoded; // Now all subsequent controllers will know who made the request

            next(); // Allow the request to continue
        } catch (error) {
            console.error('Token verification failed:', error.message);
            return res
                .status(401)
                .json({ message: 'Not authorized, token failed' });
        }
    }

    if (!token) {
        return res.status(401).json({ message: 'Not authorized, no token' });
    }
};
