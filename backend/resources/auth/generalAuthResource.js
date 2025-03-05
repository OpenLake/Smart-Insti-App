import express from "express";
import * as messages from "../../constants/messages.js";
import Student from "../../models/student.js";
import Faculty from "../../models/faculty.js";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const generalAuthRouter = express.Router();

// faculty registration(working)
generalAuthRouter.post("/register/faculty", async (req, res) => {
  try {
    const { email, name, cabinNumber, department, courses } = req.body;

    if (!email) {
      return res
        .status(400)
        .json({ status: false, message: "Email is required." });
    }

    // Check if faculty member already exists
    let faculty = await Faculty.findOne({ email }).lean();
    if (faculty) {
      return res
        .status(409)
        .json({ status: false, message: "Faculty member already exists." });
    }

    // Create a new faculty member
    faculty = new Faculty({
      name: name || "Smart Insti User",
      email,
      cabinNumber,
      department,
      courses,
    });

    await faculty.save();

    // Generate JWT token
    const token = jwt.sign(
      { id: faculty._id },
      process.env.ACCESS_TOKEN_SECRET,
      { expiresIn: "7d", algorithm: "HS256" }
    );

    res.status(201).json({
      status: true,
      message: "Faculty registration successful.",
      data: {
        token,
        _id: faculty._id,
        name: faculty.name,
        email: faculty.email,
      },
    });
  } catch (error) {
    console.error("Faculty registration error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

//student registration(working)
generalAuthRouter.post("/register", async (req, res) => {
  try {
    const {
      email,
      name,
      rollNumber,
      about,
      profilePicURI,
      branch,
      graduationYear,
      skills,
      achievements,
    } = req.body;

    if (!email || !rollNumber) {
      return res.status(400).json({
        status: false,
        message: "Email and Roll Number are required.",
      });
    }

    // Check if student already exists
    let student = await Student.findOne({ email }).lean();
    if (student) {
      return res
        .status(409)
        .json({ status: false, message: "Student already exists." });
    }

    // Create a new student
    student = new Student({
      name: name || "Smart Insti User",
      email,
      rollNumber,
      about,
      profilePicURI,
      branch,
      graduationYear,
      skills,
      achievements,
    });

    await student.save();

    // Generate JWT token
    const token = jwt.sign(
      { id: student._id },
      process.env.ACCESS_TOKEN_SECRET,
      {
        expiresIn: "7d",
        algorithm: "HS256",
      }
    );

    res.status(201).json({
      status: true,
      message: "Registration successful.",
      data: {
        token,
        _id: student._id,
        name: student.name,
        email: student.email,
        rollNumber: student.rollNumber,
      },
    });
  } catch (error) {
    console.error("Registration error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

//working
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
