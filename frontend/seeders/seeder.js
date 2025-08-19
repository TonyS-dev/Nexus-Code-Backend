// backend/seeders/seeder.js
import fs from 'fs'; // Allows to read files
import path from 'path'; // Shows current path
import csv from 'csv-parser';
import { pool } from "../models/db_connection.js"

// Example: insertToDatabase('books', 'server/data/02_libros.csv');
export async function insertToDatabase(tableName, filePath) {

    const resolvedPath = path.resolve(filePath);
    const rows = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(resolvedPath)
            .pipe(csv())
            .on("data", (row) => {
                rows.push(row);
            })
            .on('end', async () => {
                if (rows.length === 0) {
                    console.warn(`⚠️ No data found in ${filePath}.`);
                    return resolve(); // Ends successfully even if no data
                }
                const columns = Object.keys(rows[0]);
                const columnString = columns.join(", ");
                const values = rows.map(row => Object.values(row));
                try {
                    const sql = `INSERT INTO ${tableName} (${columnString}) VALUES ?`;
                    const [result] = await pool.query(sql, [values]);

                    console.log(`✅ Inserted ${result.affectedRows} ${tableName}s.`);
                    resolve(); // Ends successfully
                } catch (error) {
                    console.error(`❌ Error inserting ${tableName}s:`, error.message);
                    reject(error);
                }
            })
            .on('error', (err) => {
                console.error(`❌ Error reading ${tableName} CSV file:`, err.message);
                reject(err);
            });
    });
}