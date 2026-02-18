import mongoose from "mongoose";

const privateMessageSchema = new mongoose.Schema({
  conversation: { type: mongoose.Schema.Types.ObjectId, ref: 'Conversation', required: true },
  sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  content: { type: String, required: true },
  messageType: { type: String, enum: ['text', 'image', 'system'], default: 'text' },
  imageUrl: { type: String },
  isRead: { type: Boolean, default: false },
  readAt: { type: Date }
}, { timestamps: true });

const PrivateMessage = mongoose.model("PrivateMessage", privateMessageSchema);
export default PrivateMessage;
