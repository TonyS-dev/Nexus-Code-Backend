// backend/controllers/vacation_balances.controller.js
// Responsibility: Handle HTTP requests for vacation balance management
import * as vacationBalancesService from '../services/vacation_balances.service.js';

// GET /api/vacation-balances - Get all vacation balances
export const getAllVacationBalances = async (req, res, next) => {
    const balances = await vacationBalancesService.findAll();
    res.status(200).json(balances);
};

// GET /api/vacation-balances/:id - Get a single vacation balance by ID
export const getVacationBalanceById = async (req, res, next) => {
    const { id } = req.params;
    const balance = await vacationBalancesService.findById(id);
    
    if (!balance) {
        return res.status(404).json({ error: 'Vacation balance not found' });
    }
    
    res.status(200).json(balance);
};

// GET /api/vacation-balances/employee/:employeeId - Get vacation balances by employee
export const getVacationBalancesByEmployee = async (req, res, next) => {
    const { employeeId } = req.params;
    const balances = await vacationBalancesService.findByEmployeeId(employeeId);
    res.status(200).json(balances);
};

// GET /api/vacation-balances/employee/:employeeId/year/:year - Get specific balance
export const getVacationBalanceByEmployeeAndYear = async (req, res, next) => {
    const { employeeId, year } = req.params;
    const balance = await vacationBalancesService.findByEmployeeAndYear(employeeId, parseInt(year));
    
    if (!balance) {
        return res.status(404).json({ error: 'Vacation balance not found for specified employee and year' });
    }
    
    res.status(200).json(balance);
};

// POST /api/vacation-balances - Create a vacation balance
export const createVacationBalance = async (req, res, next) => {
    const {
        employee_id,
        year,
        available_days,
        days_taken = 0
    } = req.body;
    // Validation
    if (
        !employee_id || 
        !year || 
        available_days === undefined
    ) {
        return res.status(400).json({ 
            error: 'employee_id, year, and available_days are required' 
        });
    }
    if (year <= 0) {
        return res.status(400).json({ error: 'year must be positive' });
    }
    if (available_days < 0) {
        return res.status(400).json({ error: 'available_days must be non-negative' });
    }
    if (days_taken < 0) {
        return res.status(400).json({ error: 'days_taken must be non-negative' });
    }
    // Check if balance already exists for this employee and year
    const existingBalance = await vacationBalancesService.findByEmployeeAndYear(employee_id, year);
    if (existingBalance) {
        return res.status(409).json({ 
            error: 'Vacation balance already exists for this employee and year' 
        });
    }
    const balanceData = {
        employee_id,
        year: parseInt(year),
        available_days: parseInt(available_days),
        days_taken: parseInt(days_taken)
    };
    const balanceId = await vacationBalancesService.create(balanceData);
    const newBalance = await vacationBalancesService.findById(balanceId);
    
    res.status(201).json(newBalance);
};

// PUT /api/vacation-balances/:id - Update a vacation balance
export const updateVacationBalance = async (req, res, next) => {
        const { id } = req.params;
        const { available_days, days_taken } = req.body;

        // Check if balance exists
        const existingBalance = await vacationBalancesService.findById(id);
        if (!existingBalance) {
            return res.status(404).json({ error: 'Vacation balance not found' });
        }

        // Validation
        if (
            available_days === undefined || 
            days_taken === undefined
        ) {
            return res.status(400).json({ error: 'available_days and days_taken are required' });
        }

        if (available_days < 0) {
            return res.status(400).json({ error: 'available_days must be non-negative' });
        }

        if (days_taken < 0) {
            return res.status(400).json({ error: 'days_taken must be non-negative' });
        }

        const balanceData = {
            available_days: parseInt(available_days),
            days_taken: parseInt(days_taken)
        };

        const updatedBalance = await vacationBalancesService.update(id, balanceData);
        res.status(200).json(updatedBalance);

};

// POST /api/vacation-balances/initialize/:year - Initialize balances for all employees
export const initializeYearBalances = async (req, res, next) => {
        const { year } = req.params;
        const { defaultDays = 22 } = req.body;

        if (
            !year || 
            year <= 0
        ) {
            return res.status(400).json({ error: 'Valid year is required' });
        }

        if (defaultDays < 0) {
            return res.status(400).json({ error: 'defaultDays must be non-negative' });
        }

        const result = await vacationBalancesService.initializeYearBalances(parseInt(year), parseInt(defaultDays));
        
        res.status(201).json({
            message: 'Year balances initialized successfully',
            ...result
        });

};

// GET /api/vacation-balances/summary/:year? - Get balance summary
export const getBalanceSummary = async (req, res, next) => {
    const { year } = req.params;
    const summary = await vacationBalancesService.getBalanceSummary(year ? parseInt(year) : null);
    
    if (!summary) {
        return res.status(404).json({ error: 'No vacation balance data found for specified year' });
    }
    
    res.status(200).json(summary);
};