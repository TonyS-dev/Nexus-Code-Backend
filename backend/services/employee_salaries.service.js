// backend/services/employeeSalaries.service.js
import { query } from '../models/db_connection.js';

/**
 * Finds all salary records for a specific employee.
 * @param {string} employeeId - The UUID of the employee.
 */
export const findSalariesByEmployeeId = async (employeeId) => {
    const res = await query(
        'SELECT * FROM employee_salaries WHERE employee_id = $1 ORDER BY effective_date DESC',
        [employeeId]
    );
    return res.rows;
};

/**
 * Adds a new salary record for an employee.
 * @param {string} employeeId - The UUID of the employee.
 * @param {object} salaryData - Contains salary_amount and effective_date.
 */
export const addSalary = async (employeeId, salaryData) => {
    const { salary_amount, effective_date } = salaryData;
    const res = await query(
        'INSERT INTO employee_salaries (employee_id, salary_amount, effective_date) VALUES ($1, $2, $3) RETURNING id',
        [employeeId, salary_amount, effective_date]
    );
    return res.rows[0].id;
};
