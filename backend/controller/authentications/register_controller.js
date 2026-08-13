import registerModel from "../../model/authentications/register_model.js";
import cloudinary from "../../config/cloudinary.js";

export async function register(req, res) {
  // With multer, text fields land in req.body and the uploaded file
  // lands in req.file (not req.body.profile_image anymore).
  const { name, email, password } = req.body;
  const profileImageFile = req.file;

  try {
    let imageUrl = null;

    // 1. Upload image to Cloudinary if a file was provided
    if (profileImageFile) {
      // Cloudinary's upload() accepts a base64 data URI directly,
      // so convert the in-memory buffer multer gave us.
      const base64 = profileImageFile.buffer.toString("base64");
      const dataUri = `data:${profileImageFile.mimetype};base64,${base64}`;

      const uploadResult = await cloudinary.uploader.upload(dataUri, {
        folder: "majormatch",
      });
      imageUrl = uploadResult.secure_url;
    }

    // 2. Save user to database using the Cloudinary URL
    registerModel.register(
      name,
      email,
      password,
      imageUrl, // Pass Cloudinary URL instead of raw image data
      (err, result) => {
        if (err) {
          console.error("Database registration error:", err);
          return res.status(500).json({ error: "Internal server error" });
        }

        return res.status(201).json({
          message: "User registered successfully",
          user: {
            name,
            email,
            profile_image: imageUrl,
          },
        });
      },
    );
  } catch (error) {
    console.error("Cloudinary upload error:", error);
    return res.status(500).json({ success: false, error: error.message });
  }
}
