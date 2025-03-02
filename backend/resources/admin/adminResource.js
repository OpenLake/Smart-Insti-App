import { Router } from "express";
import Admin from "../../models/admin.js";
import tokenRequired from "../../middlewares/tokenRequired.js";
import mongoose from "mongoose";

const adminResource = Router();

// GET admin by ID
adminResource.get("/:id", tokenRequired, async (req, res) => {
  try {
    const { id } = req.params;

    // Validate if ID is a valid MongoDB ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res
        .status(400)
        .json({ status: false, message: "Invalid admin ID format." });
    }

    const admin = await Admin.findById(id).select("-password"); // Exclude password field

    if (!admin) {
      return res
        .status(404)
        .json({ status: false, message: "Admin not found." });
    }

    res.status(200).json({ status: true, data: admin });
  } catch (error) {
    console.error("Error fetching admin:", error);
    res.status(500).json({ status: false, message: "Internal Server Error." });
  }
});

export default adminResource;
