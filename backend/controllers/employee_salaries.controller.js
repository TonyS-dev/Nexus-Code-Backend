// backend/controllers/employeeSalaries.controller.js
import * as EmployeeSalariesService from '../services/employee_salaries.service.js';

export const getEmployeeSalaries = async (req, res, next) => {
    const { employeeId } = req.params;
    const salaries = await EmployeeSalariesService.findSalariesByEmployeeId(
        employeeId
    );
    res.status(200).json(salaries);
};

export const addSalaryForEmployee = async (req, res, next) => {
    const { employeeId } = req.params;
    const { salary_amount, effective_date } = req.body;

    if (!salary_amount || !effective_date) {
        return res
            .status(400)
            .json({
                message: 'salary_amount and effective_date are required.',
            });
    }

    const newSalaryId = await EmployeeSalariesService.addSalary(
        employeeId,
        req.body
    );
    res.status(201).json({
        id: newSalaryId,
        message: 'Salary record added successfully.',
    });
};
