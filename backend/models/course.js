import mongoose from "mongoose";

const courseSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    courseCode: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      uppercase: true, // Ensures course codes like "CS101" remain standardized
      index: true, // Speeds up course lookups
    },
    primaryRoom: { type: String, trim: true },
    credits: { type: Number, required: true, min: 1 }, // Ensures credits are positive
    professorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Faculty",
      required: true,
    },
    branches: [{ type: String, required: true, trim: true }], // Prevents empty values in array
  },
  { timestamps: true } // Automatically adds createdAt & updatedAt
);

const Course = mongoose.model("Course", courseSchema);
export default Course;
