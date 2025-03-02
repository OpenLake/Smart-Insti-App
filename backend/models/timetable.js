import mongoose from "mongoose";

const timetableSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    rows: { type: Number, required: true, min: 1 }, // Ensures at least one row
    columns: { type: Number, required: true, min: 1 }, // Ensures at least one column
    creatorId: { type: String, required: true, index: true }, // Indexed for faster queries
    timeRanges: [
      {
        start: {
          hour: { type: Number, required: true, min: 0, max: 23 },
          minute: { type: Number, required: true, min: 0, max: 59 },
        },
        end: {
          hour: { type: Number, required: true, min: 0, max: 23 },
          minute: { type: Number, required: true, min: 0, max: 59 },
        },
      },
    ],
    timetable: [
      {
        timeSlot: { type: String, required: true }, // Example: "09:00 - 10:00"
        subject: { type: String, required: true }, // Example: "Mathematics"
        location: { type: String, default: "" }, // Example: "Room 101"
      },
    ],
  },
  { timestamps: true } // Adds createdAt & updatedAt fields
);

const Timetable = mongoose.model("Timetable", timetableSchema);
export default Timetable;
