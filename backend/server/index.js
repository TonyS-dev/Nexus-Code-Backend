// backend/server/index.js
import cors from "cors"
import express from "express"
import morgan from "morgan";
import employeesRoutes from "./../routes/employees.route.js";
import rolesRoutes from './../routes/roles.route.js'
// Custom Middleware to handle errors
import { globalErrorHandler } from "./../middleware/globalErrorHandler.js";

// Initial server configuration
const app = express();
app.set('port', process.env.PORT);

// Middlewares
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

// Routes
app.use('/employees', employeesRoutes);
app.use('/roles', rolesRoutes);

// Global Error Handler
app.use(globalErrorHandler);

// Initialize server
app.listen(app.get('port'), () => {
    console.log(`Server listening on the port ${app.get('port')}`);
});