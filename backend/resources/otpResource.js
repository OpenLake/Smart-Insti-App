import express from "express";
import dotenv from "dotenv";
import { MongoClient } from "mongodb";
import * as messages from "../constants/messages.js";
import transporter from "../config/emailTransporter.js";
import {
  getMailOptions,
  dbName,
  otpCollectionName,
} from "../config/mailOptions.js";

const otpRouter = express.Router();
dotenv.config();

// Generate a random 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// Connection URI for your MongoDB database
const uri = process.env.MONGODB_URI;

// Create a new MongoClient
const client = new MongoClient(uri);

otpRouter.post("/send-otp", async (req, res) => {
  const { email } = req.body;
  if (!email) {
    return res.status(400).json({ error: messages.emailIsRequired });
  }
  // Generate OTP
  const otp = generateOTP();

  const mailOptions = getMailOptions(email, otp);

  // Send mail
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      return res.status(500).json({ error: messages.failedToSendOTPEmail });
    } else {
      console.log("Message sent: %s", info.response);
      res.json({ message: messages.otpSent, email });
    }
  });

  // Connect to the MongoDB server
  try {
    await client.connect();
    const database = client.db(dbName);
    const collection = database.collection(otpCollectionName);
    await collection.deleteMany({
      email: email,
    });

    await collection.insertOne({ email, otp });
    console.log("OTP data stored in MongoDB");
  } finally {
    await client.close();
  }
});

otpRouter.post("/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ error: messages.emailAndOTPRequired });
  }

  try {
    await client.connect();

    const database = client.db(dbName);
    const otpCollection = database.collection(otpCollectionName);
    const result = await otpCollection.findOne({ email });

    if (!result || !result.otp) {
      return res.status(400).json({ error: messages.noOTPFoundForEmail });
    }

    const storedOTP = result.otp;

    // Compare the provided OTP with the stored OTP
    if (otp === storedOTP) {
      await otpCollection.deleteOne({ email });
      return res.json({ message: messages.otpVerfied });
    }
    res.status(401).json({ error: messages.incorrectOTP });
  } catch (err) {
    res.status(500).json({ error: messages.internalServerError });
  } finally {
    await client.close();
  }
});

export default otpRouter;
