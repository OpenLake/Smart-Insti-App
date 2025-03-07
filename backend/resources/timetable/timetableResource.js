import express from "express";
import * as messages from "../../constants/messages.js";
import Timetable from "../../models/timetable.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const timetableRouter = express.Router();

/**
 * @route   POST /timetable
 * @desc    Create a new timetable (authentication required)
 */
timetableRouter.post("/", tokenRequired, async (req, res) => {
  try {
    const { creatorId, schedule, title } = req.body;

    // Validate required fields
    if (!creatorId || !schedule || !title) {
      return res
        .status(400)
        .json({ status: false, message: "Missing required fields" });
    }

    const newTimetable = new Timetable(req.body);
    const savedTimetable = await newTimetable.save();

    res.status(201).json({
      status: true,
      message: "Timetable created successfully",
      data: savedTimetable,
    });
  } catch (error) {
    console.error("Error creating timetable:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default timetableRouter;
