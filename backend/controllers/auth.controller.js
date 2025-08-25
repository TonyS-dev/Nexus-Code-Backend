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
