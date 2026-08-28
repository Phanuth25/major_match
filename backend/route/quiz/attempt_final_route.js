import express from "express";
import { attemptFinal } from "../../controller/quiz/attempt_final_controller.js";

const router = express.Router();

// POST /api/attempt-final
router.post("/attempt-final", attemptFinal);

export default router;
