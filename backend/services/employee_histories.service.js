/**
 * @file employee_histories.service.js
 * @description Interacts with the database for the 'employee_histories' entity.
 */
import { query } from '../models/db_connection.js';

/**
 * Finds all history events for a specific employee, ordered by most recent.
 * @param {string} employeeId - The UUID of the employee.
 * @returns {Promise<Array>} A list of history events.
 */
export const findByEmployeeId = async (employeeId) => {
    const queryString = `
        SELECT
            h.id,
            h.event,
            h.description,
            h.event_date,
            p.first_name as performed_by_first_name,
            p.last_name as performed_by_last_name
        FROM
            employee_histories h
        LEFT JOIN
            employees p ON h.performed_by_id = p.id
        WHERE
            h.employee_id = $1
        ORDER BY
            h.event_date DESC;
    `;
    const res = await query(queryString, [employeeId]);
    return res.rows;
};
