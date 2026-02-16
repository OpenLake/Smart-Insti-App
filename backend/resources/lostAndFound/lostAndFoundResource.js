import express from "express";
import * as messages from "../../constants/messages.js";
import LostAndFoundItem from "../../models/lost_and_found.js";
import fs from "fs/promises";
import tokenRequired from "../../middlewares/tokenRequired.js";

const lostAndFoundRouter = express.Router();

/**
 * @route DELETE /lost-and-found/:id
 * @desc Delete a lost and found item by ID
 */
lostAndFoundRouter.delete("/:id", tokenRequired, async (req, res) => {
  const itemId = req.params.id;

  try {
    const item = await LostAndFoundItem.findByIdAndDelete(itemId);

    if (!item) {
      return res
        .status(404)
        .json({ status: false, message: messages.itemNotFound });
    }

    // Delete the image file if it exists
    if (item.imagePath) {
      try {
        await fs.unlink(item.imagePath);
      } catch (err) {
        console.error("Error deleting image file:", err);
      }
    }

    res.status(200).json({ status: true, message: messages.itemDeleted });
  } catch (err) {
    console.error("Error deleting item:", err);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default lostAndFoundRouter;
