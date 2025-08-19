// backend/services/user.service.js
// Responsibility: To interact directly with the database for the 'users' entity.

import { pool } from '../models/db_connection.js';

/**
 * Finds and returns all users from the database.
 * @returns {Promise<Array>} An array of user objects.
 */
export const findAllUsers = async () => {
    const [rows] = await pool.query('SELECT * FROM users ORDER BY full_name ASC');
    return rows;
};

/**
 * Finds a user by their ID.
 * @param {number} id - The ID of the user to find.
 * @returns {Promise<Object|undefined>} The user object if found, otherwise undefined.
 */
export const findUserById = async (id) => {
    const [rows] = await pool.query('SELECT * FROM users WHERE user_id = ?', [id]);
    return rows[0];
};

/**
 * Adds a new user to the database.
 * @param {Object} userData - The data for the user to be created.
 * @returns {Promise<number>} The ID of the newly inserted user.
 */
export const addNewUser = async (userData) => {
    const { full_name, id_number, address, phone, email } = userData;
    const [result] = await pool.query(
        'INSERT INTO users (full_name, id_number, address, phone, email) VALUES (?, ?, ?, ?, ?)',
        [full_name, id_number, address, phone, email]
    );
    return result.insertId;
};