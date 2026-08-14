import express from "express";
import { login } from "../../controller/authentications/login_controller.js";

const router = express.Router();

// POST /api/login
router.post("/login", login);

export default router;
