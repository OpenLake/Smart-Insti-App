import express from "express";
import * as errorMessages from "../constants/messages.js";
import Student from "../models/student.js";
import Faculty from "../models/faculty.js";
import Admin from "../models/admin.js";

const generalAuthRouter = express.Router();

generalAuthRouter.post("/login", async (req, res) => {
  const { email, userType } = req.body;

  let userCollection;
  let existingUser;

  switch (userType) {
    case "student":
      userCollection = Student;
      break;
    case "faculty":
      userCollection = Faculty;
      break;
    case "admin":
      userCollection = Admin;
      break;
    default:
      return res.status(400).send({ error: errorMessages.invalidUserType });
  }

  existingUser = await userCollection.findOne({ email });

  if (!existingUser) {
    const newUser = new userCollection({ email });
    await newUser.save();
    res.send({ message: errorMessages.userCreated, user: newUser });
  } else {
    res.send({ message: errorMessages.userAlreadyExists, user: existingUser });
  }
});

export default generalAuthRouter;
