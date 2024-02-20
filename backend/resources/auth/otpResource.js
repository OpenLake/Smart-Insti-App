import express from "express";
import dotenv from "dotenv";
import * as messages from "../../constants/messages.js";
import transporter from "../../config/emailTransporter.js";
import { getMailOptions } from "../../config/mailOptions.js";
import Student from "../../models/student.js";
import OTP from "../../models/otp.js";

const otpRouter = express.Router();
dotenv.config();

// Generate a random 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

otpRouter.post("/send-otp", async (req, res) => {
  const { email, loginForRole } = req.body;

  if (!email || !loginForRole) {
    return res.status(412).json({ error: messages.emailIsRequired });
  }

  try {
    let result = null;
    if (loginForRole === "student") {
      result = await Student.findOne({ email });
    } else {
      result = await Faculty.findOne({ email });
    }

    if (!result) {
      return res.status(400).json({ message: messages.userNotFound });
    }
  } catch (err) {
    return res.status(500).json({ message: messages.internalServerError });
  }
  // Generate OTP
  const otp = generateOTP();

  const mailOptions = getMailOptions(email, otp);

  // Send mail
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      return res.status(400).json({ message: messages.failedToSendOTPEmail });
    } else {
      console.log("Message sent: %s", info.response);
      res.json({ message: messages.otpSent + " to " + email });
    }
  });

  // Connect to the MongoDB server
  try {
    await OTP.deleteMany({
      email: email,
    });
    const createdAt = new Date();
    await OTP.create({ email, otp, createdAt });
  } catch (err) {
    return res.status(500).json({ message: messages.internalServerError });
  }
});

otpRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(412).json({ message: messages.emailAndOTPRequired });
  }

  try {
    const result = await OTP.findOne({ email });

    if (!result || !result.otp) {
      return res.status(400).json({ message: messages.otpExpired });
    }

    const storedOTP = result.otp;

    if (otp === storedOTP) {
      await OTP.deleteOne({ email });
      return res.status(200).json({ message: messages.otpVerfied });
    }
    res.status(401).json({ message: messages.incorrectOTP });
  } catch (err) {
    res.status(500).json({ message: messages.internalServerError });
  }
});

export default otpRouter;
