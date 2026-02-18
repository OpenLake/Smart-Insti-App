import express from "express";
import Event from "../../models/event.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const eventRouter = express.Router();

// Get Events (Public/Authenticated)
eventRouter.get("/", async (req, res) => {
  try {
    const { start, end, type } = req.query;
    let query = { isPublic: true };

    if (start && end) {
      query.startTime = { $gte: new Date(start), $lte: new Date(end) };
    }
    
    if (type) query.type = type;

    const events = await Event.find(query)
      .populate('organizer', 'name')
      .sort({ startTime: 1 });

    res.status(200).json({ status: true, data: events });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Create Event (Admin/Faculty/Club Admin)
eventRouter.post("/", isAuthenticated, async (req, res) => {
  try {
    const { title, description, startTime, endTime, location, type, organizer } = req.body;

    // TODO: Add refined RBAC here. For now, assuming authenticated users can post if they have a role.
    // In production, check if user is admin or club head.
    
    const newEvent = await Event.create({
      title,
      description,
      startTime,
      endTime,
      location,
      type: type || 'Other',
      organizer,
      createdBy: req.user._id
    });

    res.status(201).json({ status: true, data: newEvent });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Delete Event
eventRouter.delete("/:id", isAuthenticated, async (req, res) => {
    try {
        const event = await Event.findById(req.params.id);
        if (!event) return res.status(404).json({ status: false, message: "Event not found" });

        if (event.createdBy.toString() !== req.user._id.toString() && !req.user.roles.includes(ROLES.ADMIN)) {
            return res.status(403).json({ status: false, message: "Unauthorized" });
        }

        await Event.findByIdAndDelete(req.params.id);
        res.status(200).json({ status: true, message: "Event deleted" });
    } catch (err) {
        res.status(500).json({ status: false, message: err.message });
    }
});

export default eventRouter;
