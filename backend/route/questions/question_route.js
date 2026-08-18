import express from "express";
import { getQuestionById } from "../../controller/questions/question_controller.js";

const router = express.Router();

// GET /api/question/:id
router.get("/question/:id", getQuestionById);

export default router;
