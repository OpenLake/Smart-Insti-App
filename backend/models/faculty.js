import mongoose from "mongoose";

const facultySchema = new mongoose.Schema(
  {
    name: { type: String, default: "Smart Insti User", trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true, // Standardizes email format
      match: [
        /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        "Please enter a valid email address",
      ],
      index: true, // Improves lookup performance
    },
    cabinNumber: { type: String, trim: true },
    department: { type: String, trim: true, default: "Unknown" }, // Avoids missing values
    courses: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Course",
      },
    ],
  },
  { timestamps: true } // Auto adds createdAt & updatedAt
);

const Faculty = mongoose.model("Faculty", facultySchema);
export default Faculty;
