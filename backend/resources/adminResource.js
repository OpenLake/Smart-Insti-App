import { Router } from "express";
import Admin from "../models/admin.js";

const adminResource = Router();

//GET admin by id
adminResource.get("/:id", async (req, res) => {
  try {
    const admin = await Admin.findById(req.params.id);
    res.json(admin);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

export default adminResource;
