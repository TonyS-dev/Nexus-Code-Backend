// backend/services/employees.service.js
// Responsibility: To interact directly with the database for the 'employees' entity.
import { query } from '../models/db_connection.js';
import bcrypt from 'bcrypt';
const SALT_ROUNDS = 10; // for hashing passwords

// Find all employees that are not marked as deleted
export const findAll = async () => {
    const res = await query(
        'SELECT * FROM employees WHERE is_deleted = false ORDER BY first_name DESC'
    );
    return res.rows;
};

// Find a single non-deleted employee by their UUID
export const findById = async (id) => {
    const res = await query(
        'SELECT * FROM employees WHERE id = $1 AND is_deleted = false',
        [id]
    );
    return res.rows[0];
};

// Add a new employee to the database
export const create = async (employeeData) => {
    const {
        employee_code,
        first_name,
        middle_name,
        last_name,
        second_last_name,
        email,
        password, // plain text password from input
        phone,
        birth_date,
        hire_date,
        identification_type_id,
        identification_number,
        manager_id,
        headquarters_id,
        gender_id,
        status_id,
        access_level_id,
    } = employeeData;

    // 1. Hash the password before storing it
    const password_hash = await bcrypt.hash(password, SALT_ROUNDS);

    // 2. Insert the hash into the database
    const res = await query(
        `INSERT INTO employees (
            employee_code, first_name, middle_name, last_name, second_last_name,
            email, password_hash, phone, birth_date, hire_date, identification_type_id,
            identification_number, manager_id, headquarters_id, gender_id, status_id, access_level_id
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
        RETURNING id`,
        [
            employee_code,
            first_name,
            middle_name,
            last_name,
            second_last_name,
            email,
            password_hash, // <-- Here the service will store the hashed password
            phone,
            birth_date,
            hire_date,
            identification_type_id,
            identification_number,
            manager_id,
            headquarters_id,
            gender_id,
            status_id,
            access_level_id,
        ]
    );
    return res.rows[0].id;
};

// Update an employee's data
export const update = async (id, employeeData) => {
    const {
        employee_code,
        first_name,
        middle_name,
        last_name,
        second_last_name,
        email,
        phone,
        birth_date,
        hire_date,
        identification_type_id,
        identification_number,
        manager_id,
        headquarters_id,
        gender_id,
        status_id,
        access_level_id,
    } = employeeData;

    const res = await query(
        `UPDATE employees SET
            employee_code = $1, first_name = $2, middle_name = $3, last_name = $4, second_last_name = $5,
            email = $6, phone = $7, birth_date = $8, hire_date = $9, identification_type_id = $10,
            identification_number = $11, manager_id = $12, headquarters_id = $13, gender_id = $14, 
            status_id = $15, access_level_id = $16, updated_at = now()
        WHERE id = $17
        RETURNING id`,
        [
            employee_code,
            first_name,
            middle_name,
            last_name,
            second_last_name,
            email,
            phone,
            birth_date,
            hire_date,
            identification_type_id,
            identification_number,
            manager_id,
            headquarters_id,
            gender_id,
            status_id,
            access_level_id,
            id,
        ]
    );
    return res.rows[0];
};

// Mark an employee as deleted
export const softDelete = async (id) => {
    const res = await query(
        'UPDATE employees SET is_deleted = true, updated_at = now() WHERE id = $1',
        [id]
    );
    // rowCount is the number of rows affected by the query
    return res.rowCount;
};
