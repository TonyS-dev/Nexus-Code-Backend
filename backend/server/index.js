// backend/server/index.js
import cors from "cors"
import express from "express"
import morgan from "morgan";
import usersRoutes from "./../routes/users.js";
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
app.use('/users', usersRoutes);

// Global Error Handler
app.use(globalErrorHandler);

// Initialize server
app.listen(app.get('port'), () => {
    console.log(`Servidor escuchando en el puerto ${app.get('port')}`);
});