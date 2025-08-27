// backend/models/db_connection.js
import { Pool } from "pg";

export const pool = new Pool({
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 5432,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    // pg pool options
    max: process.env.DB_MAX ? Number(process.env.DB_MAX) : 10, // maximum number of clients in the pool
    idleTimeoutMillis: process.env.DB_IDLE_TIMEOUT_MS ? Number(process.env.DB_IDLE_TIMEOUT_MS) : 30000,
    connectionTimeoutMillis: process.env.DB_CONN_TIMEOUT_MS ? Number(process.env.DB_CONN_TIMEOUT_MS) : 2000
});

/**
 * Executes a SQL query. If a client is provided, it uses it (for transactions).
 * Otherwise, it gets a client from the pool.
 * @param {string} text - The SQL query text.
 * @param {Array} [params] - The parameters for the query.
 * @param {object} [client] - An optional existing database client.
 * @returns {Promise<object>} The query result.
 */
export async function query(text, params, client) {
    const start = Date.now();
    // Use the provided client if it exists, otherwise get one from the pool
    const db = client || pool;
    const res = await db.query(text, params);
    const duration = Date.now() - start;

    if (process.env.NODE_ENV === 'development') {
        console.log('Executed query', { text, duration, rows: res.rowCount });
    }
    return res;
}

// Helper test function
export async function testDBConnection() {
    try {
        const client = await pool.connect();
        try {
            await client.query('SELECT NOW()');
            console.log('✅ Successful database connection');
        } finally {
            client.release();
        }
    } catch (error) {
        console.error('❌ Error connecting to the database:', error.message);
    }
}

if (process.env.NODE_ENV === 'development') {
    testDBConnection();
    console.log(pool.options);
}