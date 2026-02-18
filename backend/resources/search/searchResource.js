
import express from "express";
import Student from "../../models/student.js";
import Faculty from "../../models/faculty.js";
import Event from "../../models/event.js";
import Post from "../../models/post.js";
import BusRoute from "../../models/bus_route.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";

const searchRouter = express.Router();

// Global Search
// Query param: ?q=keyword
searchRouter.get("/", isAuthenticated, async (req, res) => {
    try {
        const query = req.query.q;
        if (!query || query.length < 2) {
            return res.status(200).json({ status: true, data: {} });
        }

        const regex = new RegExp(query, "i"); // Case-insensitive regex for simpler Partial match

        // Parallel execution for performance
        const [students, faculty, events, news, buses] = await Promise.all([
            Student.find({ 
                $or: [{ name: regex }, { branch: regex }, { rollNumber: regex }] 
            }).select("name branch rollNumber profilePicURI").limit(5),

            Faculty.find({ 
                $or: [{ name: regex }, { department: regex }] 
            }).select("name department cabinNumber").limit(5),

            Event.find({ 
                $or: [{ title: regex }, { description: regex }] 
            }).select("title date location imageURI").limit(5),

            Post.find({ 
                $or: [{ title: regex }, { content: regex }] 
            }).select("title type createdAt").limit(5),
            
            BusRoute.find({
                $or: [{ routeName: regex }, { busNumber: regex }]
            }).select("routeName busNumber").limit(5)
        ]);

        res.status(200).json({
            status: true,
            data: {
                students,
                faculty,
                events,
                news,
                buses
            }
        });

    } catch (err) {
        console.error("Error performing global search:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default searchRouter;
