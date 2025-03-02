import mongoose from "mongoose";

const studentSchema = new mongoose.Schema(
  {
    name: { type: String, default: "Smart Insti User", trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      index: true,
    },
    rollNumber: { type: String, unique: true, sparse: true, trim: true }, // Allows null but ensures uniqueness
    about: { type: String, trim: true },
    profilePicURI: { type: String, trim: true },
    branch: { type: String, trim: true },
    graduationYear: { type: Number, min: 1900, max: 2100 }, // Ensures valid graduation year
    skills: [{ type: mongoose.Schema.Types.ObjectId, ref: "Skill" }],
    achievements: [
      { type: mongoose.Schema.Types.ObjectId, ref: "Achievement" },
    ],
    roles: { type: [String], default: [] }, // Ensures array structure
  },
  { timestamps: true } // Adds createdAt & updatedAt fields
);

const Student = mongoose.model("Student", studentSchema);
export default Student;
