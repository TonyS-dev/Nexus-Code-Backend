// backend/controllers/auth.controller.js
import * as AuthService from '../services/auth.service.js';

export const login = async (req, res, next) => {
    const { email, password } = req.body;
    if (!email || !password) {
        return res
            .status(400)
            .json({ message: 'Email and password are required.' });
    }
    const result = await AuthService.authenticate(email, password);
    res.status(200).json(result);
};

/**
 * Handles the user registration request.
 */
export const register = async (req, res, next) => {
    try {
        const { email, password, first_name, last_name } = req.body;
        if (!email || !password || !first_name || !last_name) {
            return res.status(400).json({ message: 'Missing required registration fields.' });
        }

        const result = await AuthService.create(req.body);
        
        res.status(201).json(result);

    } catch (error) {
        // Pass the error to the global error handler
        // If the service threw a 409 error, the handler can use error.statusCode
        next(error);
    }
};