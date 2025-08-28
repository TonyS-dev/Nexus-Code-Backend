// backend/services/vacation_balances.service.js
// Responsibility: Handle vacation balance management for employees
import { query } from '../models/db_connection.js';

// Find all vacation balances
export const findAll = async () => {
    const res = await query(`
        SELECT 
            vb.*,
            e.first_name,
            e.last_name,
            e.employee_code,
            (vb.available_days - vb.days_taken) as remaining_days
        FROM vacation_balances vb
        JOIN employees e ON vb.employee_id = e.id
        WHERE e.is_deleted = false
        ORDER BY vb.year DESC, e.first_name DECS
    `);
    return res.rows;
};

// Find vacation balance by ID
export const findById = async (id) => {
    const res = await query(`
        SELECT 
            vb.*,
            e.first_name,
            e.last_name,
            e.employee_code,
            (vb.available_days - vb.days_taken) as remaining_days
        FROM vacation_balances vb
        JOIN employees e ON vb.employee_id = e.id
        WHERE vb.id = $1 AND e.is_deleted = false
    `, [id]);
    return res.rows[0];
};

// Find vacation balances by employee ID
export const findByEmployeeId = async (employeeId) => {
    const res = await query(`
        SELECT 
            vb.*,
            e.first_name,
            e.last_name,
            e.employee_code,
            (vb.available_days - vb.days_taken) as remaining_days
        FROM vacation_balances vb
        JOIN employees e ON vb.employee_id = e.id
        WHERE vb.employee_id = $1 AND e.is_deleted = false
        ORDER BY vb.year DESC
    `, [employeeId]);
    return res.rows;
};

// Find vacation balance for specific employee and year
export const findByEmployeeAndYear = async (employeeId, year) => {
    const res = await query(`
        SELECT 
            vb.*,
            e.first_name,
            e.last_name,
            e.employee_code,
            (vb.available_days - vb.days_taken) as remaining_days
        FROM vacation_balances vb
        JOIN employees e ON vb.employee_id = e.id
        WHERE vb.employee_id = $1 AND vb.year = $2 AND e.is_deleted = false
    `, [employeeId, year]);
    return res.rows[0];
};

// Create vacation balance for employee
export const create = async (balanceData) => {
    const {
        employee_id,
        year,
        available_days,
        days_taken = 0
    } = balanceData;

    const res = await query(`
        INSERT INTO vacation_balances (employee_id, year, available_days, days_taken)
        VALUES ($1, $2, $3, $4)
        RETURNING id
    `, [employee_id, year, available_days, days_taken]);
    
    return res.rows[0].id;
};

// Update vacation balance
export const update = async (id, balanceData) => {
    const {
        available_days,
        days_taken
    } = balanceData;

    const res = await query(`
        UPDATE vacation_balances SET
            available_days = $1,
            days_taken = $2
        WHERE id = $3
        RETURNING *
    `, [available_days, days_taken, id]);
    
    return res.rows[0];
};

//// Delete vacation balance
//export const deleteVacationBalance = async (id) => {
//    const res = await query(
//        'DELETE FROM vacation_balances WHERE id = $1',
//        [id]
//    );
//    return res.rowCount;
//};

// Initialize vacation balances for all employees for a given year
export const initializeYearBalances = async (year, defaultDays = 22) => {
    // Get all active employees who don't have a balance for this year
    const employeesRes = await query(`
        SELECT e.id, e.first_name, e.last_name, e.employee_code
        FROM employees e
        LEFT JOIN vacation_balances vb ON e.id = vb.employee_id AND vb.year = $1
        WHERE e.is_deleted = false AND vb.id IS NULL
    `, [year]);

    const employees = employeesRes.rows;
    const createdBalances = [];

    for (const employee of employees) {
        const balanceId = await create({
            employee_id: employee.id,
            year: year,
            available_days: defaultDays,
            days_taken: 0
        });
        createdBalances.push(balanceId);
    }

    return {
        year,
        employeesProcessed: employees.length,
        balancesCreated: createdBalances.length
    };
};

// Get vacation balance summary for all employees
export const getBalanceSummary = async (year = null) => {
    const currentYear = year || new Date().getFullYear();
    
    const res = await query(`
        SELECT 
            vb.year,
            COUNT(*) as total_employees,
            SUM(vb.available_days) as total_available_days,
            SUM(vb.days_taken) as total_days_taken,
            SUM(vb.available_days - vb.days_taken) as total_remaining_days,
            AVG(vb.available_days - vb.days_taken) as avg_remaining_days
        FROM vacation_balances vb
        JOIN employees e ON vb.employee_id = e.id
        WHERE vb.year = $1 AND e.is_deleted = false
        GROUP BY vb.year
    `, [currentYear]);
    
    return res.rows[0];
};