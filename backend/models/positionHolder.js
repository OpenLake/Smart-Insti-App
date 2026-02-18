import mongoose from "mongoose";

const positionHolderSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  orgUnit: { type: mongoose.Schema.Types.ObjectId, ref: 'OrganizationalUnit', required: true },
  role: { type: String, required: true }, // e.g. "President", "Secretary", "Member"
  isCore: { type: Boolean, default: false }, // For highlighting core members
  isAdmin: { type: Boolean, default: false }, // Can manage club page
  session: { type: String, required: true, default: "2025-2026" },
  active: { type: Boolean, default: true }
}, { timestamps: true });

// Ensure one active role per user per unit per session? Maybe not strictly necessary but good practice.
// positionHolderSchema.index({ user: 1, orgUnit: 1, session: 1 }, { unique: true });

const PositionHolder = mongoose.model("PositionHolder", positionHolderSchema);
export default PositionHolder;
