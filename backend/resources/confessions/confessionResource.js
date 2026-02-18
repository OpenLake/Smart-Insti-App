import express from "express";
import Confession from "../../models/confession.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const confessionRouter = express.Router();

// Get Confessions (Public/Authenticated)
confessionRouter.get("/", isAuthenticated, async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    
    const confessions = await Confession.find({ isHidden: false })
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(Number(limit))
      .select('-author -reports'); // Exclude author and reports from public view

    // Add info if current user liked it
    const enhancedConfessions = confessions.map(c => {
        const obj = c.toObject();
        obj.isLiked = c.likes.includes(req.user._id);
        obj.likeCount = c.likes.length;
        delete obj.likes; // Don't send full list of likers if not needed
        return obj;
    });

    res.status(200).json({ status: true, data: enhancedConfessions });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Create Confession
confessionRouter.post("/", isAuthenticated, async (req, res) => {
  try {
    const { content, backgroundColor } = req.body;

    if (!content) return res.status(400).json({ status: false, message: "Content is required" });

    const newConfession = await Confession.create({
      content,
      backgroundColor: backgroundColor || '0xFFFFFFFF',
      author: req.user._id
    });

    res.status(201).json({ status: true, data: { ...newConfession.toObject(), author: null } });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Like/Unlike Confession
confessionRouter.put("/:id/like", isAuthenticated, async (req, res) => {
    try {
        const confession = await Confession.findById(req.params.id);
        if (!confession) return res.status(404).json({ status: false, message: "Confession not found" });

        const userId = req.user._id;
        const index = confession.likes.indexOf(userId);

        if (index === -1) {
            confession.likes.push(userId);
        } else {
            confession.likes.splice(index, 1);
        }

        await confession.save();
        
        res.status(200).json({ 
            status: true, 
            message: index === -1 ? "Liked" : "Unliked",
            data: { likeCount: confession.likes.length, isLiked: index === -1 }
        });

    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

// Report Confession
confessionRouter.post("/:id/report", isAuthenticated, async (req, res) => {
    try {
        const confession = await Confession.findById(req.params.id);
        if (!confession) return res.status(404).json({ status: false, message: "Confession not found" });

        if (!confession.reports.includes(req.user._id)) {
            confession.reports.push(req.user._id);
            await confession.save();
        }

        // Auto-hide if too many reports?
        if (confession.reports.length > 5) {
            confession.isHidden = true;
            await confession.save();
        }

        res.status(200).json({ status: true, message: "Reported" });
    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

export default confessionRouter;
