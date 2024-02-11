import { Router } from "express";
import Room from "../../models/room.js";
const router = Router();

// PUT method
router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { occupantId } = req.body;
    const room = await Room.findById(id);
    if (!room) {
      return res.status(404).json({ error: "Room not found" });
    }

    room.vacant = false;
    room.occupantId = occupantId || room.occupantId;

    await room.save();

    console.log("Room updated successfully");
    res.json({ message: "Room updated successfully", room });
  } catch (error) {
    console.error("Error updating room:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
