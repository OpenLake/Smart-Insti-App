import mongoose from "mongoose";

const MessageSchema = new mongoose.Schema(
  {
    sender: { type: String, required: true, trim: true },
    content: { type: String, required: true, trim: true },
    timestamp: { type: Date, default: Date.now, index: true }, // Indexing for faster queries
  },
  { timestamps: true } // Automatically adds createdAt & updatedAt
);

const Message = mongoose.model("Message", MessageSchema);
export default Message;
