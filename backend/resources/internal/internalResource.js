import express from "express";
import Student from "../../models/student.js";
import Faculty from "../../models/faculty.js";
import Alumni from "../../models/alumni.js";
import hubAuth from "../../middlewares/hubAuth.js";
import { supabase } from "../../utils/supabase.js";

const internalRouter = express.Router();

/**
 * @route GET /internal/user
 * @desc Internal endpoint for user identity lookup by email
 * @access Private (X-Hub-Secret required)
 */
internalRouter.get("/user", hubAuth, async (req, res) => {
  const { email } = req.query;

  if (!email) {
    return res.status(400).json({
      status: "error",
      message: "Email parameter is required",
    });
  }

  try {
    // 1. Fetch from Supabase (Primary Source for Profiles)
    const { data: sbProfile, error: sbError } = await supabase
      .from("profiles")
      .select("*")
      .eq("email", email)
      .single();

    if (sbError && sbError.code !== "PGRST116") {
      console.error("❌ Supabase lookup error:", sbError);
    }

    // 2. Search across MongoDB for additional app-specific data (skills, etc.)
    const [student, faculty, alumni] = await Promise.all([
      Student.findOne({ email }).populate("skills achievements"),
      Faculty.findOne({ email }).populate("courses"),
      Alumni.findOne({ email }),
    ]);

    const mongoUser = student || faculty || alumni;

    // If neither exists, then 404
    if (!sbProfile && !mongoUser) {
      return res.status(404).json({
        status: "error",
        message: "User not found",
      });
    }

    // 3. Construct unified identity
    const identity = {
      email: email,
      name: sbProfile?.name || mongoUser?.name || "Smart Insti User",
      role: sbProfile?.role || (student ? "student" : faculty ? "faculty" : alumni ? "alumni" : "user"),
    };

    // 4. Construct enriched profile block
    const profile = {
      ...mongoUser?.toObject?.() || mongoUser,
      ...sbProfile, // Supabase data takes precedence for basic fields
      institute_id: sbProfile?.student_id || mongoUser?.rollNumber,
      department: sbProfile?.department || mongoUser?.branch,
      batch: sbProfile?.batch || mongoUser?.graduationYear,
    };

    res.status(200).json({
      status: "success",
      data: {
        identity,
        profile,
      },
    });


  } catch (error) {
    console.error("❌ Internal lookup error:", error);
    res.status(500).json({
      status: "error",
      message: "Internal Server Error",
    });
  }
});

export default internalRouter;

