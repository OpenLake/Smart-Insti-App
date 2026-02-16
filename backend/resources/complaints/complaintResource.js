import express from "express";
import Complaint from "../../models/complaint.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const complaintResource = express.Router();

complaintResource.get("/", tokenRequired, async (req, res) => {
  try {
    const complaints = await Complaint.find().sort({ createdAt: -1 });
    res.status(200).json({ status: true, data: complaints });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

complaintResource.post("/", tokenRequired, async (req, res) => {
  try {
    const { title, description, category, imageURI } = req.body;
    const newComplaint = new Complaint({
      title,
      description,
      category,
      imageURI,
      createdBy: req.user._id,
      createdByName: req.user.name,
    });
    await newComplaint.save();
    res.status(201).json({ status: true, data: newComplaint });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

// Upvote endpoint
complaintResource.put("/:id/upvote", tokenRequired, async (req, res) => {
    try {
        const complaint = await Complaint.findById(req.params.id);
        if(!complaint) return res.status(404).json({ status: false, message: "Complaint not found" });
        
        if(complaint.upvotes.includes(req.user._id)){
            complaint.upvotes.pull(req.user._id);
        } else {
            complaint.upvotes.push(req.user._id);
        }
        await complaint.save();
        res.status(200).json({ status: true, data: complaint });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

complaintResource.put("/:id", tokenRequired, async (req, res) => { // Mostly for updating status by Admin
    try {
        const complaint = await Complaint.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.status(200).json({ status: true, data: complaint });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

export default complaintResource;
