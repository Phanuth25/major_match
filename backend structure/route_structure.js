import express from 'express';
import { selectById } from '../controller/productController.js';

const router = express.Router();

router.get('/products/:id', selectById);

export default router;
    