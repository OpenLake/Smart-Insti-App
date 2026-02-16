import { Router } from "express";
import Room from "../../models/room.js";
import * as messages from "../../constants/messages.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const router = Router();

/**
 * @route PUT /rooms/:id
 * @desc Update room details (assign/release occupant)
 */
//working
router.put("/:id", tokenRequired, async (req, res) => {
  try {
    const { id } = req.params;
    const { occupantName, occupantId, vacant } = req.body;

    const updatedRoom = await Room.findByIdAndUpdate(
      id,
      vacant
        ? { vacant: true, occupantId: null, occupantName: null }
        : { vacant: false, occupantId, occupantName },
      { new: true }
    );

    if (!updatedRoom) {
      return res
        .status(404)
        .json({ status: false, message: messages.roomNotFound });
    }

    res
      .status(200)
      .json({ status: true, message: messages.roomUpdated, data: updatedRoom });
  } catch (error) {
    console.error("Error updating room:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default router;
