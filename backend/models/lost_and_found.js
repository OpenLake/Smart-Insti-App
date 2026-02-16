import mongoose from "mongoose";

const lostAndFoundItemSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    lastSeenLocation: { type: String, trim: true },
    imagePath: { type: String, default: null }, // Prevents undefined errors
    description: { type: String, trim: true },
    contactNumber: {
      type: String,
      required: true,
      trim: true,
      match: [/^\d{10}$/, "Please enter a valid 10-digit phone number"], // Enforces valid numbers
    },
    listerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      required: false,
      index: true, // Faster queries on lost items per user
    },
    isLost: { type: Boolean, required: true },
  },
  { timestamps: true } // Auto adds createdAt & updatedAt
);

const LostAndFoundItem = mongoose.model(
  "LostAndFoundItem",
  lostAndFoundItemSchema
);
export default LostAndFoundItem;