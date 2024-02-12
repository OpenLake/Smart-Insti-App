import { Router } from "express";
import Faculty from "../models/faculty.js";

const facultyResource = Router();

//GET faculty by id
facultyResource.get("/:id", async (req, res) => {
  try {
    const faculty = await Faculty.findById(req.params.id);
    res.json(faculty);
  } catch (e) {
    res.status(500).json({ message: e.message });
  }
});

export default facultyResource;
