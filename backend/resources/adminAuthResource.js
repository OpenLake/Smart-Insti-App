import { Router } from "express";
import Admin from "../models/admin.js";
import dotenv from "dotenv";
import jwt from "jsonwebtoken";
import bcryptjs from "bcryptjs";

const adminAuthRouter = Router();
dotenv.config();

// Sign-Up Route
adminAuthRouter.post("/admin-register", async (req, res) => {
  try {
    const { email, password } = req.body;
    const existingUser = await Admin.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: errorMessages.userAlreadyExists });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    let admin = new Admin({
      email,
      password: hashedPassword,
    });

    admin = await admin.save();

    const token = jwt.sign({ admin }, process.env.ACCESS_TOKEN_SECRET, {
      expiresIn: "1h",
    });
    res.json(admin);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Sign-In Route
adminAuthRouter.post("/admin-login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await Admin.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: errorMessages.userNotFound });
    }

    const isMatch = await bcryptjs.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: errorMessages.incorrectPassword });
    }

    const token = jwt.sign({ id: user._id }, process.env.ACCESS_TOKEN_SECRET);
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: errorMessages.internalServerError });
  }
});
