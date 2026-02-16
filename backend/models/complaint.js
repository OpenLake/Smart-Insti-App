import mongoose from "mongoose";

const complaintSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    description: { type: String, required: true, trim: true },
    category: {
      type: String,
      enum: ["Mess", "Hostel Infrastructure", "Academic", "Other"],
      default: "Other",
    },
    status: {
      type: String,
      enum: ["Pending", "In Progress", "Resolved", "Rejected"],
      default: "Pending",
    },
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Student", // Assuming mainly students complain
        required: true
    },
    createdByName: { type: String }, // Denormalized for easier display
    upvotes: [{ type: mongoose.Schema.Types.ObjectId, ref: "Student" }],
    imageURI: { type: String, trim: true },
  },
  { timestamps: true }
);

const Complaint = mongoose.model("Complaint", complaintSchema);
export default Complaint;
