import express from "express";
import { selectQuestionsByIds } from "../../controller/questions/select_controller.js";

const router = express.Router();

// POST /api/questions/select
router.post("/selectq", selectQuestionsByIds);

export default router;
