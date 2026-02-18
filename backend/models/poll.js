
import mongoose from "mongoose";

const pollSchema = new mongoose.Schema(
  {
    question: { type: String, required: true, trim: true },
    options: [{
        text: { type: String, required: true },
        votes: { type: Number, default: 0 }
    }],
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "Student", required: true }, // Can be Student, Admin, etc.
    creatorRole: { type: String, enum: ["Student", "Admin", "Faculty", "Alumni"], default: "Student" },
    expiry: { type: Date, required: true },
    votedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "Student" }], // Track who voted to prevent double voting
    target: {
        type: String,
        enum: ["All", "Students", "Faculty", "Alumni"],
        default: "All"
    },
    isActive: { type: Boolean, default: true }
  },
  { timestamps: true }
);

const Poll = mongoose.model("Poll", pollSchema);

export default Poll;
