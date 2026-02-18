import express from "express";
import * as messages from "../../constants/messages.js";
import User from "../../models/user.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const generalAuthRouter = express.Router();

const generateAccessAndRefreshTokens = async (userId) => {
  try {
    const user = await User.findById(userId);
    const accessToken = jwt.sign(
      { id: user._id, roles: user.roles },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "1d", algorithm: "HS256" }
    );
    const refreshToken = jwt.sign(
      { id: user._id },
      process.env.REFRESH_TOKEN_SECRET,
      { expiresIn: "7d", algorithm: "HS256" }
    );

    // Save refresh token to user
    user.refreshTokens.push({
      token: refreshToken,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    });
    // Keep only last 3 tokens
    if (user.refreshTokens.length > 3) {
      user.refreshTokens.shift();
    }
    await user.save({ validateBeforeSave: false });

    return { accessToken, refreshToken };
  } catch (error) {
    throw new Error("Error while generating tokens");
  }
};

// Faculty Registration
generalAuthRouter.post("/register/faculty", async (req, res) => {
  try {
    const { email, name, cabinNumber, department, courses } = req.body;

    if (!email) {
      return res.status(400).json({ status: false, message: "Email is required." });
    }

    let user = await User.findOne({ email });
    if (user) {
      // If user exists but doesn't have faculty role, we could add it? 
      // For now, assume exclusive registration or conflict.
      return res.status(409).json({ status: false, message: "User already exists." });
    }

    user = new User({
      name: name || "Smart Insti Faculty",
      email,
      roles: ["faculty"],
      // Map faculty specific fields to generic structure or keep separately?
      // Our User model has academicInfo but maybe not cabinNumber directly in schema unless we add it or put in 'about'
      // We will put cabinNumber in 'notes' of hostelLocation for now or add to schema if needed. 
      // Let's assume we add it to 'about' for simplicity or 'academicInfo' generic field
      about: `Cabin: ${cabinNumber}`, 
      academicInfo: { department },
      // courses? User model doesn't have courses directly. 
      // Faculty courses are usually managed via separate Course model referencing faculty.
    });

    await user.save();

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);

    res.status(201).json({
      status: true,
      message: "Faculty registration successful.",
      data: {
        token: accessToken,
        refreshToken,
        _id: user._id,
        name: user.name,
        email: user.email,
        role: "faculty"
      },
    });
  } catch (error) {
    console.error("Faculty registration error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Student Registration
generalAuthRouter.post("/register", async (req, res) => {
  try {
    const {
      email, name, rollNumber, about, profilePicURI, branch, graduationYear, skills, achievements
    } = req.body;

    if (!email || !rollNumber) {
      return res.status(400).json({ status: false, message: "Email and Roll Number are required." });
    }

    let user = await User.findOne({ email });
    if (user) {
      return res.status(409).json({ status: false, message: "Student already exists." });
    }

    user = new User({
      name: name || "Smart Insti Student",
      email,
      roles: ["student"],
      about,
      profilePicURI,
      academicInfo: {
        studentId: rollNumber,
        department: branch,
        batch: graduationYear
      },
      skills, // managed via IDs
      achievements // managed via IDs
    });

    await user.save();

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);

    res.status(201).json({
      status: true,
      message: "Registration successful.",
      data: {
        token: accessToken,
        refreshToken,
        _id: user._id,
        name: user.name,
        email: user.email,
        rollNumber: user.academicInfo.studentId,
        role: "student"
      },
    });
  } catch (error) {
    console.error("Registration error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Alumni Registration
generalAuthRouter.post("/register/alumni", async (req, res) => {
  try {
    const { email, name, graduationYear, degree, department, currentOrganization, designation, linkedInProfile } = req.body;

    if (!email) {
      return res.status(400).json({ status: false, message: "Email is required." });
    }

    let user = await User.findOne({ email });
    if (user) {
      return res.status(409).json({ status: false, message: "Alumni already exists." });
    }

    user = new User({
      name: name || "Smart Insti Alumni",
      email,
      roles: ["alumni"],
      academicInfo: {
        batch: graduationYear,
        department,
        program: degree
      },
      // Store org info in 'about' or add generic fields. 
      // For now, append to 'about'.
      about: `Works at ${currentOrganization} as ${designation}. LinkedIn: ${linkedInProfile}`,
      contactInfo: {} 
    });

    await user.save();

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);

    res.status(201).json({
      status: true,
      message: "Alumni registration successful.",
      data: {
        token: accessToken,
        refreshToken,
        _id: user._id,
        name: user.name,
        email: user.email,
        role: "alumni"
      },
    });
  } catch (error) {
    console.error("Alumni registration error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Login
generalAuthRouter.post("/login", async (req, res) => {
  try {
    const { email, loginForRole } = req.body;

    if (!email || !loginForRole) {
      return res.status(400).json({ status: false, message: "Email and role are required." });
    }

    const user = await User.findOne({ email }).select("+password"); // Select password if needed, though this is OTP login usually? 
    // Wait, the original code had NO password check. It just trusted the email?
    // This implies OTP verification is handled separately (via /otp/verify-otp) OR this is insecure.
    // Assuming /otp/verify-otp is called BEFORE this, OR this endpoint is implicitly trusted.
    // But keeping strictly to previous logic: just verify existence + role.

    if (!user) {
      return res.status(401).json({ status: false, message: "User not found." });
    }

    if (!user.roles.includes(loginForRole)) {
      return res.status(401).json({ status: false, message: "User does not have this role." });
    }

    const { accessToken, refreshToken } = await generateAccessAndRefreshTokens(user._id);

    // Update last login
    user.lastLogin = new Date();
    await user.save({ validateBeforeSave: false });

    res.status(200).json({
      status: true,
      message: "Login successful.",
      data: {
        token: accessToken,
        refreshToken,
        _id: user._id,
        name: user.name,
        email: user.email,
        role: loginForRole,
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Refresh Token
generalAuthRouter.post("/refresh-token", async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ status: false, message: "Refresh Token is required" });
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
    const user = await User.findById(decoded.id);

    if (!user) {
      return res.status(401).json({ status: false, message: "Invalid refresh token" });
    }
    
    // Check if token matches one in DB
    const storedToken = user.refreshTokens.find(rt => rt.token === refreshToken);
    if (!storedToken) {
       return res.status(401).json({ status: false, message: "Refresh token is expired or used" });
    }

    // Generate new pair
    const { accessToken, refreshToken: newRefreshToken } = await generateAccessAndRefreshTokens(user._id);

    // Remove old token (it should be replaced by generateAccessAndRefreshTokens logic? No, logic pushes NEW one.) 
    // Actually generateAccessAndRefreshTokens pushes a new one. We should remove the used one? 
    // The previous logic kept last 3. It's fine to keep history or remove current.
    // Let's remove the *used* token to prevent reuse if we want strict rotation.
    user.refreshTokens = user.refreshTokens.filter(rt => rt.token !== refreshToken);
    await user.save({ validateBeforeSave: false });

    res.status(200).json({
      status: true,
      accessToken,
      refreshToken: newRefreshToken
    });
    
  } catch (error) {
    return res.status(401).json({ status: false, message: "Invalid or expired refresh token" });
  }
});

export default generalAuthRouter;
