import express from "express";
import Faculty from "../../models/faculty.js";
import * as messages from "../../constants/messages.js";
import tokenRequired from "../../middlewares/tokenRequired.js";
import { param, body, validationResult } from "express-validator";

const facultyRouter = express.Router();

/**
 * @route GET /faculty/:id
 * @desc Fetch a single faculty by ID
 */
//working
facultyRouter.get(
  "/:id",
  [tokenRequired, param("id").isMongoId().withMessage("Invalid faculty ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const faculty = await Faculty.findById(req.params.id).lean();
      if (!faculty) {
        return res
          .status(404)
          .json({ status: false, message: messages.userNotFound });
      }
      res.status(200).json({ status: true, data: faculty });
    } catch (err) {
      console.error("Error fetching faculty:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route PUT /faculty/:id
 * @desc Update faculty details
 */
//working
facultyRouter.put(
  "/:id",
  [
    param("id").isMongoId().withMessage("Invalid faculty ID"),
    body("email").optional().isEmail().withMessage("Invalid email format"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const updatedFaculty = await Faculty.findByIdAndUpdate(
        req.params.id,
        req.body,
        { new: true }
      ).populate("courses");

      if (!updatedFaculty) {
        return res
          .status(404)
          .json({ status: false, message: messages.userNotFound });
      }

      res.status(200).json({
        status: true,
        message: "Faculty updated successfully",
        data: updatedFaculty,
      });
    } catch (error) {
      console.error("Error updating faculty:", error);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route DELETE /faculty/:id
 * @desc Delete faculty by ID
 */
//working
facultyRouter.delete(
  "/:id",
  [param("id").isMongoId().withMessage("Invalid faculty ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const deletedFaculty = await Faculty.findByIdAndDelete(
        req.params.id
      ).populate("courses");

      if (!deletedFaculty) {
        return res
          .status(404)
          .json({ status: false, message: messages.userNotFound });
      }

      res.status(200).json({
        status: true,
        message: "Faculty deleted successfully",
        data: deletedFaculty,
      });
    } catch (error) {
      console.error("Error deleting faculty:", error);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

export default facultyRouter;
