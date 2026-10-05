import express from "express";
import {
  history,
  removeHistory,
} from "../../controller/quiz/history_controller.js";

const router = express.Router();

// GET /api/history
router.get("/history/:user_id", history);
// DELETE /api/history/:user_id/:id
router.delete("/removehistory/:user_id/:id", removeHistory);

export default router;
