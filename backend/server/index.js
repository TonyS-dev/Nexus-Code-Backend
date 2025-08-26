// backend/server/index.js
import cors from "cors"
import express from "express"
import morgan from "morgan";

import employeesRoutes from "../routes/employees.route.js";
import rolesRoutes from '../routes/roles.route.js'
import headquarterRoutes from '../routes/headquarter.route.js'
import gendersRoutes from '../routes/genders.route.js'
import employeeStatusesRoutes from '../routes/employee_statuses.route.js'
import accessLevelsRoutes from '../routes/access_levels.route.js'
import authRoutes from '../routes/auth.route.js';
import identificationtype from '../routes/identification_type.route.js';
import requestsRoutes from '../routes/requests.route.js';
import vacationBalancesRoutes from '../routes/vacation_balances.route.js';
import approvalsRoutes from '../routes/approvals.route.js';
import attachedDocumentsRoutes from '../routes/attached_documents.route.js';
import notificationsRoutes from '../routes/notifications.route.js';


// Custom Middleware to handle errors
import { globalErrorHandler } from "../middleware/globalErrorHandler.js";

// Initial server configuration
const app = express();
app.set('port', process.env.PORT);

// Middlewares
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

// Routes
app.use('/login', authRoutes);
app.use('/employees', employeesRoutes);
app.use('/roles', rolesRoutes);
app.use('/headquarters', headquarterRoutes);
app.use('/genders', gendersRoutes);
app.use('/employee-statuses', employeeStatusesRoutes);
app.use('/access-levels', accessLevelsRoutes);
app.use('/identification-type', identificationtype);
app.use('/requests', requestsRoutes);
app.use('/vacation-balances', vacationBalancesRoutes);
app.use('/approvals', approvalsRoutes);
app.use('/documents', attachedDocumentsRoutes);
app.use('/notifications', notificationsRoutes);

// Global Error Handler
app.use(globalErrorHandler);

// Initialize server
app.listen(app.get('port'), () => {
    console.log(`Server listening on the port ${app.get('port')}`);
});