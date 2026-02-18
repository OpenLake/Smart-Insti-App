
import express from "express";
import Student from "../../models/student.js";
import Faculty from "../../models/faculty.js";
import Complaint from "../../models/complaint.js";
import Event from "../../models/event.js";
import Poll from "../../models/poll.js";
import Listing from "../../models/listing.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";

const analyticsRouter = express.Router();

// Get Dashboard Stats
analyticsRouter.get("/dashboard", isAuthenticated, async (req, res) => {
    try {
        // Parallel execution for performance
        const [
            studentCount,
            facultyCount,
            pendingComplaints,
            resolvedComplaints,
            activePolls,
            upcomingEvents,
            activeListings
        ] = await Promise.all([
            Student.countDocuments(),
            Faculty.countDocuments(),
            Complaint.countDocuments({ status: "Pending" }),
            Complaint.countDocuments({ status: "Resolved" }),
            Poll.countDocuments({ isActive: true }),
            Event.countDocuments({ date: { $gte: new Date() } }),
            Listing.countDocuments({ status: "Active" })
        ]);

        const recentComplaints = await Complaint.find()
            .sort({ createdAt: -1 })
            .limit(5)
            .populate("student", "name");

        res.status(200).json({
            status: true,
            data: {
                counts: {
                    students: studentCount,
                    faculty: facultyCount,
                    complaints: {
                        pending: pendingComplaints,
                        resolved: resolvedComplaints
                    },
                    polls: activePolls,
                    events: upcomingEvents,
                    listings: activeListings
                },
                recentComplaints
            }
        });

    } catch (err) {
        console.error("Error fetching analytics:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default analyticsRouter;
