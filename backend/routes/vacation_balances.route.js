// backend/routes/vacation_balances.routes.js
// Responsibility: Define routes for vacation balance management endpoints
import express from 'express';
import * as vacationBalancesController from '../controllers/vacation_balances.controller.js';

const router = express.Router();

// Routes for general vacation balances operations
router
    .route('/')
    .get(vacationBalancesController.getAllVacationBalances)
    .post(vacationBalancesController.createVacationBalance);

// Routes for balance summary (must be before /:id to avoid conflicts)
router
    .route('/summary/:year')
    .get(vacationBalancesController.getBalanceSummary);

router
    .route('/summary')
    .get(vacationBalancesController.getBalanceSummary);

// Routes for initializing year balances
router
    .route('/initialize/:year')
    .post(vacationBalancesController.initializeYearBalances);

// Routes for employee-specific vacation balances
router
    .route('/employee/:employeeId')
    .get(vacationBalancesController.getVacationBalancesByEmployee);

// Routes for specific employee and year combination
router
    .route('/employee/:employeeId/year/:year')
    .get(vacationBalancesController.getVacationBalanceByEmployeeAndYear);

// Routes for specific vacation balance by ID (must be last to avoid conflicts)
router
    .route('/:id')
    .get(vacationBalancesController.getVacationBalanceById)
    .put(vacationBalancesController.updateVacationBalance);
    //.delete(vacationBalancesController.deleteVacationBalance);

export default router;