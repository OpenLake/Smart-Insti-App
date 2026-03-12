import express from "express";
import campusPost from "../../models/campusPost.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const campusPostRouter = express.Router();

// Get Campus Posts (Public/Authenticated)
campusPostRouter.get("/", isAuthenticated, async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    
    const posts = await campusPost.find({ isHidden: false })
      .sort({ createdAt: -1 })
      .skip((page - 1) * limit)
      .limit(Number(limit))
      .select('-author -reports'); // Exclude author and reports from public view

    // Add info if current user liked it
    const enhancedPosts = posts.map(p => {
        const obj = p.toObject();
        obj.isLiked = p.likes.includes(req.user._id);
        obj.likeCount = p.likes.length;
        delete obj.likes; // Don't send full list of likers if not needed
        return obj;
    });

    res.status(200).json({ status: true, data: enhancedPosts });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Create Campus Post
campusPostRouter.post("/", isAuthenticated, async (req, res) => {
  try {
    const { content, backgroundColor } = req.body;

    if (!content) return res.status(400).json({ status: false, message: "Content is required" });

    const newPost = await campusPost.create({
      content,
      backgroundColor: backgroundColor || '0xFFFFFFFF',
      author: req.user._id
    });

    res.status(201).json({ status: true, data: { ...newPost.toObject(), author: null } });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Like/Unlike Campus Post
campusPostRouter.put("/:id/like", isAuthenticated, async (req, res) => {
    try {
        const post = await campusPost.findById(req.params.id);
        if (!post) return res.status(404).json({ status: false, message: "Post not found" });

        const userId = req.user._id;
        const index = post.likes.indexOf(userId);

        if (index === -1) {
            post.likes.push(userId);
        } else {
            post.likes.splice(index, 1);
        }

        await post.save();
        
        res.status(200).json({ 
            status: true, 
            message: index === -1 ? "Liked" : "Unliked",
            data: { likeCount: post.likes.length, isLiked: index === -1 }
        });

    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

// Report Campus Post
campusPostRouter.post("/:id/report", isAuthenticated, async (req, res) => {
    try {
        const post = await campusPost.findById(req.params.id);
        if (!post) return res.status(404).json({ status: false, message: "Post not found" });

        if (!post.reports.includes(req.user._id)) {
            post.reports.push(req.user._id);
            await post.save();
        }

        // Auto-hide if too many reports?
        if (post.reports.length > 5) {
            post.isHidden = true;
            await post.save();
        }

        res.status(200).json({ status: true, message: "Reported" });
    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

export default campusPostRouter;
