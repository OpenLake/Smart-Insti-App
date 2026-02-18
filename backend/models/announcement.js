import mongoose from "mongoose";

const announcementSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  content: { type: String, required: true },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  type: { 
    type: String, 
    enum: ['General', 'Organizational_Unit', 'Course', 'System'], 
    default: 'General' 
  },
  target: { 
    type: mongoose.Schema.Types.ObjectId, 
    refPath: 'targetModel' // Dynamic reference
  },
  targetModel: {
    type: String,
    enum: ['OrganizationalUnit', 'Course', null], // Add models as needed
    default: null
  },
  isPinned: { type: Boolean, default: false },
  expiryDate: { type: Date },
}, { timestamps: true });

// Add text index for search
announcementSchema.index({ title: 'text', content: 'text' });

const Announcement = mongoose.model("Announcement", announcementSchema);
export default Announcement;
