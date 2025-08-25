// backend/services/roles.service.js
// Responsibility: To interact directly with the database for the 'roles' entity.

import { query } from '../models/db_connection.js';

// Find all roles
export const findAll = async () => {
    const res = await query('SELECT * FROM roles ORDER BY role_name DESC');
    return res.rows;
};

// Find a single role by their UUID
export const findById = async (id) => {
    const res = await query('SELECT * FROM roles WHERE id = $1', [id]);
    return res.rows[0];
};

// Add a new role to the database
export const create = async (roleData) => {
    const {
        role_name,
        description,
        role_area
    } = roleData;

    const res = await query(
        `INSERT INTO roles (role_name, description, role_area) 
        VALUES ($1, $2, $3) 
        RETURNING id`,
        [role_name, description, role_area]
    );
    return res.rows[0].id;
};

// Update a role's data
export const update = async (id, roleData) => {
    const {
        role_name,
        description,
        role_area
    } = roleData;

    const res = await query(
        `UPDATE roles SET
            role_name = $1, 
            description = $2, 
            role_area = $3
        WHERE id = $4
        RETURNING *`,
        [role_name, description, role_area, id]
    );
    return res.rows[0];
};

//// Delete a role
//export const deleteRole = async (id) => {
//    const res = await query(
//        'DELETE FROM roles WHERE id = $1',
//        [id]
//    );
//    // rowCount is the number of rows affected by the query
//    return res.rowCount;
//};