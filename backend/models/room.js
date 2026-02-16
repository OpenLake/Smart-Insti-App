import mongoose from "mongoose";

const roomSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    vacant: { type: Boolean, default: true, index: true }, // Indexing for faster vacant room queries
    occupantId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Student",
      default: null,
    }, // Reference for data integrity
    occupantName: { type: String, default: null, trim: true },
  },
  { timestamps: true } // Automatically adds createdAt & updatedAt
);

const Room = mongoose.model("Room", roomSchema);
export default Room;
