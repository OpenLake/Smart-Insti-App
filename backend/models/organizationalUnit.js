import mongoose from "mongoose";

const organizationalUnitSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true, unique: true },
  description: { type: String, trim: true },
  type: { 
    type: String, 
    enum: ['Club', 'Society', 'Department', 'Hostel', 'Student Body'], 
    default: 'Club' 
  },
  domain: { 
      type: String, 
      enum: ['Technical', 'Cultural', 'Sports', 'Academic', 'Welfare', 'Other'],
      default: 'Other'
  },
  logo: { type: String }, // URL
  banner: { type: String }, // URL
  socialLinks: {
    instagram: { type: String },
    linkedin: { type: String },
    website: { type: String },
    discord: { type: String }
  },
  email: { type: String, trim: true, lowercase: true }
}, { timestamps: true });

const OrganizationalUnit = mongoose.model("OrganizationalUnit", organizationalUnitSchema);
export default OrganizationalUnit;
