// backend/seeders/run_seeders.js
import { insertToDatabase } from './seeder.js';
import { pool } from '../models/db_connection.js';

(async () => {
    try {
        console.log('🚀 Starting to seed CATALOG tables...');

        await insertToDatabase(
            'employee_statuses',
            'data/01_employee_statuses.csv'
        );
        await insertToDatabase('genders', 'data/02_genders.csv');
        await insertToDatabase('roles', 'data/03_roles.csv');
        await insertToDatabase('headquarters', 'data/04_headquarters.csv');
        await insertToDatabase(
            'request_statuses',
            'data/05_request_statuses.csv'
        );
        await insertToDatabase('leave_types', 'data/06_leave_types.csv');
        await insertToDatabase(
            'certificate_types',
            'data/07_certificate_types.csv'
        );
        await insertToDatabase(
            'identification_types',
            'data/08_identification_types.csv'
        );
        await insertToDatabase('vacation_types', 'data/09_vacation_types.csv');
        await insertToDatabase('access_levels', 'data/10_access_levels.csv');

        console.log('✅ All catalog seeders executed successfully.');
    } catch (error) {
        console.error('❌ Error executing catalog seeders:', error.message);
        throw error; // Propagate the error so that the Bash script detects it
    } finally {
        console.log(
            'Catalog seeding finished. Closing database connection pool...'
        );
        await pool.end();
    }
})();
