import express from "express";
import multer from "multer";
import { register } from "../../controller/authentications/register_controller.js";

const router = express.Router();

// Store the uploaded file in memory as a Buffer (req.file.buffer),
// rather than writing it to disk first — simplest for forwarding
// straight to Cloudinary.
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB, adjust as needed
});

// 'profile_image' must match the field name used in FormData.fromMap
// on the Flutter side.
router.post("/register", upload.single("profile_image"), register);

export default router;
