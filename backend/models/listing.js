import mongoose from "mongoose";

const listingSchema = new mongoose.Schema({
  seller: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true, trim: true },
  description: { type: String, required: true },
  price: { type: Number, required: true, min: 0 },
  category: { type: String, enum: ['Books', 'Electronics', 'Furniture', 'Clothing', 'Stationery', 'Other'], default: 'Other' },
  condition: { type: String, enum: ['New', 'Like New', 'Good', 'Fair', 'Poor'], default: 'Good' },
  images: [{ type: String }], // Cloudinary URLs
  status: { type: String, enum: ['Active', 'Sold', 'Inactive'], default: 'Active' },
  views: { type: Number, default: 0 },
  likes: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
}, { timestamps: true });

listingSchema.index({ title: 'text', description: 'text' }); // Search index

const Listing = mongoose.model("Listing", listingSchema);
export default Listing;
