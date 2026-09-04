import express from "express";
import { history } from "../../controller/quiz/history_controller.js";

const router = express.Router();

// GET /api/history
router.get("/history/:user_id", history);

export default router;
