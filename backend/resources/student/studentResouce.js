import express from "express";
import Student from "../../models/student.js";
import * as messages from "../../constants/messages.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const studentRouter = express.Router();

/**
 * @route GET /students/:id
 * @desc Get a student by ID (with authentication)
 */
studentRouter.get("/:id", tokenRequired, async (req, res) => {
  try {
    const student = await Student.findById(req.params.id)
      .populate("skills")
      .populate("achievements");

    if (!student) {
      return res
        .status(404)
        .json({ status: false, message: messages.userNotFound });
    }

    res
      .status(200)
      .json({ status: true, message: "Student found", data: student });
  } catch (error) {
    console.error("Error fetching student:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route PUT /students/:id
 * @desc Update student details (requires authentication)
 */
studentRouter.put("/:id", tokenRequired, async (req, res) => {
  try {
    const updatedStudent = await Student.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    )
      .populate("skills")
      .populate("achievements");

    if (!updatedStudent) {
      return res
        .status(404)
        .json({ status: false, message: messages.userNotFound });
    }

    res.status(200).json({
      status: true,
      message: messages.userUpdated,
      data: updatedStudent,
    });
  } catch (error) {
    console.error("Error updating student:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route DELETE /students/:id
 * @desc Delete a student by ID (requires authentication)
 */
studentRouter.delete("/:id", tokenRequired, async (req, res) => {
  try {
    const deletedStudent = await Student.findByIdAndDelete(req.params.id)
      .populate("skills")
      .populate("achievements");

    if (!deletedStudent) {
      return res
        .status(404)
        .json({ status: false, message: messages.userNotFound });
    }

    res.status(200).json({
      status: true,
      message: messages.userDeleted,
      data: deletedStudent,
    });
  } catch (error) {
    console.error("Error deleting student:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default studentRouter;
