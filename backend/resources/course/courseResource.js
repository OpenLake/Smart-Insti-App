import Course from "../../models/course.js";
import express from "express";
import * as messages from "../../constants/messages.js";

const courseRouter = express.Router();

// DELETE a course
courseRouter.delete("/:id", async (req, res) => {
  try {
    const course = await Course.findByIdAndDelete(req.params.id);
    if (course) {
      res.json({ message: messages.courseDeleted });
    } else {
      res.status(404).json({ message: messages.courseNotFound });
    }
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

// PUT a course
courseRouter.put("/:id", async (req, res) => {
  try {
    const course = await Course.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (course) {
      res.json(course);
    } else {
      res.status(404).json({ message: messages.courseNotFound });
    }
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

export default courseRouter;
