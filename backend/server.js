import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import pool from "./config/db.js";
dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

// Essential Middlewares
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Improved CORS configuration
app.use(
  cors({
    origin: "*", // Allow all origins for development
    methods: ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"],
    allowedHeaders: [
      "Content-Type",
      "Authorization",
      "X-Requested-With",
      "ngrok-skip-browser-warning",
    ],
  }),
);
// Base Test Route
app.get("/", (req, res) => {
  res.json({
    status: "success",
    message: "Express backend (ES Modules) is running smoothly!",
  });
});

// Catch-all 404 handler
app.use((req, res) => {
  res.status(404).json({ error: "Route not found" });
});

// Start the server
app.listen(PORT, () => {
  console.log(`🚀 Server is listening at http://localhost:${PORT}`);
});
