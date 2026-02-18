import express from "express";
import OrganizationalUnit from "../../models/organizationalUnit.js";
import PositionHolder from "../../models/positionHolder.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { ROLES } from "../../utils/roles.js";

const clubRouter = express.Router();

// Public: Get All Clubs/Societies
clubRouter.get("/", async (req, res) => {
  try {
    const { type, domain, search } = req.query;
    let query = {};

    if (type) query.type = type;
    if (domain) query.domain = domain;
    if (search) {
      query.name = { $regex: search, $options: "i" };
    }

    const clubs = await OrganizationalUnit.find(query).sort({ name: 1 });
    res.status(200).json({ status: true, data: clubs });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Public: Get Single Club Details with Members
clubRouter.get("/:id", async (req, res) => {
  try {
    const club = await OrganizationalUnit.findById(req.params.id);
    if (!club) return res.status(404).json({ status: false, message: "Club not found" });

    // Fetch current session members
    // Assuming default session for now, or fetch all active
    const members = await PositionHolder.find({ 
        orgUnit: req.params.id, 
        active: true 
    }).populate('user', 'name email profilePicURI academicInfo');

    res.status(200).json({ status: true, data: { ...club.toObject(), members } });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Protected: Create Club (Admin Only)
clubRouter.post("/", isAuthenticated, async (req, res) => {
  try {
    if (!req.user.roles.includes(ROLES.ADMIN)) {
        return res.status(403).json({ status: false, message: "Only Admins can create clubs" });
    }

    const { name, description, type, domain, logo, socialLinks } = req.body;

    const newClub = await OrganizationalUnit.create({
      name, description, type, domain, logo, socialLinks
    });

    res.status(201).json({ status: true, data: newClub });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Protected: Update Club (Admin or Club Admin)
clubRouter.put("/:id", isAuthenticated, async (req, res) => {
  try {
    // Check if global admin
    const isAdmin = req.user.roles.includes(ROLES.ADMIN);
    
    // Check if club admin (PositionHolder with isAdmin=true)
    const isClubAdmin = await PositionHolder.findOne({
        user: req.user._id,
        orgUnit: req.params.id,
        isAdmin: true,
        active: true
    });

    if (!isAdmin && !isClubAdmin) {
        return res.status(403).json({ status: false, message: "Unauthorized" });
    }

    const updatedClub = await OrganizationalUnit.findByIdAndUpdate(
        req.params.id, 
        req.body, 
        { new: true }
    );

    res.status(200).json({ status: true, data: updatedClub });
  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

// Protected: Add Member (Admin or Club Admin)
clubRouter.post("/:id/members", isAuthenticated, async (req, res) => {
  try {
    const isAdmin = req.user.roles.includes(ROLES.ADMIN);
    const isClubAdmin = await PositionHolder.findOne({
        user: req.user._id,
        orgUnit: req.params.id,
        isAdmin: true,
        active: true
    });

    if (!isAdmin && !isClubAdmin) {
        return res.status(403).json({ status: false, message: "Unauthorized" });
    }

    const { userId, role, isCore, isAdmin: startAsAdmin, session } = req.body;

    const newMember = await PositionHolder.create({
        user: userId,
        orgUnit: req.params.id,
        role,
        isCore: isCore || false,
        isAdmin: startAsAdmin || false,
        session: session || "2025-2026"
    });

    res.status(201).json({ status: true, data: newMember });

  } catch (err) {
    res.status(500).json({ status: false, message: err.message });
  }
});

export default clubRouter;
