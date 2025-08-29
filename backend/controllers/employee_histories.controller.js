/**
 * @file employee_histories.controller.js
 * @description Handles HTTP requests for employee history events.
 */
import * as historyService from '../services/employee_histories.service.js';

/**
 * Gets all history events for a given employee ID.
 */
export const getHistoryByEmployeeId = async (req, res, next) => {
    try {
        const { employeeId } = req.params;
        const history = await historyService.findByEmployeeId(employeeId);
        res.status(200).json(history);
    } catch (error) {
        next(error);
    }
};
