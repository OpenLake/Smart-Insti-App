import express from "express";
import Skill from "../../models/skill.js";
import * as messages from "../../constants/messages.js";

const skillRouter = express.Router();

/**
 * @route GET /skills
 * @desc Get all skills
 */
skillRouter.get("/skills", async (req, res) => {
  try {
    const skills = await Skill.find({});
    res
      .status(200)
      .json({ status: true, message: "Skills retrieved", data: skills });
  } catch (error) {
    console.error("Error fetching skills:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route GET /skills/:id
 * @desc Get a single skill by ID
 */
skillRouter.get("/skills/:id", async (req, res) => {
  try {
    const skill = await Skill.findById(req.params.id);

    if (!skill) {
      return res
        .status(404)
        .json({ status: false, message: messages.skillNotFound });
    }

    res.status(200).json({ status: true, message: "Skill found", data: skill });
  } catch (error) {
    console.error("Error fetching skill:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /skills
 * @desc Create a new skill
 */
skillRouter.post("/skills", async (req, res) => {
  try {
    const newSkill = new Skill(req.body);
    await newSkill.save();

    res
      .status(201)
      .json({ status: true, message: "Skill created", data: newSkill });
  } catch (error) {
    console.error("Error creating skill:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route PUT /skills/:id
 * @desc Update an existing skill
 */
skillRouter.put("/skills/:id", async (req, res) => {
  try {
    const updatedSkill = await Skill.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    if (!updatedSkill) {
      return res
        .status(404)
        .json({ status: false, message: messages.skillNotFound });
    }

    res
      .status(200)
      .json({ status: true, message: "Skill updated", data: updatedSkill });
  } catch (error) {
    console.error("Error updating skill:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route DELETE /skills/:id
 * @desc Delete a skill
 */
skillRouter.delete("/skills/:id", async (req, res) => {
  try {
    const deletedSkill = await Skill.findByIdAndDelete(req.params.id);

    if (!deletedSkill) {
      return res
        .status(404)
        .json({ status: false, message: messages.skillNotFound });
    }

    res
      .status(200)
      .json({ status: true, message: "Skill deleted", data: deletedSkill });
  } catch (error) {
    console.error("Error deleting skill:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default skillRouter;
