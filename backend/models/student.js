import mongoose from "mongoose";

const studentSchema = new mongoose.Schema(
  {
    name: { type: String, default: "Smart Insti User", trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      index: true,
    },
    rollNumber: { type: String, unique: true, sparse: true, trim: true }, // Allows null but ensures uniqueness
    about: { type: String, trim: true },
    profilePicURI: { type: String, trim: true },
    branch: { type: String, trim: true },
    graduationYear: { type: Number, min: 1900, max: 2100 }, // Ensures valid graduation year
    skills: [{ type: mongoose.Schema.Types.ObjectId, ref: "Skill" }],
    achievements: [
      { type: mongoose.Schema.Types.ObjectId, ref: "Achievement" },
    ],
    wishlist: [{ type: mongoose.Schema.Types.ObjectId, ref: "Listing" }],
    fcmTokens: [{ type: String }],
    roles: { type: [String], default: [] }, // Ensures array structure
    currentOrganization: { type: String, trim: true }, // For Alumni
    designation: { type: String, trim: true }, // For Alumni
    linkedInProfile: { type: String, trim: true }, // For Alumni
    settings: {
        privacy: {
            showEmail: { type: Boolean, default: true },
            showPhone: { type: Boolean, default: false }, // If phone added later
            showAchievements: { type: Boolean, default: true }
        },
        notifications: {
            email: { type: Boolean, default: true },
            push: { type: Boolean, default: true }
        }
    }
  },
  { timestamps: true } // Adds createdAt & updatedAt fields
);

studentSchema.index({ name: "text", branch: "text", rollNumber: "text" });

const Student = mongoose.model("Student", studentSchema);
export default Student;
