import mongoose from "mongoose";

const linkSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    url: { type: String, required: true, trim: true },
    category: {
      type: String,
      enum: ["Academic", "Hostel", "Club", "Other"],
      default: "Other",
    },
    iconURI: { type: String, trim: true },
  },
  { timestamps: true }
);

const Link = mongoose.model("Link", linkSchema);
export default Link;
