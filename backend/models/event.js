import mongoose from "mongoose";

const eventSchema = new mongoose.Schema({
  title: { type: String, required: true, trim: true },
  description: { type: String, trim: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },
  location: { type: String, trim: true },
  type: { 
    type: String, 
    enum: ['Academic', 'Holiday', 'Exam', 'Club', 'Sports', 'Other'], 
    default: 'Academic' 
  },
  organizer: { type: mongoose.Schema.Types.ObjectId, ref: 'OrganizationalUnit' }, // Optional link to a club
  createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  isPublic: { type: Boolean, default: true }
}, { timestamps: true });

eventSchema.index({ title: "text", description: "text", location: "text" });

const Event = mongoose.model("Event", eventSchema);
export default Event;
