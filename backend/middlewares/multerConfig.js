import multer from "multer";
import fs from "fs";
import path from "path";

const uploadsFolder = "uploads/";

// Ensure the uploads folder exists asynchronously
(async () => {
  try {
    await fs.promises.mkdir(uploadsFolder, { recursive: true });
  } catch (error) {
    console.error("❌ Error creating uploads folder:", error.message);
  }
})();

// Allowed file types (e.g., images, PDFs)
const allowedMimeTypes = [
  "image/jpeg",
  "image/png",
  "image/gif",
  "application/pdf",
];

/**
 * Multer Storage Configuration
 */
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadsFolder);
  },
  filename: (req, file, cb) => {
    // Sanitize filename to remove spaces & special characters
    const sanitizedFilename = file.originalname
      .replace(/\s+/g, "_")
      .replace(/[^a-zA-Z0-9_.-]/g, "");
    cb(null, Date.now() + "-" + sanitizedFilename);
  },
});

/**
 * File Filter for Allowed MIME Types
 */
const fileFilter = (req, file, cb) => {
  if (allowedMimeTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error("Invalid file type. Allowed: JPG, PNG, GIF, PDF"), false);
  }
};

/**
 * Multer Upload Middleware
 */
const uploader = multer({
  storage,
  fileFilter,
  limits: { fileSize: 5 * 1024 * 1024 }, // Limit file size to 5MB
});

export default uploader;
