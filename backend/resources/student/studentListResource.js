import express from "express";
import Student from "../../models/student.js";
import * as messages from "../../constants/messages.js";

const studentListResource = express.Router();

/**
 * @route GET /students
 * @desc Get all students (with optional population of skills & achievements)
 */
studentListResource.get("/", async (req, res) => {
  try {
    const students = await Student.find()
      .populate("skills")
      .populate("achievements");

    res
      .status(200)
      .json({ status: true, message: "Students retrieved", data: students });
  } catch (error) {
    console.error("Error fetching students:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /students
 * @desc Create a new student if not exists, otherwise return existing student
 */
//working
studentListResource.post("/", async (req, res) => {
  try {
    const { email } = req.body;

    let student = await Student.findOne({ email })
      .populate("skills")
      .populate("achievements");

    if (!student) {
      student = new Student({ email });
      await student.save();

      return res
        .status(201)
        .json({ status: true, message: messages.userCreated, data: student });
    }

    res.status(200).json({
      status: true,
      message: messages.userAlreadyExists,
      data: student,
    });
  } catch (error) {
    console.error("Error creating student:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default studentListResource;
