import express from "express";
import Faculty from "../../models/faculty.js";
import * as messages from "../../constants/messages.js";
import { body, validationResult } from "express-validator";

const facultyListResource = express.Router();

/**
 * @route GET /faculty
 * @desc Fetch all faculties
 */
//working
facultyListResource.get("/", async (req, res) => {
  try {
    const faculties = await Faculty.find().lean();
    res.status(200).json({ status: true, data: faculties });
  } catch (err) {
    console.error("Error fetching faculties:", err);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /faculty
 * @desc Create a new faculty entry
 */
//working
facultyListResource.post(
  "/",
  [body("email").isEmail().withMessage("Valid email is required")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    const { email } = req.body;

    try {
      let existingUser = await Faculty.findOne({ email }).lean();
      if (existingUser) {
        return res.status(409).json({
          status: false,
          message: messages.userAlreadyExists,
          user: existingUser,
        });
      }

      const newUser = await Faculty.create({ email });
      res
        .status(201)
        .json({ status: true, message: messages.userCreated, user: newUser });
    } catch (error) {
      console.error("Error creating faculty:", error);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

export default facultyListResource;
