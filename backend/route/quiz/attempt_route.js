import express from "express";
import { attempt } from "../../controller/quiz/attempt_controller.js";

const router = express.Router();

// POST /api/attempt
router.post("/attempt", attempt);

export default router;
