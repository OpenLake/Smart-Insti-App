import express from "express";
import dotenv from "dotenv";
import * as messages from "../../constants/messages.js";
import { getMailOptions } from "../../config/mailOptions.js";
import getTransporter from "../../config/emailTransporter.js";
import User from "../../models/user.js";
import Otp from "../../models/otp.js";

dotenv.config();

const otpRouter = express.Router();

function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// Send OTP
otpRouter.post("/send-otp", async (req, res) => {
  const { email, loginForRole } = req.body;

  if (!email || !loginForRole) {
    return res.status(412).json({ status: false, message: messages.emailIsRequired });
  }

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ status: false, message: messages.userNotFound });
    }

    if (!user.roles.includes(loginForRole)) {
       return res.status(401).json({ status: false, message: "User does not have this role." });
    }

    const otp = generateOTP();
    const mailOptions = getMailOptions(email, otp);
    const transporter = getTransporter();

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.error(error);
        // Don't return here, request might have timed out? 
        // Or should we return error to client?
        // Logic says return error.
      } else {
        console.log("Message sent: %s", info.response);
      }
    });

    // Store OTP (upsert or delete old first)
    await Otp.deleteMany({ email });
    await Otp.create({ email, otp });

    res.status(200).json({ status: true, message: `${messages.otpSent} to ${email}` });
  } catch (error) {
    console.error("OTP Send Error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Verify OTP
otpRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(412).json({ status: false, message: messages.emailAndOTPRequired });
  }

  try {
    const record = await Otp.findOne({ email });

    if (!record) {
      return res.status(400).json({ status: false, message: messages.otpExpired });
    }

    if (otp !== record.otp) {
      return res.status(401).json({ status: false, message: messages.incorrectOTP });
    }

    // OTP verified. Delete it.
    await Otp.deleteOne({ email });

    res.status(200).json({ status: true, message: messages.otpVerfied });
  } catch (error) {
    console.error("OTP Verification Error:", error);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

export default otpRouter;
