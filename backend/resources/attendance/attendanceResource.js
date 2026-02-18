
import express from "express";
import mongoose from "mongoose";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import Attendance from "../../models/attendance.js";
import Course from "../../models/course.js"; // Ensure course model is imported

const attendanceRouter = express.Router();

// Mark Attendance
attendanceRouter.post("/mark", isAuthenticated, async (req, res) => {
  try {
    const { courseId, sessionId, location } = req.body;
    const studentId = req.user._id;

    if (!courseId || !sessionId) {
        return res.status(400).json({ status: false, message: "Course ID and Session ID required" });
    }

    // Verify course exists
    // const course = await Course.findById(courseId);
    // if (!course) return res.status(404).json({ message: "Course not found" });

    // Optional: Validate location/geofencing here if course has location set
    
    // Check if already marked
    const existing = await Attendance.findOne({ student: studentId, sessionId });
    if (existing) {
        return res.status(400).json({ status: false, message: "Attendance already marked for this session" });
    }

    const attendance = new Attendance({
        student: studentId,
        course: courseId,
        sessionId,
        location,
        status: "Present",
        date: new Date()
    });

    await attendance.save();

    res.status(201).json({ status: true, message: "Attendance marked successfully" });

  } catch (err) {
    if (err.code === 11000) {
        return res.status(400).json({ status: false, message: "Attendance already marked for this session" });
    }
    console.error("Error marking attendance:", err);
    res.status(500).json({ status: false, message: "Internal server error" });
  }
});

// Get My Attendance
attendanceRouter.get("/my-attendance", isAuthenticated, async (req, res) => {
    try {
        const studentId = req.user._id;
        const { courseId } = req.query;

        const filter = { student: studentId };
        if (courseId) filter.course = courseId;

        const attendance = await Attendance.find(filter)
            .sort({ createdAt: -1 })
            .populate("course", "name courseCode"); // Assuming Course model has name/code

        res.status(200).json({ status: true, data: attendance });

    } catch (err) {
        console.error("Error getting attendance:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

// Get Attendance Statistics (Percentage)
attendanceRouter.get("/stats", isAuthenticated, async (req, res) => {
    try {
        const studentId = req.user._id;
        
        // Group by course and count present vs total
        const stats = await Attendance.aggregate([
            { $match: { student: new mongoose.Types.ObjectId(studentId) } },
            { $group: {
                _id: "$course",
                totalSessions: { $sum: 1 },
                presentCount: { $sum: { $cond: [{ $eq: ["$status", "Present"] }, 1, 0] } }
            }},
            { $lookup: {
                from: "courses", 
                localField: "_id",
                foreignField: "_id",
                as: "course"
            }},
            { $unwind: "$course" },
            { $project: {
                courseName: "$course.name",
                courseCode: "$course.courseCode",
                totalSessions: 1,
                presentCount: 1,
                percentage: { $multiply: [{ $divide: ["$presentCount", "$totalSessions"] }, 100] }
            }}
        ]);

        res.status(200).json({ status: true, data: stats });

    } catch (err) {
        console.error("Error getting attendance stats:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default attendanceRouter;
