// backend/services/employee_statuses.service.js
// Responsibility: To interact directly with the database for the 'employee_statuses' entity.
import { query } from '../models/db_connection.js';

// Find all employee statuses
export const findAll = async () => {
    const res = await query('SELECT * FROM employee_statuses ORDER BY status_name DESC');
    return res.rows;
};

// Find a single employee status by their UUID
export const findById = async (id) => {
    const res = await query('SELECT * FROM employee_statuses WHERE id = $1', [id]);
    return res.rows[0];
};

// Add a new employee status to the database
export const create = async (statusData) => {
    const { status_name } = statusData;

    const res = await query(
        `INSERT INTO employee_statuses (status_name) 
        VALUES ($1) 
        RETURNING id`,
        [status_name]
    );
    return res.rows[0].id;
};

// Update an employee status data
export const update = async (id, statusData) => {
    const { status_name } = statusData;

    const res = await query(
        `UPDATE employee_statuses SET
            status_name = $1
        WHERE id = $2
        RETURNING *`,
        [status_name, id]
    );
    return res.rows[0];
};

//// Delete an employee status
//export const deleteEmployeeStatus = async (id) => {
//    const res = await query(
//        'DELETE FROM employee_statuses WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};