import mongoose from "mongoose";

const resourceSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  description: { type: String, trim: true },
  subject: { type: String, required: true }, // Course Code or Name
  semester: { type: Number, required: true },
  department: { type: String, required: true, enum: ['CSE', 'ECE', 'ME', 'CE', 'EEE', 'MME', 'DSAI', 'BT', 'CHE'] },
  type: { type: String, enum: ['Notes', 'Paper', 'Book', 'Assignment', 'Other'], default: 'Notes' },
  fileUrl: { type: String, required: true },
  publicId: { type: String }, // Cloudinary public_id for deletion
  uploadedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  upvotes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  downloads: { type: Number, default: 0 }
}, { timestamps: true });

const Resource = mongoose.model("Resource", resourceSchema);
export default Resource;
