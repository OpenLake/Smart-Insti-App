import express from 'express'
import nodemailer  from 'nodemailer'
import dotenv from 'dotenv'
import { MongoClient } from 'mongodb';
import jwt from 'jsonwebtoken';
import * as errorConstants from '../constants/errorMessages.js';
import * as mailOption from '../constants/mailOption.js';

const otpRouter = express.Router();
dotenv.config();

// Generate a random 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

const transporter = nodemailer.createTransport({
  service: "Gmail",
  host: "smtp.gmail.com",
  port: 465,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD,
  },
});

// Connection URI for your MongoDB database
const uri = process.env.MONGODB_URI; 

// Create a new MongoClient
const client = new MongoClient(uri);

// Database and collection names
const dbName = mailOption.dbName;
const collectionName = mailOption.collectionName;

// Store generated OTPs temporarily (for demo purposes)
const otpStorage = new Map();

otpRouter.post('/send-otp', async (req, res) => {
  const { email } = req.body;
  if (!email) {
    return res.status(400).json({ error: errorConstants.emailIsRequired });
  }
  // Generate OTP
  const otp = generateOTP();
  
  // Store OTP with the associated email
  otpStorage.set(email, otp);
  const mailOptions = {
    from: mailOption.senderEmail,
    to: email,
    subject: mailOption.subjectOTPLogin,
    text: mailOption.createOTPEmailBody(otp)
  };
  
  // Send mail
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      console.log(error);
      return res.status(500).json({ error: errorConstants.failedToSendOTPEmail });
    }
    else{
      console.log('Message sent: %s', info.response);
      res.json({ message: errorConstants.otpSent, email });
    }
  });
  
  // Connect to the MongoDB server
  try {
    await client.connect();
    const database = client.db(dbName);
    const collection = database.collection(collectionName);
    await collection.deleteMany({
      email:email,
  });
    
    await collection.insertOne({ email, otp});
    console.log('OTP data stored in MongoDB');
    
  } finally {
    await client.close();
  }
});

otpRouter.post('/verify-otp', async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ error: errorConstants.emailAndOTPRequired });
  }

  try {
    await client.connect();
    
    const database = client.db(dbName);
    const collection = database.collection(collectionName);
    const result = await collection.findOne({ email });
    
    if (!result || !result.otp) {
      return res.status(400).json({ error: errorConstants.noOTPFoundForEmail });
    }

    const storedOTP = result.otp;

    // Compare the provided OTP with the stored OTP
    if (otp === storedOTP) {
      await collection.deleteOne({ email });
      const token = jwt.sign({ email }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1h' });
      return res.json({ message: errorConstants.otpVerfied, token });
    }
    res.status(401).json({ error: errorConstants.incorrectOTP });
  } catch (err) {
    res.status(500).json({ error: errorConstants.internalServerError });
  } finally {
    await client.close();
  }
});

export default otpRouter