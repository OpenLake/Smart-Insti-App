import Student from "../../models/student.js";
import express from "express";
import * as messages from "../../constants/messages.js";
import tokenRequired from "../../middlewares/tokenRequired.js";
const studentRouter = express.Router();

studentRouter.get("/", async (req, res) => {
  try {
    const students = await Student.find()
      .populate("skills")
      .populate("achievements");
    res.json(students);
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

studentRouter.post("/", async (req, res) => {
  const { email } = req.body;
  let existingUser = await Student.findOne({ email })
    .populate("skills")
    .populate("achievements");
  try {
    if (!existingUser) {
      const newUser = new Student({ email });
      await newUser.save();
      res.send({ message: messages.userCreated, user: newUser });
    } else {
      res.send({
        message: messages.userAlreadyExists,
        user: existingUser,
      });
    }
  } catch (error) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

studentRouter.get("/:id", tokenRequired, async (req, res) => {
  const studentId = req.params.id;

  try {
    const student = await Student.findById(studentId);

    if (!student) {
      return res.status(404).json({ message: messages.userNotFound });
    }

    res.json(student);
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

studentRouter.put("/:id", async (req, res) => {
  const studentId = req.params.id;
  const studentData = req.body;

  try {
    const updatedStudent = await Student.findByIdAndUpdate(
      studentId,
      studentData,
      { new: true }
    )
      .populate("skills")
      .populate("achievements");
    res.json(updatedStudent);
  } catch (error) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

studentRouter.delete("/:id", async (req, res) => {
  const studentId = req.params.id;

  try {
    const deletedStudent = await Student.findByIdAndDelete(studentId)
      .populate("skills")
      .populate("achievements");
    res.json(deletedStudent);
  } catch (error) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

export default studentRouter;
