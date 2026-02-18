import express from "express";
import mongoose from "mongoose";
import Conversation from "../../models/conversation.js";
import PrivateMessage from "../../models/privateMessage.js";
import User from "../../models/user.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import { getIO } from "../../socket.js";
import * as messages from "../../constants/messages.js";

const chatRouter = express.Router();

chatRouter.use(isAuthenticated);

// Get all conversations for current user
chatRouter.get("/conversations", async (req, res) => {
  try {
    const userId = req.user._id;
    const conversations = await Conversation.find({ participants: userId })
      .populate("participants", "name email profilePicURI")
      .populate("lastMessage")
      .sort({ updatedAt: -1 });

    res.status(200).json({ status: true, data: conversations });
  } catch (err) {
    console.error("Error fetching conversations:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Start or Get DM with a specific user
chatRouter.post("/conversations/:targetUserId", async (req, res) => {
  try {
    const { targetUserId } = req.params;
    const currentUserId = req.user._id;

    if (targetUserId === currentUserId.toString()) {
       return res.status(400).json({ status: false, message: "Cannot chat with self" });
    }

    // Check if conversation exists
    let conversation = await Conversation.findOne({
      participants: { $all: [currentUserId, targetUserId] }
    }).populate("participants", "name email profilePicURI");

    if (!conversation) {
      conversation = await Conversation.create({
        participants: [currentUserId, targetUserId]
      });
      conversation = await conversation.populate("participants", "name email profilePicURI");
    }

    res.status(200).json({ status: true, data: conversation });
  } catch (err) {
    console.error("Error creating conversation:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Get Messages for a Conversation
chatRouter.get("/conversations/:conversationId/messages", async (req, res) => {
  try {
    const { conversationId } = req.params;
    
    // pagination could be added here
    const messagesList = await PrivateMessage.find({ conversation: conversationId })
      .sort({ createdAt: 1 })
      .populate("sender", "name email profilePicURI");

    res.status(200).json({ status: true, data: messagesList });
  } catch (err) {
    console.error("Error fetching messages:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Send Message
chatRouter.post("/conversations/:conversationId/messages", async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { content, messageType, imageUrl } = req.body;
    const senderId = req.user._id;

    const conversation = await Conversation.findById(conversationId);
    if (!conversation) {
      return res.status(404).json({ status: false, message: "Conversation not found" });
    }
    
    // Verify participant
    const isParticipant = conversation.participants.some(p => p.toString() === senderId.toString());
    if (!isParticipant) {
      return res.status(403).json({ status: false, message: "Not a participant" });
    }

    const newMessage = await PrivateMessage.create({
      conversation: conversationId,
      sender: senderId,
      content,
      messageType: messageType || 'text',
      imageUrl
    });

    // Update conversation last message
    conversation.lastMessage = newMessage._id;
    await conversation.save();

    // Socket.io emission
    const io = getIO();
    // Emit to other participants
    conversation.participants.forEach(participantId => {
      if (participantId.toString() !== senderId.toString()) {
        io.to(participantId.toString()).emit("new_message", {
          message: newMessage,
          conversationId
        });
        
        // Also emit a notification event?
        // io.to(participantId.toString()).emit("notification", { ... });
      }
    });

    res.status(201).json({ status: true, data: newMessage });
  } catch (err) {
    console.error("Error sending message:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

// Mark Read
chatRouter.patch("/conversations/:conversationId/read", async (req, res) => {
  try {
     const { conversationId } = req.params;
     const userId = req.user._id;

     await PrivateMessage.updateMany(
       { conversation: conversationId, sender: { $ne: userId }, isRead: false },
       { isRead: true, readAt: new Date() }
     );

     res.status(200).json({ status: true, message: "Marked as read" });
  } catch (err) {
    console.error("Error marking read:", err);
    res.status(500).json({ status: false, message: messages.internalServerError });
  }
});

export default chatRouter;
