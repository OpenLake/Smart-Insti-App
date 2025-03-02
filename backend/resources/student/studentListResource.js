import Student from "../../models/student.js";
import express from "express";
import * as messages from "../../constants/messages.js";

const studentListResource = express.Router();

studentListResource.get("/", async (req, res) => {
  try {
    const students = await Student.find();
    res.json(students);
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

studentListResource.post("/", async (req, res) => {
  const { email } = req.body;
  let existingUser = await Student.findOne({ email });
  try {
    if (!existingUser) {
      const newUser = new Student({
        ...req.body,
      });
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

export default studentListResource;
