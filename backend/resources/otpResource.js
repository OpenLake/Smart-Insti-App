import express from 'express'
import nodemailer  from 'nodemailer'
import dotenv from 'dotenv'
import * as errorConstants from '../constants/errorMessages.js';
import * as mailOption from '../constants/mailOption.js';
const otpRouter = express.Router();
import xoauth2 from 'xoauth2';
dotenv.config();

// Nodemailer configuration using Ethereal
async function getTestAccount() {
  return nodemailer.createTestAccount();
}

// Generate a random 4-digit OTP
function generateOTP() {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

// Nodemailer configuration
var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        xoauth2: xoauth2.createXOAuth2Generator({
            user: process.env.SMTP_USER,
            // clientId: '{Client ID}',
            // clientSecret: '{Client Secret}',
            // refreshToken: '{refresh-token}',
            // accessToken: '{cached access token}'
        })
    }
});
// const transporter = nodemailer.createTransport({
//   // Create an ethereal account and replace it in .env file
//   service: 'Gmail', 
//   name: process.env.SMTP_NAME,
//   host: process.env.SMTP_HOST,
//   port: process.env.SMTP_PORT,
//   // auth: {
//   //   user: process.env.SMTP_USER,
//   //   pass: process.env.SMTP_PASS,
//   // },
//   auth: {
//       user: process.env.SMTP_USER,
//       pass: process.env.SMTP_PASS,
//   }
// });

import { MongoClient } from 'mongodb';

// Connection URI for your MongoDB database
const uri = process.env.MONGODB_URI; // Change this to your actual MongoDB connection URI

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
  console.log(otp);
  // Store OTP with the associated email
  otpStorage.set(email, otp);
  
   try {
    // Connect to the MongoDB server
    await client.connect();

    // Use a specific database
    const database = client.db(dbName);

    // Use a specific collection
    const collection = database.collection(collectionName);
    await collection.deleteMany({
      email:email,
    });
    await collection.insertOne({ email, otp});
    console.log('OTP data stored in MongoDB');
  } finally {
    // Close the connection when done
    await client.close();
  }
  // Nodemailer options
  const mailOptions = {
    from: mailOption.senderEmail,
    to: email,
    subject: mailOption.subjectOTPLogin,
    text: mailOption.createOTPEmailBody(otp)
  };
  
  // Send mail
  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      return res.status(500).json({ error: errorConstants.failedToSendOTPEmail });
    }
    console.log('Message sent: %s', info.messageId);
    res.json({ message: errorConstants.otpSent, email });
  });
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

    // Retrieve stored OTP and timestamp for the email from the database
    const result = await collection.findOne({ email });
    
    if (!result || !result.otp) {
      return res.status(400).json({ error: errorConstants.noOTPFoundForEmail });
    }

    const storedOTP = result.otp;

    // Compare the provided OTP with the stored OTP
    if (otp === storedOTP) {
      // Clear OTP from storage after successful verification (for demo purposes)
      await collection.deleteOne({ email });
      return res.json({ message: errorConstants.otpVerfied });
    }

    res.status(401).json({ error: errorConstants.incorrectOTP });
  } catch (err) {
    console.error('Error:', err.message);
    res.status(500).json({ error: 'Internal Server Error' });
  } finally {
    await client.close();
  }
});

export default otpRouter