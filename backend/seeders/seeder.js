// backend/seeders/seeder.js
import fs from 'fs';
import path from 'path';
import csv from 'csv-parser';
import { pool } from '../models/db_connection.js';
import pgFormat from 'pg-format';

export async function insertToDatabase(tableName, filePath) {
    const resolvedPath = path.resolve(filePath);
    const rows = [];

    return new Promise((resolve, reject) => {
        fs.createReadStream(resolvedPath)
            .pipe(csv())
            .on('data', (row) => rows.push(row))
            .on('end', async () => {
                if (rows.length === 0) {
                    console.warn(`⚠️ No data in ${filePath}.`);
                    return resolve();
                }

                const client = await pool.connect();
                try {
                    const columns = Object.keys(rows[0]);
                    const values = rows.map((row) => Object.values(row));

                    // pg-format creates the correct syntax for bulk insertion in PostgreSQL
                    const sql = pgFormat(
                        'INSERT INTO public.%I (%s) VALUES %L ON CONFLICT (id) DO NOTHING',
                        tableName,
                        columns.join(', '),
                        values
                    );

                    await client.query(sql);
                    console.log(
                        `✅ Inserted ${rows.length} rows into ${tableName}.`
                    );
                    resolve();
                } catch (error) {
                    console.error(
                        `❌ Error inserting into ${tableName}:`,
                        error.message
                    );
                    reject(error);
                } finally {
                    client.release();
                }
            })
            .on('error', (err) => reject(err));
    });
}
