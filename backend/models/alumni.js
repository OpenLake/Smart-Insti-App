import mongoose from "mongoose";

const alumniSchema = new mongoose.Schema(
  {
    name: { type: String, default: "Smart Insti User", trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
      match: [
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        "Please enter a valid email address",
      ],
      index: true,
    },
    graduationYear: { type: Number, min: 1950, max: 2100 },
    degree: { type: String, trim: true },
    department: { type: String, trim: true },
    currentOrganization: { type: String, trim: true },
    designation: { type: String, trim: true },
    linkedInProfile: { type: String, trim: true },
  },
  { timestamps: true }
);

const Alumni = mongoose.model("Alumni", alumniSchema);
export default Alumni;
