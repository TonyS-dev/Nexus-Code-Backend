// backend/services/employees.service.js
import { pool, query } from '../models/db_connection.js';
import bcrypt from 'bcrypt';

const SALT_ROUNDS = 10;

/**
 * Finds all employees who are not marked as deleted.
 * This is a simple query, so it uses the query helper without a transaction.
 */
export const findAll = async () => {
    const queryString = `
        SELECT
            e.id, e.employee_code, e.first_name, e.last_name, e.email, e.hire_date,
            hq.name AS headquarters_name,
            es.name AS employee_status,
            (
                SELECT COALESCE(json_agg(r.name), '[]'::json)
                FROM employee_roles er
                JOIN roles r ON er.role_id = r.id
                WHERE er.employee_id = e.id
            ) AS roles
        FROM
            employees e
        LEFT JOIN headquarters hq ON e.headquarters_id = hq.id
        LEFT JOIN employee_statuses es ON e.status_id = es.id
        WHERE
            e.is_deleted = false
        ORDER BY
            e.last_name ASC, e.first_name ASC;
    `;
    const res = await query(queryString);
    return res.rows;
};

/**
 * Finds a single non-deleted employee by their UUID with detailed information.
 * This is a simple query, so it uses the query helper without a transaction.
 */
export const findById = async (id) => {
    const queryString = `
        SELECT
            e.id, e.employee_code, e.first_name, e.middle_name, e.last_name, e.second_last_name,
            e.email, e.phone, e.birth_date, e.hire_date, e.identification_number,
            e.created_at, e.updated_at, e.is_deleted,
            it.name AS identification_type,
            hq.name AS headquarters_name,
            g.name AS gender,
            es.name AS employee_status,
            al.name AS access_level,
            manager.id AS manager_id,
            manager.first_name AS manager_first_name,
            manager.last_name AS manager_last_name,
            (
                SELECT COALESCE(json_agg(
                    json_build_object('id', r.id, 'name', r.name)
                ), '[]'::json)
                FROM employee_roles er
                JOIN roles r ON er.role_id = r.id
                WHERE er.employee_id = e.id
            ) AS roles
        FROM
            employees e
        LEFT JOIN identification_types it ON e.identification_type_id = it.id
        LEFT JOIN headquarters hq ON e.headquarters_id = hq.id
        LEFT JOIN genders g ON e.gender_id = g.id
        LEFT JOIN employee_statuses es ON e.status_id = es.id
        LEFT JOIN access_levels al ON e.access_level_id = al.id
        LEFT JOIN employees manager ON e.manager_id = manager.id
        WHERE
            e.id = $1;
    `;
    const res = await query(queryString, [id]);
    return res.rows[0];
};

/**
 * Creates a new employee along with their role and salary in a single transaction.
 */
export const create = async (employeeData) => {
    const {
        employee_code,
        first_name,
        middle_name,
        last_name,
        second_last_name,
        email,
        password,
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
        role_id,
        salary_amount,
        effective_date,
    } = employeeData;

    const password_hash = await bcrypt.hash(password, SALT_ROUNDS);

    // Get a client from the pool to manage the transaction
    const client = await pool.connect();

    try {
        await client.query('BEGIN');

        // Insert into employees table
        const employeeInsertRes = await query(
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
                password_hash,
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
            ],
            client // Pass the client to the query helper
        );
        const employeeId = employeeInsertRes.rows[0].id;

        // If a role_id is provided, insert into employee_roles
        if (role_id) {
            await query(
                'INSERT INTO employee_roles (employee_id, role_id) VALUES ($1, $2)',
                [employeeId, role_id],
                client // Pass the client
            );
        }

        // If salary info is provided, insert into employee_salaries
        if (salary_amount && effective_date) {
            await query(
                'INSERT INTO employee_salaries (employee_id, salary_amount, effective_date) VALUES ($1, $2, $3)',
                [employeeId, salary_amount, effective_date],
                client // Pass the client
            );
        }

        await client.query('COMMIT');
        return employeeId;
    } catch (error) {
        await client.query('ROLLBACK');
        // We re-throw the error so the controller can catch it and send a 500 response.
        throw error;
    } finally {
        // IMPORTANT: Release the client back to the pool.
        client.release();
    }
};

/**
 * Updates an existing employee's data.
 * Does not handle password or role updates; those should be separate, dedicated endpoints.
 */
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
            status_id = $15, access_level_id = $16
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

/**
 * Soft deletes an employee by setting their is_deleted flag to true.
 */
export const softDelete = async (id) => {
    const res = await query(
        'UPDATE employees SET is_deleted = true WHERE id = $1',
        [id]
    );
    return res.rowCount;
};
