import express from "express";
import Resource from "../../models/resource.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { upload } from "../../utils/cloudinary.js";
import { ROLES } from "../../utils/roles.js";

const resourceRouter = express.Router();

// Get Resources (filtered)
resourceRouter.get("/", async (req, res) => {
  try {
    const { department, semester, subject, type, search } = req.query;
    let query = {};

    if (department) query.department = department;
    if (semester) query.semester = semester;
    if (Object.keys(query).length === 0 && !search) {
       // If no filter, maybe return empty or just recent uploads?
       // Let's return recent 20
    }
    
    if (subject) query.subject = subject;
    if (type) query.type = type;
    if (search) {
      query.$text = { $search: search };
    }

    const resources = await Resource.find(query)
      .populate('uploadedBy', 'name email roles')
      .sort({ createdAt: -1 })
      .limit(50);

    res.status(200).json({ status: true, data: resources });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Upload Resource
resourceRouter.post("/", isAuthenticated, upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ status: false, message: "File is required" });
    }

    const { title, description, subject, semester, department, type } = req.body;

    const newResource = await Resource.create({
      title,
      description,
      subject,
      semester,
      department,
      type: type || 'Notes',
      fileUrl: req.file.path,
      publicId: req.file.filename,
      uploadedBy: req.user._id
    });

    res.status(201).json({ status: true, data: newResource });
  } catch (err) {
    console.error("Upload Error:", err);
    res.status(500).json({ status: false, message: err.message });
  }
});

// Delete Resource
resourceRouter.delete("/:id", isAuthenticated, async (req, res) => {
  try {
    const resource = await Resource.findById(req.params.id);
    if (!resource) return res.status(404).json({ status: false, message: "Resource not found" });

    // Check ownership or Admin
    if (resource.uploadedBy.toString() !== req.user._id.toString() && !req.user.roles.includes(ROLES.ADMIN)) {
        return res.status(403).json({ status: false, message: "Unauthorized" });
    }
    
    // Ideally delete from Cloudinary too, but skipping for MVP speed
    // import cloudinary ... cloudinary.uploader.destroy(resource.publicId)

    await Resource.findByIdAndDelete(req.params.id);
    res.status(200).json({ status: true, message: "Resource deleted" });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

export default resourceRouter;
