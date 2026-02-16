import mongoose from "mongoose";
import bcryptjs from "bcryptjs";

const adminSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true },
    email: {
      type: String,
      required: true,
      unique: true, // Prevents duplicate admin accounts
      trim: true,
      lowercase: true,
      validate: {
        validator: (value) => /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(value), // Improved email regex
        message: "Please enter a valid email address",
      },
    },
    password: { type: String, required: true, minlength: 6 },
  },
  { timestamps: true } // Adds createdAt & updatedAt automatically
);

/**
 * Hash password before saving
 */
adminSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  try {
    this.password = await bcryptjs.hash(this.password, 10); // Hash password with salt rounds = 10
    next();
  } catch (error) {
    next(error);
  }
});

const Admin = mongoose.model("Admin", adminSchema);
export default Admin;
