import { Router } from "express";
import Student from "../models/student.js";
import tokenRequired from "../middlewares/tokenRequired.js";

const studentResource = Router();

//GET student by id
studentResource.get("/:id", tokenRequired, async (req, res) => {
  try {
    const student = await Student.findById(req.params.id);
    res.json(student);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});

export default studentResource;
