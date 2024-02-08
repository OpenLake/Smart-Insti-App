import { Router } from "express";
import LostAndFoundItem from "../../models/lost_and_found.js";
import fs from "fs/promises";
import multer from "multer";

const router = Router();

// Define storage configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});

const upload = multer({ storage: storage });

// GET method to retrieve all items
router.get("/", async (req, res) => {
  try {
    // Query the database to retrieve all items
    const items = await LostAndFoundItem.find({});

    // Create an empty array to store items with images
    const itemsWithImages = [];

    // Iterate through each item
    for (const item of items) {
      // Check if imagePath is null
      let imagePathBase64 = null;
      if (item.imagePath) {
        // Read the image file if imagePath is not null
        const bufferImage = await fs.readFile(item.imagePath);
        imagePathBase64 = bufferImage.toString("base64");
      }

      // Create a new object with the required attributes
      const itemWithImage = {
        _id: item._id,
        name: item.name,
        lastSeenLocation: item.lastSeenLocation,
        imagePath: imagePathBase64, // Set imagePath to null if null in the database
        description: item.description,
        contactNumber: item.contactNumber,
        isLost: item.isLost,
      };

      // Push the item with image to the array
      itemsWithImages.push(itemWithImage);
    }

    console.log("Retrieved items:", itemsWithImages.length);

    // Send the response with the items
    res.json(itemsWithImages);
  } catch (error) {
    // Handle errors
    console.error("Error:", error);
    res.status(500).send("Error retrieving items");
  }
});

// POST method
router.post("/", upload.single("image"), async (req, res) => {
  // Access the uploaded file using req.file
  const file = req.file;

  // Construct the LostAndFoundItem object with data from the request
  const newItem = new LostAndFoundItem({
    name: req.body.name,
    lastSeenLocation: req.body.lastSeenLocation,
    imagePath: file ? file.path : null,
    description: req.body.description,
    contactNumber: req.body.contactNumber,
    isLost: req.body.isLost,
  });

  // Save the new item to the database
  await newItem.save();

  res.send("Added new item");
});

export default router;
