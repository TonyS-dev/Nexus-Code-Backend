// backend/seeders/run_seeders.js
import { insertToDatabase } from './seeder.js';


(async () => {
    try {
        console.log('🚀 Starting seeders...');

        await insertToDatabase('payment_platforms', 'server/data/01_payment_platforms.csv');
        await insertToDatabase('transaction_types', 'server/data/02_transaction_types.csv');
        await insertToDatabase('users', 'server/data/03_users.csv');
        await insertToDatabase('invoices', 'server/data/04_invoices.csv');
        await insertToDatabase('transactions', 'server/data/05_transactions.csv');

        console.log('✅ All seeders executed successfully.');
    } catch (error) {
        console.error('❌ Error executing seeders:', error.message);
    } finally {
        process.exit();
    }
})()