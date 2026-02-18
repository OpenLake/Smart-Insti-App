import { v2 as cloudinary } from 'cloudinary';
import { CloudinaryStorage } from 'multer-storage-cloudinary';
import multer from 'multer';
import dotenv from 'dotenv';

dotenv.config();

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'smart_insti_marketplace',
    allowed_formats: ['jpg', 'png', 'jpeg', 'webp', 'pdf', 'doc', 'docx', 'ppt', 'pptx'],
  },
});

export const upload = multer({ storage: storage });
export { cloudinary };
