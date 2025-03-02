import { Router } from "express";
import mongoose from "mongoose";
import Message from "../../models/message.js";
import * as messages from "../../constants/messages.js";
import { body, param, validationResult } from "express-validator";

const messageListRouter = Router();

/**
 * @route GET /messages
 * @desc Fetch all messages
 */
//working
messageListRouter.get("/", async (req, res) => {
  try {
    const allMessages = await Message.find({}).lean();
    res.status(200).json({ status: true, data: allMessages });
  } catch (err) {
    console.error("Error fetching messages:", err);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /messages
 * @desc Create a new message
 */
//working
messageListRouter.post(
  "/",
  [
    body("sender").notEmpty().withMessage("Sender is required"),
    body("content").notEmpty().withMessage("Content is required"),
  ],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const { sender, content, timestamp } = req.body;
      const newMessage = await Message.create({
        sender,
        content,
        timestamp: timestamp || new Date(),
      });

      res
        .status(201)
        .json({ status: true, message: "Message created", data: newMessage });
    } catch (err) {
      console.error("Error saving message:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

/**
 * @route DELETE /messages/:id
 * @desc Delete a message by ID
 */
//working
messageListRouter.delete(
  "/:id",
  [param("id").isMongoId().withMessage("Invalid message ID")],
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ status: false, errors: errors.array() });
    }

    try {
      const id = req.params.id;
      const deletedMessage = await Message.findByIdAndDelete(id);
      if (!deletedMessage) {
        return res
          .status(404)
          .json({ status: false, message: messages.notFound });
      }

      res.status(200).json({
        status: true,
        message: "Message deleted successfully",
        data: deletedMessage,
      });
    } catch (err) {
      console.error("Error deleting message:", err);
      res
        .status(500)
        .json({ status: false, message: messages.internalServerError });
    }
  }
);

export default messageListRouter;
