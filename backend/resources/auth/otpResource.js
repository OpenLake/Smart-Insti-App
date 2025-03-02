import express from "express";
import dotenv from "dotenv";
import { MongoClient } from "mongodb";
import * as messages from "../../constants/messages.js";
import {
  getMailOptions,
  dbName,
  otpCollectionName,
} from "../../config/mailOptions.js";
import getTransporter from "../../config/emailTransporter.js";

dotenv.config();

const otpRouter = express.Router();

// Generate a random 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// Connection URI for your MongoDB database
const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);

async function connectDB() {
  if (!client.topology || !client.topology.isConnected()) {
    await client.connect();
  }
  return client.db(dbName);
}

//not working
otpRouter.post("/send-otp", async (req, res) => {
  const { email, loginForRole } = req.body;

  if (!email || !loginForRole) {
    return res
      .status(412)
      .json({ status: false, message: messages.emailIsRequired });
  }

  const collectionName = loginForRole === "student" ? "students" : "faculties";

  try {
    const db = await connectDB();
    const collection = db.collection(collectionName);
    const user = await collection.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ status: false, message: messages.userNotFound });
    }

    // Generate OTP
    const otp = generateOTP();

    // Send mail
    const mailOptions = getMailOptions(email, otp);
    const transporter = getTransporter();
    transporter.sendMail(mailOptions, async (error, info) => {
      if (error) {
        console.error(error);
        return res
          .status(400)
          .json({ status: false, message: messages.failedToSendOTPEmail });
      }
      console.log("Message sent: %s", info.response);
    });

    // Store OTP in DB
    const otpCollection = db.collection(otpCollectionName);
    await otpCollection.deleteMany({ email });
    await otpCollection.insertOne({ email, otp, createdAt: new Date() });

    res
      .status(200)
      .json({ status: true, message: `${messages.otpSent} to ${email}` });
  } catch (error) {
    console.error("OTP Send Error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

//not working
otpRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res
      .status(412)
      .json({ status: false, message: messages.emailAndOTPRequired });
  }

  try {
    const db = await connectDB();
    const otpCollection = db.collection(otpCollectionName);
    const record = await otpCollection.findOne({ email });

    if (!record) {
      return res
        .status(400)
        .json({ status: false, message: messages.otpExpired });
    }

    if (otp !== record.otp) {
      return res
        .status(401)
        .json({ status: false, message: messages.incorrectOTP });
    }

    await otpCollection.deleteOne({ email });
    res.status(200).json({ status: true, message: messages.otpVerfied });
  } catch (error) {
    console.error("OTP Verification Error:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default otpRouter;
