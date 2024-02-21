import Course from "../../models/course.js";
import express from "express";
import * as messages from "../../constants/messages.js";

const courseListRouter = express.Router();

// Get list of course
courseListRouter.get("/", async (req, res) => {
  try {
    const courses = await Course.find();
    res.json(courses);
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

// Post a new course
courseListRouter.post("/", async (req, res) => {
  const courseData = req.body;
  try {
    const newCourse = await Course.create(courseData);
    res.json(newCourse);
  } catch (error) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

export default courseListRouter;
