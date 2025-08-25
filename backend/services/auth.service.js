// backend/services/auth.service.js
import { query } from '../models/db_connection.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

export const authenticate = async (email, password) => {
    const res = await query(
        'SELECT * FROM employees WHERE email = $1 AND is_deleted = false',
        [email]
    );
    const user = res.rows[0];

    if (!user) {
        throw new Error('Invalid credentials'); // Generic error for security
    }

    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
        throw new Error('Invalid credentials');
    }

    // If the password is valid, create a token
    const { password_hash, ...userWithoutPassword } = user;
    const token = jwt.sign(
        { id: user.id, email: user.email },
        process.env.JWT_SECRET,
        { expiresIn: '1h' }
    );

    return { token, user: userWithoutPassword };
};
