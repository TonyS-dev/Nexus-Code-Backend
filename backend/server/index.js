// backend/server/index.js
import cors from 'cors';
import express from 'express';
import morgan from 'morgan';

// --- Route Imports ---

// Core Business Logic Routes
import employeesRoutes from '../routes/employees.route.js';
import requestsRoutes from '../routes/requests.route.js';
import approvalsRoutes from '../routes/approvals.route.js';

// Authentication & Index
import authRoutes from '../routes/auth.route.js';
import indexRoutes from '../routes/index.route.js';

// Catalog Management Routes
import accessLevelsRoutes from '../routes/access_levels.route.js';
import certificateTypeRoutes from '../routes/certificate_types.route.js'; 
import employeeStatusesRoutes from '../routes/employee_statuses.route.js';
import gendersRoutes from '../routes/genders.route.js';
import headquartersRoutes from '../routes/headquarters.route.js';
import identificationTypeRoutes from '../routes/identification_types.route.js'; 
import leaveTypeRoutes from '../routes/leave_types.route.js'; 
import rolesRoutes from '../routes/roles.route.js'; 
import vacationTypeRoutes from '../routes/vacation_types.route.js';

// Auxiliary Routes
import attachedDocumentsRoutes from '../routes/attached_documents.route.js';
import notificationsRoutes from '../routes/notifications.route.js';
import vacationBalancesRoutes from '../routes/vacation_balances.route.js';
import requestStatusesRoutes from '../routes/request_statuses.route.js';
import passwordResetRoutes from './passwordReset.routes.js';

// Custom Middleware
import { globalErrorHandler } from '../middleware/globalErrorHandler.js';

// --- App Initialization ---
const app = express();
app.set('port', process.env.PORT);

// --- Core Middlewares ---
app.use(cors()); // !TODO: Add options for production
app.use(morgan('dev'));
app.use(express.json());

// --- API Routes ---
app.use('/', indexRoutes);
app.use('/auth', authRoutes);

// Main Resources
app.use('/employees', employeesRoutes); // This includes /employees/:id/roles and /employees/:id/salarie
app.use('/requests', requestsRoutes);
app.use('/approvals', approvalsRoutes);

// Catalog Resources
app.use('/roles', rolesRoutes);
app.use('/headquarters', headquartersRoutes);
app.use('/genders', gendersRoutes);
app.use('/employee-statuses', employeeStatusesRoutes);
app.use('/access-levels', accessLevelsRoutes);
app.use('/identification-types', identificationTypeRoutes);
app.use('/vacation-types', vacationTypeRoutes);
app.use('/leave-types', leaveTypeRoutes);
app.use('/certificate-types', certificateTypeRoutes);

// Auxiliary Resources
app.use('/documents', attachedDocumentsRoutes);
app.use('/notifications', notificationsRoutes);
app.use('/vacation-balances', vacationBalancesRoutes);
app.use('/request-statuses', requestStatusesRoutes);

app.use('/auth', passwordResetRoutes); // Password reset routes
// --- Error Handling ---
app.use(globalErrorHandler);

// --- Server Initialization ---
app.listen(app.get('port'), () => {
    console.log(`Server listening on the port ${app.get('port')}`);
});
