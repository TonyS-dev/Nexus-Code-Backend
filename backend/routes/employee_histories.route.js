// backend/routes/auth.route.js
import express from 'express';
import * as employeeHistories from '../controllers/employee_histories.controller.js';

const router = express.Router();

router.route('/Id')
    .get(employeeHistories.getHistoryByEmployeeId);
export default router;
