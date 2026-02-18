import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  // Core Identity
  name: { type: String, required: true, trim: true },
  email: { 
    type: String, 
    required: true, 
    unique: true, 
    trim: true, 
    lowercase: true,
    match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, 'Please fill a valid email address']
  },
  username: { type: String, unique: true, sparse: true, trim: true, lowercase: true },
  password: { type: String, select: false }, // For those using password auth (Admin/Marketplace)
  
  // Profile
  profilePicURI: { type: String, default: '' },
  about: { type: String, trim: true, default: '' },
  
  // Roles & Permissions
  roles: { 
    type: [String], 
    enum: ['student', 'faculty', 'admin', 'alumni', 'vendor_admin', 'club_admin', 'moderator'],
    default: ['student'] 
  },
  
  // Academic Info (Student/Faculty specific)
  academicInfo: {
    studentId: { type: String, trim: true }, // rollNumber
    department: { type: String, trim: true }, // branch
    year: { type: Number }, // current year 1-4
    batch: { type: Number }, // graduationYear
    program: { type: String, trim: true }, // e.g., B.Tech, M.Tech
    cgpa: { type: Number }
  },
  
  // Hostel Info
  hostelLocation: {
    hostel: { type: String, enum: ['Kanhar', 'Gopad', 'Indravati', 'Shivnath', 'Mahanadi', 'Other'], default: 'Other' },
    room: { type: String, trim: true },
    notes: { type: String }
  },
  
  // Contact Info
  contactInfo: {
    phone: { type: String, trim: true },
    whatsapp: { type: String, trim: true }
  },
  
  // Security & Auth
  isVerified: { type: Boolean, default: false },
  verificationToken: { type: String, select: false },
  resetPasswordToken: { type: String, select: false },
  resetPasswordExpires: { type: Date, select: false },
  refreshTokens: [{
    token: { type: String, required: true },
    expiresAt: { type: Date, required: true },
    createdAt: { type: Date, default: Date.now }
  }],
  loginAttempts: { type: Number, required: true, default: 0 },
  lockUntil: { type: Number },
  lastLogin: { type: Date },
  
  // Marketplace & Gamification
  trustScore: { type: Number, default: 100, min: 0, max: 100 },
  rating: {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 }
  },
  
  // Preferences
  preferences: {
    notifications: {
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true }
    },
    privacy: {
      showPhone: { type: Boolean, default: false },
      showEmail: { type: Boolean, default: true }
    }
  },

  // Legacy/Compatibility Fields (to ease migration from Student model)
  skills: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Skill' }],
  achievements: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Achievement' }]

}, { 
  timestamps: true,
  toJSON: {
    transform: function(doc, ret) {
      delete ret.password;
      delete ret.refreshTokens;
      delete ret.verificationToken;
      delete ret.resetPasswordToken;
      return ret;
    }
  }
});

// Indexes for performance
userSchema.index({ email: 1 });
userSchema.index({ username: 1 });
userSchema.index({ 'academicInfo.studentId': 1 });

const User = mongoose.model('User', userSchema);
export default User;
