import mongoose from "mongoose";

const achievementSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true, unique: true },
    date: { type: Date, required: true, default: Date.now },
    description: { type: String, required: true, trim: true },
  },
  { timestamps: true }
);

const Achievement = mongoose.model("Achievement", achievementSchema);
export default Achievement;
