import { Router } from "express";
import Faculty from "../models/faculty.js";
import tokenRequired from "../middlewares/tokenRequired.js";

const facultyResource = Router();

//GET faculty by id
facultyResource.get("/:id", tokenRequired, async (req, res) => {
  try {
    const faculty = await Faculty.findById(req.params.id);
    res.json(faculty);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});

export default facultyResource;
