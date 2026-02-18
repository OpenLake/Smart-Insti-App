import mongoose from "mongoose";

const otpSchema = new mongoose.Schema({
  email: { type: String, required: true, trim: true },
  otp: { type: String, required: true, trim: true },
  createdAt: { type: Date, default: Date.now, expires: 300 } // 5 minutes TTL
});

const Otp = mongoose.model("Otp", otpSchema);
export default Otp;
