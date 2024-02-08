import { Router } from "express";
import Room from "../../models/room.js";
import Student from "../../models/student.js";
const router = Router();

//GET method
router.get("/", async (req, res) => {
  try {
    const documentIds = req.body.documentIds; // Assuming the documentIds are sent in the request body

    const occupants = await Promise.all(
      documentIds.map(async (documentId) => {
        const room = await Room.findOne({ documentId });
        const occupant = await Student.findOne({ _id: room.occupantId });
        return {
          occupantName: occupant.name,
          roomId: room._id,
        };
      })
    );

    res.json(occupants);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error" });
  }
});
