import { Router } from "express";
import Room from "../../models/room.js";
import * as messages from "../../constants/messages.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const router = Router();

/**
 * @route GET /rooms
 * @desc Retrieve all rooms
 */
//working
router.get("/", async (req, res) => {
  try {
    const rooms = await Room.find({});
    res
      .status(200)
      .json({ status: true, message: messages.success, data: rooms });
  } catch (error) {
    console.error("Error fetching rooms:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /rooms
 * @desc Create a new room
 */
//working
router.post("/", tokenRequired, async (req, res) => {
  try {
    const {
      name,
      vacant = true,
      occupantId = null,
      occupantName = null,
    } = req.body;

    const newRoom = new Room({ name, vacant, occupantId, occupantName });
    await newRoom.save();

    res
      .status(201)
      .json({ status: true, message: messages.roomCreated, data: newRoom });
  } catch (error) {
    console.error("Error creating room:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default router;
