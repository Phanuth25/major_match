import express from "express";
import { select } from "../../controller/majors/select_controller.js";

const router = express.Router();

// GET /api/select
router.get("/select", select);

export default router;
