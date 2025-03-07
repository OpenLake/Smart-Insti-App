import dotenv from "dotenv";
import nodemailer from "nodemailer";

dotenv.config();

let transporter;

/**
 * Creates and returns a mail transporter instance.
 */
const getTransporter = () => {
  if (!transporter) {
    if (!process.env.SMTP_USER || !process.env.SMTP_PASSWORD) {
      throw new Error("SMTP credentials are missing in environment variables.");
    }

    transporter = nodemailer.createTransport({
      service: process.env.SMTP_SERVICE || "Gmail",
      host: process.env.SMTP_HOST || "smtp.gmail.com",
      port: parseInt(process.env.SMTP_PORT, 10) || 465,
      secure: process.env.SMTP_PORT === "465", // Use secure mode for port 465
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASSWORD,
      },
    });
  }
  return transporter;
};

export default getTransporter;
