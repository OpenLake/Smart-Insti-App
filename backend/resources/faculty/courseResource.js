import express from "express";
import mongoose from "mongoose";
import { body, param, validationResult } from "express-validator";
import Course from "../../models/course.js";
import * as messages from "../../constants/messages.js";

const courseRouter = express.Router();

/**
 * @route GET /courses
 * @desc Fetch all courses
 */
//working
courseRouter.get("/courses", async (req, res) => {
  try {
    const courses = await Course.find({}).lean();
    res.status(200).json({ status: true, data: courses });
  } catch (err) {
    console.error("Error fetching courses:", err);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route GET /courses/:id
 * @desc Fetch a single course by ID
 */
//working
courseRouter.get(
  "/courses/:id",
  [param("id").isMongoId().withMessage("Invalid course ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const course = await Course.findById(req.params.id).lean();
      if (!course) {
        return res
          .status(404)
          .json({ status: false, message: messages.courseNotFound });
      }
      res.status(200).json({ status: true, data: course });
    } catch (err) {
      console.error("Error fetching course:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route POST /courses
 * @desc Create a new course
 */
//working
courseRouter.post(
  "/courses",
  [body("name").notEmpty().withMessage("Course name is required")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const newCourse = await Course.create(req.body);
      res.status(201).json({
        status: true,
        message: "Course created successfully",
        data: newCourse,
      });
    } catch (err) {
      console.error("Error creating course:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route PUT /courses/:id
 * @desc Update a course by ID
 */
//working
courseRouter.put(
  "/courses/:id",
  [param("id").isMongoId().withMessage("Invalid course ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const updatedCourse = await Course.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true, lean: true }
      );
      if (!updatedCourse) {
        return res
          .status(404)
          .json({ status: false, message: messages.courseNotFound });
      }
      res.status(200).json({
        status: true,
        message: "Course updated successfully",
        data: updatedCourse,
      });
    } catch (err) {
      console.error("Error updating course:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route DELETE /courses/:id
 * @desc Delete a course by ID
 */
//working
courseRouter.delete(
  "/courses/:id",
  [param("id").isMongoId().withMessage("Invalid course ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const deletedCourse = await Course.findByIdAndDelete(req.params.id);
      if (!deletedCourse) {
        return res
          .status(404)
          .json({ status: false, message: messages.courseNotFound });
      }
      res.status(200).json({
        status: true,
        message: "Course deleted successfully",
        data: deletedCourse,
      });
    } catch (err) {
      console.error("Error deleting course:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

export default courseRouter;
