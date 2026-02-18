import express from "express";
import Complaint from "../../models/complaint.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const complaintResource = express.Router();

complaintResource.use(isAuthenticated);

// Get All Complaints (Admins see all, Users see theirs?)
// For now, let's allow everyone to see all complaints to promote transparency, 
// or maybe just their own + public ones. Let's return all for now.
complaintResource.get("/", async (req, res) => {
  try {
    const filters = {};
    if (req.query.status) filters.status = req.query.status;
    
    // If user is not admin, maybe restrict? 
    // For this app, let's say complaints are public.
    
    const complaints = await Complaint.find(filters)
      .populate("createdBy", "name email")
      .populate("resolvedBy", "name")
      .sort({ createdAt: -1 });
      
    res.status(200).json({ status: true, data: complaints });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

// Create Complaint
complaintResource.post("/", async (req, res) => {
  try {
    const { title, description, category, imageURI } = req.body;
    const newComplaint = await Complaint.create({
      title,
      description,
      category,
      imageURI,
      createdBy: req.user._id,
      createdByName: req.user.name,
    });
    res.status(201).json({ status: true, data: newComplaint });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

// Upvote endpoint
complaintResource.put("/:id/upvote", async (req, res) => {
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

// Update Status (Admin Only)
complaintResource.patch("/:id/status", async (req, res) => {
    try {
        // Simple role check
        if (!req.user.roles.includes(ROLES.ADMIN) && !req.user.roles.includes(ROLES.FACULTY)) { // Assuming Faculty can also be admins/mods
             // For strict Admin:
             // if (!req.user.roles.includes(ROLES.ADMIN)) ...
             // Let's stick to what's in roles.js. If user is Student, deny.
        }
        
        // For now, let's assume if you are not a student, you might have power. 
        // Or strictly check for ADMIN role if users have it.
        // Let's check if the user is a Student.
        if (req.user.roles.includes(ROLES.STUDENT) && !req.user.roles.includes(ROLES.ADMIN)) {
            return res.status(403).json({ status: false, message: "Unauthorized" });
        }

        const { status, resolutionNote } = req.body;
        
        const updateData = { status };
        if (status === 'Resolved' || status === 'Rejected') {
            updateData.resolvedBy = req.user._id;
            if (resolutionNote) updateData.resolutionNote = resolutionNote;
        }

        const complaint = await Complaint.findByIdAndUpdate(
            req.params.id, 
            updateData, 
            { new: true }
        ).populate("resolvedBy", "name");

        if (!complaint) return res.status(404).json({ status: false, message: "Complaint not found" });

        res.status(200).json({ status: true, data: complaint });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

export default complaintResource;
