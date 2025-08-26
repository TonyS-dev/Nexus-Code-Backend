// backend/routes/index.route.js
import express from 'express';
import { getApiInfo } from '../controllers/index.controller.js';

const router = express.Router();

router.get('/', getApiInfo);

export default router;
