// backend/services/genders.service.js
// Responsibility: To interact directly with the database for the 'genders' entity.
import { query } from '../models/db_connection.js';

// Find all genders
export const findAll = async () => {
    const res = await query('SELECT * FROM genders ORDER BY gender_name DESC');
    return res.rows;
};

// Find a single gender by their UUID
export const findById = async (id) => {
    const res = await query('SELECT * FROM genders WHERE id = $1', [id]);
    return res.rows[0];
};

// Add a new gender to the database
export const create = async (genderData) => {
    const { gender_name } = genderData;

    const res = await query(
        `INSERT INTO genders (gender_name) 
        VALUES ($1) 
        RETURNING id`,
        [gender_name]
    );
    return res.rows[0].id;
};

// Update a gender's data
export const update = async (id, genderData) => {
    const { gender_name } = genderData;

    const res = await query(
        `UPDATE genders SET
            gender_name = $1
        WHERE id = $2
        RETURNING *`,
        [gender_name, id]
    );
    return res.rows[0];
};

//// Delete a gender
//export const deleteGender = async (id) => {
//    const res = await query(
//        'DELETE FROM genders WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};