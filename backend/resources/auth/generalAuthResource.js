import express from "express";
import * as messages from "../../constants/messages.js";
import Student from "../../models/student.js";
import Faculty from "../../models/faculty.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const generalAuthRouter = express.Router();

generalAuthRouter.post("/login", async (req, res) => {
  try {
    const { email, loginForRole } = req.body;

    if (!email || !loginForRole) {
      return res
        .status(400)
        .json({ status: false, message: "Email and role are required." });
    }

    let userCollection;
    switch (loginForRole) {
      case "student":
        userCollection = Student;
        break;
      case "faculty":
        userCollection = Faculty;
        break;
      default:
        return res
          .status(400)
          .json({ status: false, message: messages.invalidUserType });
    }

    const user = await userCollection.findOne({ email }).lean();
    if (!user) {
      return res
        .status(401)
        .json({ status: false, message: "Invalid credentials." });
    }

    const token = jwt.sign({ id: user._id }, process.env.ACCESS_TOKEN_SECRET, {
      expiresIn: "7d",
      algorithm: "HS256",
    });

    res.status(200).json({
      status: true,
      message: "Login successful.",
      data: {
        token,
        _id: user._id,
        name: user.name,
        email: user.email,
        role: loginForRole,
      },
    });
  } catch (error) {
    console.error("Login error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default generalAuthRouter;
