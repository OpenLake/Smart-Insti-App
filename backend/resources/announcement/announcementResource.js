import express from "express";
import Announcement from "../../models/announcement.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const announcementRouter = express.Router();

// Get Announcements (Public/Protected mixed strategy)
// For now, let's keep it open but maybe filter by user's access in future
announcementRouter.get("/", async (req, res) => {
  try {
    const { type, author, isPinned, search } = req.query;
    let query = {};

    if (type) query.type = type;
    if (author) query.author = author;
    if (isPinned) query.isPinned = isPinned === 'true';
    if (search) {
      query.$text = { $search: search };
    }

    // Expiry check: Don't show expired announcements unless admin requested specific logic
    // query.expiryDate = { $gt: new Date() }; // Optional, or handle in frontend

    const announcements = await Announcement.find(query)
      .populate('author', 'name email roles')
      .populate('target') // Dynamic population
      .sort({ isPinned: -1, createdAt: -1 });

    res.status(200).json({ status: true, data: announcements });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Create Announcement (Protected)
announcementRouter.post("/", isAuthenticated, async (req, res) => {
  try {
    // Basic Role Check: Only Faculty/Admin/Club Heads can post?
    // For now, let's allow all authenticated users but maybe restrict 'System' type
    
    const { title, content, type, target, targetModel, isPinned, expiryDate } = req.body;

    if (type === 'System' && !req.user.roles.includes(ROLES.ADMIN)) {
        return res.status(403).json({ status: false, message: "Only Admins can post System announcements" });
    }

    const newAnnouncement = await Announcement.create({
      title,
      content,
      author: req.user._id,
      type,
      target,
      targetModel,
      isPinned: isPinned || false,
      expiryDate
    });

    res.status(201).json({ status: true, data: newAnnouncement });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Update Announcement
announcementRouter.put("/:id", isAuthenticated, async (req, res) => {
    try {
        const announcement = await Announcement.findById(req.params.id);
        if (!announcement) return res.status(404).json({ status: false, message: "Announcement not found" });

        // Check ownership or Admin
        if (announcement.author.toString() !== req.user._id.toString() && !req.user.roles.includes(ROLES.ADMIN)) {
            return res.status(403).json({ status: false, message: "Unauthorized" });
        }

        const updatedAnnouncement = await Announcement.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(200).json({ status: true, data: updatedAnnouncement });

    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

// Delete Announcement
announcementRouter.delete("/:id", isAuthenticated, async (req, res) => {
    try {
        const announcement = await Announcement.findById(req.params.id);
        if (!announcement) return res.status(404).json({ status: false, message: "Announcement not found" });

        if (announcement.author.toString() !== req.user._id.toString() && !req.user.roles.includes(ROLES.ADMIN)) {
            return res.status(403).json({ status: false, message: "Unauthorized" });
        }

        await Announcement.findByIdAndDelete(req.params.id);
        res.status(200).json({ status: true, message: "Announcement deleted" });
    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

export default announcementRouter;
