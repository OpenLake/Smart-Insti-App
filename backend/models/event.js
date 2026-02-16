import mongoose from "mongoose";

const eventSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    description: { type: String, required: true, trim: true },
    date: { type: Date, required: true },
    location: { type: String, required: true, trim: true },
    imageURI: { type: String, trim: true },
    organizedBy: { type: String, required: true, trim: true },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: "User" }, // Can be Admin or Faculty
  },
  { timestamps: true }
);

const Event = mongoose.model("Event", eventSchema);
export default Event;
