import express from 'express'
import nodemailer  from 'nodemailer'
import dotenv from 'dotenv'
import * as errorConstants from '../constants/errorMessages.js';
import * as mailOption from '../constants/mailOption.js';

const otpRouter = express.Router();

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
const transporter = nodemailer.createTransport({
  // Create an ethereal account and replace it in .env file 
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
  },
});

// Store generated OTPs temporarily (for demo purposes)
const otpStorage = new Map();

otpRouter.post('/send-otp', (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ error: errorConstants.emailIsRequired });
  }

  // Generate OTP
  const otp = generateOTP();
  console.log(otp);
  // Store OTP with the associated email
  otpStorage.set(email, otp);

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
    res.json({ message: errorConstants.otpSent, email });
  });
});

otpRouter.post('/verify-otp', (req, res) => {
  const { email, otp } = req.body;
  if (!email || !otp) {
    return res.status(400).json({ error: errorConstants.emailAndOTPRequired });
  }

  // Retrieve stored OTP for the email
  const storedOTP = otpStorage.get(email);

  if (!storedOTP) {
    return res.status(400).json({ error: errorConstants.noOTPFoundForEmail});
  }

  // Compare the provided OTP with the stored OTP
  if (otp === storedOTP) {
    // Clear OTP from storage after successful verification (for demo purposes)
    otpStorage.delete(email);
    return res.json({ message: errorConstants.otpVerfied});
  }

  res.status(400).json({ error: errorConstants.incorrectOTP });
});

export default otpRouter