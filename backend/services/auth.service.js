// backend/services/auth.service.js
import { query } from '../models/db_connection.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import * as employeeService from './employees.service.js';

export const authenticate = async (email, password) => {
    // Gets all user information, including roles.
    const res = await query(
        `SELECT e.*, r.name AS role, al.name AS access_level_name
         FROM employees e
         LEFT JOIN employee_roles er ON e.id = er.employee_id
         LEFT JOIN roles r ON er.role_id = r.id
         LEFT JOIN access_levels al ON e.access_level_id = al.id
         WHERE e.email = $1 AND e.is_deleted = false LIMIT 1`,
        [email]
    );
    const user = res.rows[0];

    if (!user || !(await bcrypt.compare(password, user.password_hash))) {
        throw new Error('Invalid credentials');
    }

    // Contains only public and necessary data for the frontend.
    const userForFrontend = {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: user.role,
    };

    // CREATES THE PAYLOAD FOR THE "SECURITY KEY" (The Token)
    // Contains the minimum information necessary for security.
    const tokenPayload = {
        id: user.id,
        role: user.role,
        accessLevel: user.access_level_name,
    };

    // SIGNS THE "KEY"
    const token = jwt.sign(tokenPayload, process.env.JWT_SECRET, {
        expiresIn: '1h',
    });

    // RETURNS BOTH PIECES
    return { token, user: userForFrontend };
};


/**
 * Registers a new user.
 * It checks if the email already exists and then uses the employee service to create the user.
 * @param {object} userData - The new user's data from the request body.
 * @returns {Promise<{token: string, user: object}>} - A new token and user object upon successful registration.
 */
export const create = async (userData) => {
    const { email } = userData;

    // Check if a user with this email already exists
    const existingUserRes = await query('SELECT id FROM employees WHERE email = $1', [email]);
    if (existingUserRes.rows.length > 0) {
        // Use a 409 Conflict status for existing resources
        const error = new Error('A user with this email already exists.');
        error.statusCode = 409; 
        throw error;
    }

    // If the email is available, create the new employee.
    // Delegate the creation logic (including hashing) to the employee service.
    const newEmployeeId = await employeeService.create(userData);

    // After successful creation, automatically log the new user in.
    // Fetch the newly created user's data to create a token and a clean user object.
    const newUser = await employeeService.findById(newEmployeeId);

    const userForFrontend = {
        id: newUser.id,
        first_name: newUser.first_name,
        last_name: newUser.last_name,
        email: newUser.email,
        role: newUser.roles.length > 0 ? newUser.roles[0].name : 'Employee', // Get the first role
    };

    const tokenPayload = { 
        id: newUser.id, 
        role: userForFrontend.role, 
        accessLevel: userForFrontend.access_level_name
    };

    const token = jwt.sign(tokenPayload, process.env.JWT_SECRET, { expiresIn: '1h' });

    return { token, user: userForFrontend };
};