import { Router } from "express";
import LostAndFoundItem from "../../models/lost_and_found.js";
import fs from "fs/promises";
import uploader from "../../middlewares/multerConfig.js";
import * as messages from "../../constants/messages.js";
import { body, validationResult } from "express-validator";

const router = Router();

/**
 * @route GET /lost-and-found
 * @desc Retrieve all lost and found items
 */
router.get("/", async (req, res) => {
  try {
    const items = await LostAndFoundItem.find({}).lean();

    const itemsWithImages = await Promise.all(
      items.map(async (item) => {
        let imagePathBase64 = null;
        if (item.imagePath) {
          try {
            const bufferImage = await fs.readFile(item.imagePath);
            imagePathBase64 = bufferImage.toString("base64");
          } catch (err) {
            console.error("Error reading image file:", err);
          }
        }

        return {
          ...item,
          imagePath: imagePathBase64,
        };
      })
    );

    res.status(200).json({ status: true, data: itemsWithImages });
  } catch (error) {
    console.error("Error fetching items:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /lost-and-found
 * @desc Add a new lost and found item
 */
router.post(
  "/",
  uploader.single("image"),
  [
    body("name").notEmpty().withMessage("Item name is required"),
    body("lastSeenLocation")
      .notEmpty()
      .withMessage("Last seen location is required"),
    body("contactNumber").notEmpty().withMessage("Contact number is required"),
    body("listerId").notEmpty().withMessage("Lister ID is required"),
    body("isLost").isBoolean().withMessage("isLost must be a boolean"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const file = req.file;

      const newItem = new LostAndFoundItem({
        name: req.body.name,
        lastSeenLocation: req.body.lastSeenLocation,
        imagePath: file?.path || null,
        description: req.body.description || "",
        contactNumber: req.body.contactNumber,
        listerId: req.body.listerId,
        isLost: req.body.isLost,
      });

      await newItem.save();

      res
        .status(201)
        .json({ status: true, message: messages.itemAdded, data: newItem });
    } catch (error) {
      console.error("Error adding item:", error);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

export default router;
