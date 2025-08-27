// backend/services/access_levels.service.js
// Responsibility: To interact directly with the database for the 'access_levels' entity.
import { query } from '../models/db_connection.js';

// Find all access levels
export const findAll = async () => {
    const res = await query('SELECT * FROM access_levels ORDER BY name DESC');
    return res.rows;
};

// Find a single access level by their UUID
export const findById = async (id) => {
    const res = await query('SELECT * FROM access_levels WHERE id = $1', [id]);
    return res.rows[0];
};

// Add a new access level to the database
export const create = async (accessLevelData) => {
    const {
        name,
        description
    } = accessLevelData;

    const res = await query(
        `INSERT INTO access_levels (name, description) 
        VALUES ($1, $2) 
        RETURNING id`,
        [name, description]
    );
    return res.rows[0].id;
};

// Update an access level's data
export const update = async (id, accessLevelData) => {
    const {
        name,
        description
    } = accessLevelData;

    const res = await query(
        `UPDATE access_levels SET
            name = $1, 
            description = $2
        WHERE id = $3
        RETURNING *`,
        [name, description, id]
    );
    return res.rows[0];
};

//// Delete an access level
//export const deleteAccessLevel = async (id) => {
//    const res = await query(
//        'DELETE FROM access_levels WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};