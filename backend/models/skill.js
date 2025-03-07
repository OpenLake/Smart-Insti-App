import mongoose from "mongoose";

const skillSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true, index: true }, // Indexed for faster searches
    level: { type: Number, required: true, min: 1, max: 10 }, // Restricts skill levels between 1-10
  },
  { timestamps: true } // Tracks when skills were added/updated
);

const Skill = mongoose.model("Skill", skillSchema);
export default Skill;
