import express from "express";
import Achievement from "../../models/achievement.js";
import * as messages from "../../constants/messages.js";

const achievementRouter = express.Router();

/**
 * @route GET /achievements
 * @desc Get all achievements
 */
achievementRouter.get("/", async (req, res) => {
  try {
    const achievements = await Achievement.find({});
    res.status(200).json({
      status: true,
      message: "Achievements retrieved",
      data: achievements,
    });
  } catch (error) {
    console.error("Error fetching achievements:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route GET /achievements/:id
 * @desc Get a single achievement by ID
 */
achievementRouter.get("/:id", async (req, res) => {
  try {
    const achievement = await Achievement.findById(req.params.id);

    if (!achievement) {
      return res
        .status(404)
        .json({ status: false, message: messages.achievementNotFound });
    }

    res
      .status(200)
      .json({ status: true, message: "Achievement found", data: achievement });
  } catch (error) {
    console.error("Error fetching achievement:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /achievements
 * @desc Create a new achievement
 */
achievementRouter.post("/", async (req, res) => {
  try {
    const newAchievement = new Achievement(req.body);
    await newAchievement.save();

    res.status(201).json({
      status: true,
      message: "Achievement created",
      data: newAchievement,
    });
  } catch (error) {
    console.error("Error creating achievement:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route PUT /achievements/:id
 * @desc Update an existing achievement
 */
achievementRouter.put("/:id", async (req, res) => {
  try {
    const updatedAchievement = await Achievement.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
      }
    );

    if (!updatedAchievement) {
      return res
        .status(404)
        .json({ status: false, message: messages.achievementNotFound });
    }

    res.status(200).json({
      status: true,
      message: "Achievement updated",
      data: updatedAchievement,
    });
  } catch (error) {
    console.error("Error updating achievement:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route DELETE /achievements/:id
 * @desc Delete an achievement
 */
achievementRouter.delete("/:id", async (req, res) => {
  try {
    const deletedAchievement = await Achievement.findByIdAndDelete(
      req.params.id
    );

    if (!deletedAchievement) {
      return res
        .status(404)
        .json({ status: false, message: messages.achievementNotFound });
    }

    res.status(200).json({
      status: true,
      message: "Achievement deleted",
      data: deletedAchievement,
    });
  } catch (error) {
    console.error("Error deleting achievement:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default achievementRouter;
