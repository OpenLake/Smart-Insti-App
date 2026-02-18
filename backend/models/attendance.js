
import mongoose from "mongoose";

const attendanceSchema = new mongoose.Schema(
  {
    student: { type: mongoose.Schema.Types.ObjectId, ref: "Student", required: true },
    course: { type: mongoose.Schema.Types.ObjectId, ref: "Course", required: true }, // Or simple string if course is not populated
    date: { type: Date, required: true, default: Date.now },
    status: { type: String, enum: ["Present", "Absent", "Late", "Excused"], default: "Present" },
    sessionId: { type: String, required: true }, // Unique ID to prevent double marking for same session (e.g. courseId + date + random)
    location: {
        latitude: Number,
        longitude: Number
    }
  },
  { timestamps: true }
);

// Prevent duplicate attendance for student + sessionId
attendanceSchema.index({ student: 1, sessionId: 1 }, { unique: true });

const Attendance = mongoose.model("Attendance", attendanceSchema);

export default Attendance;
