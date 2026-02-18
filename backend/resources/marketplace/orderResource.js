import express from "express";
import Order from "../../models/order.js";
import Listing from "../../models/listing.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import * as messages from "../../constants/messages.js";

const orderRouter = express.Router();

orderRouter.use(isAuthenticated);

// Create Order (Buy Request)
orderRouter.post("/", async (req, res) => {
  try {
    const { listingId } = req.body;
    const buyer = req.user._id;

    const listing = await Listing.findById(listingId);
    if (!listing) return res.status(404).json({ status: false, message: "Listing not found" });

    if (listing.status !== 'Active') {
      return res.status(400).json({ status: false, message: "Listing is not available" });
    }

    if (listing.seller.toString() === buyer.toString()) {
      return res.status(400).json({ status: false, message: "Cannot buy your own listing" });
    }

    const order = await Order.create({
      buyer,
      seller: listing.seller,
      listing: listingId,
      status: 'Pending'
    });

    res.status(201).json({ status: true, data: order });
  } catch (err) {
    console.error("Error creating order:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get My Orders (As Buyer)
orderRouter.get("/buying", async (req, res) => {
  try {
    const orders = await Order.find({ buyer: req.user._id })
      .populate('listing')
      .populate('seller', 'name email')
      .sort({ createdAt: -1 });

    res.status(200).json({ status: true, data: orders });
  } catch (err) {
    console.error("Error fetching buying orders:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get Orders for My Listings (As Seller)
orderRouter.get("/selling", async (req, res) => {
  try {
    const orders = await Order.find({ seller: req.user._id })
      .populate('listing')
      .populate('buyer', 'name email profilePicURI')
      .sort({ createdAt: -1 });

    res.status(200).json({ status: true, data: orders });
  } catch (err) {
    console.error("Error fetching selling orders:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Update Order Status
orderRouter.patch("/:id/status", async (req, res) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id).populate('listing');
    
    if (!order) return res.status(404).json({ status: false, message: "Order not found" });

    const isSeller = order.seller.toString() === req.user._id.toString();
    const isBuyer = order.buyer.toString() === req.user._id.toString();

    if (!isSeller && !isBuyer) {
      return res.status(403).json({ status: false, message: "Unauthorized" });
    }

    // State transitions logic
    if (status === 'Accepted' && isSeller) {
      order.status = 'Accepted';
      await order.save();
    } else if (status === 'Completed' && isBuyer) { // Buyer confirms receipt
      order.status = 'Completed';
      await order.save();
      
      // Update listing status
      const listing = await Listing.findById(order.listing._id);
      listing.status = 'Sold';
      await listing.save();

    } else if (status === 'Cancelled') {
      order.status = 'Cancelled';
      await order.save();
    } else {
      return res.status(400).json({ status: false, message: "Invalid status transition" });
    }

    res.status(200).json({ status: true, data: order });
  } catch (err) {
    console.error("Error updating order:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

export default orderRouter;
