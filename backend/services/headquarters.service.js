// backend/services/headquarters.service.js
// Responsibility: To interact directly with the database for the 'headquarters' entity.
import { query } from '../models/db_connection.js';

// Find all headquarters
export const findAll = async () => {
    const res = await query('SELECT * FROM headquarters ORDER BY name DESC');
    return res.rows;
};

// Find a single headquarters by their UUID
export const findById = async (id) => {
    const res = await query('SELECT * FROM headquarters WHERE id = $1', [id]);
    return res.rows[0];
};

// Add a new headquarters to the database
export const create = async (headquartersData) => {
    const { name } = headquartersData;

    const res = await query(
        `INSERT INTO headquarters (name) 
        VALUES ($1) 
        RETURNING id`,
        [name]
    );
    return res.rows[0].id;
};

// Update a headquarters data
export const update = async (id, headquartersData) => {
    const { name } = headquartersData;

    const res = await query(
        `UPDATE headquarters SET
            name = $1, 
            updated_at = now()
        WHERE id = $2
        RETURNING *`,
        [name, id]
    );
    return res.rows[0];
};

//// Delete a headquarters
//export const deleteHeadquarters = async (id) => {
//    const res = await query(
//        'DELETE FROM headquarters WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};