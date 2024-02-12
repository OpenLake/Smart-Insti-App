import { Router } from "express";
import Student from "../models/student.js";

const studentResource = Router();

//GET student by id
studentResource.get("/:id", async (req, res) => {
  try {
    const student = await Student.findById(req.params.id);
    res.json(student);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});

export default studentResource;
