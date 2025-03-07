import express from "express";
import * as messages from "../../constants/messages.js";
import Timetable from "../../models/timetable.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const timetableListRouter = express.Router();

/**
 * @route GET /timetable/:id
 * @desc Get a list of timetables by creator ID (authentication required)
 */
timetableListRouter.get("/:id", tokenRequired, async (req, res) => {
  try {
    const creatorId = req.params.id;
    const timetables = await Timetable.find({ creatorId });

    if (!timetables.length) {
      return res
        .status(404)
        .json({ status: false, message: "No timetables found for this user" });
    }

    res.status(200).json({
      status: true,
      message: "Timetables retrieved successfully",
      data: timetables,
    });
  } catch (error) {
    console.error("Error fetching timetables:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route DELETE /timetable/:id
 * @desc Delete a timetable by ID (authentication required)
 */
timetableListRouter.delete("/:id", tokenRequired, async (req, res) => {
  try {
    const { id } = req.params;
    const deletedTimetable = await Timetable.findByIdAndDelete(id);

    if (!deletedTimetable) {
      return res
        .status(404)
        .json({ status: false, message: "Timetable not found" });
    }

    res.status(200).json({
      status: true,
      message: "Timetable deleted successfully",
      data: deletedTimetable,
    });
  } catch (error) {
    console.error("Error deleting timetable:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default timetableListRouter;
