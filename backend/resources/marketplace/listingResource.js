import express from "express";
import mongoose from "mongoose";
import Listing from "../../models/listing.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { upload } from "../../utils/cloudinary.js";
import * as messages from "../../constants/messages.js";

const listingRouter = express.Router();

listingRouter.use(isAuthenticated);

// Create Listing
listingRouter.post("/", upload.array('images', 5), async (req, res) => {
  try {
    const { title, description, price, category, condition } = req.body;
    const images = req.files ? req.files.map(file => file.path) : [];
    const seller = req.user._id;

    if (!title || !price) {
      return res.status(400).json({ status: false, message: "Title and Price are required" });
    }

    const listing = await Listing.create({
      seller,
      title,
      description,
      price,
      category,
      condition,
      images,
      status: 'Active'
    });

    res.status(201).json({ status: true, data: listing });
  } catch (err) {
    console.error("Error creating listing:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get All Listings (with filters)
listingRouter.get("/", async (req, res) => {
  try {
    const { category, search, minPrice, maxPrice } = req.query;
    let query = { status: 'Active' };

    if (category) query.category = category;
    if (search) {
      query.$text = { $search: search };
    }
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }

    const listings = await Listing.find(query)
      .populate('seller', 'name email profilePicURI')
      .sort({ createdAt: -1 });

    res.status(200).json({ status: true, data: listings });
  } catch (err) {
    console.error("Error fetching listings:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get My Listings
listingRouter.get("/my", async (req, res) => {
  try {
    const listings = await Listing.find({ seller: req.user._id })
      .sort({ createdAt: -1 });

    res.status(200).json({ status: true, data: listings });
  } catch (err) {
    console.error("Error fetching my listings:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get Single Listing
listingRouter.get("/:id", async (req, res) => {
  try {
    const listing = await Listing.findById(req.params.id)
      .populate('seller', 'name email profilePicURI academicInfo');

    if (!listing) {
      return res.status(404).json({ status: false, message: "Listing not found" });
    }

    // Increment views
    listing.views += 1;
    await listing.save();

    res.status(200).json({ status: true, data: listing });
  } catch (err) {
    console.error("Error fetching listing:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Delete/Close Listing
listingRouter.delete("/:id", async (req, res) => {
  try {
    const listing = await Listing.findById(req.params.id);
    if (!listing) return res.status(404).json({ status: false, message: "Listing not found" });

    if (listing.seller.toString() !== req.user._id.toString()) {
       return res.status(403).json({ status: false, message: "Unauthorized" });
    }

    await Listing.findByIdAndDelete(req.params.id);
    res.status(200).json({ status: true, message: "Listing deleted" });
  } catch (err) {
    console.error("Error deleting listing:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Toggle Wishlist
listingRouter.put("/:id/wishlist", async (req, res) => {
  try {
    const listingId = req.params.id;
    const userId = req.user._id;

    // Find student (user)
    // Assuming 'Student' model is what we use for users primarily or we need to import it.
    // However, req.user is usually populated from the auth middleware. 
    // But we need to update the document.
    
    // We need to import Student model if not already imported, or use req.user if it's a mongoose doc.
    // usually req.user is a plain object or mongoose doc depending on middleware.
    // Let's assume we need to import Student.
    
    // Wait, I should check if Student is imported. It is NOT in listingResource.js.
    // I'll add the import in a separate block or just use dynamic import? 
    // Standard way: import at top. I'll use a separate replace for import.
    
    // For now, let's write the logic assuming Student is available or import it here if possible (ESM allow dynamic, but better top level).
    // I will add the route here and then add the import at the top.
    
    /* 
       Actually, `req.user` might be the student document itself if `isAuthenticated` populates it.
       Let's check `isAuthenticated.js`.
       If not, I need Student model.
    */
   
    // Let's assume I need to fetch it to be safe.
    
    // But wait, I can't easily add import at top with this replace block at bottom.
    // I will use `mongoose.model('Student')` to avoid circular dependency issues or just import it.
    // Let's use mongoose.model 'Student' is defined in app.js imports usually.
    
    const Student = mongoose.model("Student");
    const student = await Student.findById(userId);
    
    if (!student) return res.status(404).json({ status: false, message: "User not found" });

    const index = student.wishlist.indexOf(listingId);
    if (index === -1) {
        student.wishlist.push(listingId);
    } else {
        student.wishlist.splice(index, 1);
    }

    await student.save();

    res.status(200).json({ 
        status: true, 
        message: index === -1 ? "Added to wishlist" : "Removed from wishlist",
        data: { isWishlisted: index === -1 } 
    });

  } catch (err) {
    console.error("Error toggling wishlist:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

export default listingRouter;
