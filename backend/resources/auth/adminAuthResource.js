import { Router } from "express";
import Admin from "../../models/admin.js";
import dotenv from "dotenv";
import jwt from "jsonwebtoken";
import bcryptjs from "bcryptjs";
import * as messages from "../../constants/messages.js";
import rateLimit from "express-rate-limit";
import mongoose from "mongoose";

dotenv.config();

const adminAuthRouter = Router();

// Rate limiter (max 5 attempts per 10 minutes to prevent brute force attacks)
const loginLimiter = rateLimit({
  windowMs: 10 * 60 * 1000, // 10 minutes
  max: 5,
  message: { msg: "Too many login attempts. Try again later." },
});

// Sign-Up Route
adminAuthRouter.post("/register", async (req, res) => {
  try {
    const { email, password, name } = req.body;

    // Basic validation
    if (!email || !password || !name) {
      return res
        .status(400)
        .json({ status: false, message: "All fields are required." });
    }

    if (!/^\S+@\S+\.\S+$/.test(email)) {
      return res
        .status(400)
        .json({ status: false, message: "Invalid email format." });
    }

    if (password.length < 6) {
      return res.status(400).json({
        status: false,
        message: "Password must be at least 6 characters.",
      });
    }

    // Check if email exists
    const existingUser = await Admin.findOne({ email }).lean();
    if (existingUser) {
      return res
        .status(409)
        .json({ status: false, message: messages.userAlreadyExists });
    }

    const hashedPassword = await bcryptjs.hash(password, 10);
    const admin = await Admin.create({ email, name, password: hashedPassword });

    res.status(201).json({ status: true, message: messages.userCreated });
  } catch (error) {
    console.error("Error registering admin:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

// Sign-In Route
adminAuthRouter.post("/login", loginLimiter, async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ status: false, message: "Email and password are required." });
    }

    const user = await Admin.findOne({ email }).select("+password"); // Ensure password is fetched

    if (!user) {
      return res
        .status(401)
        .json({ status: false, message: "Invalid credentials." });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(401)
        .json({ status: false, message: "Invalid credentials." });
    }

    // Generate JWT token with expiration & secure signing
    const token = jwt.sign({ id: user._id }, process.env.ACCESS_TOKEN_SECRET, {
      expiresIn: "7d",
      algorithm: "HS256",
    });

    res.status(200).json({
      token,
      _id: user._id,
      name: user.name,
      email: user.email,
      role: "admin",
    });
  } catch (error) {
    console.error("Login error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default adminAuthRouter;
