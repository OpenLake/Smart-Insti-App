import mongoose from "mongoose";

const campusPostSchema = new mongoose.Schema({
  content: { type: String, required: true, trim: true, maxlength: 500 },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // Stored for moderation, not exposed
  isAnonymous: { type: Boolean, default: true },
  backgroundColor: { type: String, default: '0xFFFFFFFF' }, // Flutter color hex string
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  reports: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
  isHidden: { type: Boolean, default: false } // For moderation
}, { timestamps: true });

const CampusPost = mongoose.model("CampusPost", campusPostSchema);
export default CampusPost;
