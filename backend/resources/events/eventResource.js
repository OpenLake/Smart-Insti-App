import express from "express";
import Event from "../../models/event.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const eventResource = express.Router();

eventResource.get("/", async (req, res) => {
  try {
    const events = await Event.find().sort({ date: 1 });
    res.status(200).json({ status: true, data: events });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

eventResource.post("/", tokenRequired, async (req, res) => {
  try {
    const { title, description, date, location, imageURI, organizedBy } = req.body;
    const newEvent = new Event({
      title,
      description,
      date,
      location,
      imageURI,
      organizedBy,
      createdBy: req.user._id,
    });
    await newEvent.save();
    res.status(201).json({ status: true, data: newEvent });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

eventResource.put("/:id", tokenRequired, async (req, res) => {
    try {
        const event = await Event.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!event) return res.status(404).json({ status: false, message: "Event not found" });
        res.status(200).json({ status: true, data: event });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

eventResource.delete("/:id", tokenRequired, async (req, res) => {
    try {
        const result = await Event.findByIdAndDelete(req.params.id);
        if (!result) return res.status(404).json({ status: false, message: "Event not found" });
        res.status(200).json({ status: true, message: "Event deleted" });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

export default eventResource;
