import mongoose from "mongoose";

const courseSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  courseCode: {
    type: String,
    required: true,
    unique: true,
  },
  primaryRoom: {
    type: String,
  },
  credits: {
    type: Number,
    required: true,
  },
  branches: [
    {
      type: String,
    },
  ],
});

const Course = mongoose.model("Course", courseSchema);

export default Course;
