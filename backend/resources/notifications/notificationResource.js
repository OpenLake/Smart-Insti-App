
import express from 'express';
import { messaging } from '../../firebase.js'; // Ensure path is correct
import isAuthenticated from '../../middlewares/isAuthenticated.js';
import mongoose from 'mongoose';
import Listing from '../../models/listing.js'; // Example for triggering notifications

const notificationRouter = express.Router();
const Student = mongoose.model("Student");

// Register FCM Token
notificationRouter.post('/register-token', isAuthenticated, async (req, res) => {
  try {
    const { fcmToken } = req.body;
    const userId = req.user._id;

    if (!fcmToken) {
      return res.status(400).json({ status: false, message: "FCM Token required" });
    }

    const student = await Student.findById(userId);
    if (!student) {
        return res.status(404).json({ status: false, message: "User not found" });
    }

    // Add token if not exists
    if (!student.fcmTokens.includes(fcmToken)) {
      student.fcmTokens.push(fcmToken);
      await student.save();
    }

    res.status(200).json({ status: true, message: "Token registered successfully" });

  } catch (error) {
    console.error("Error registering FCM token:", error);
    res.status(500).json({ status: false, message: "Internal Server Error" });
  }
});

// Remove FCM Token (Logout)
notificationRouter.post('/remove-token', isAuthenticated, async (req, res) => {
    try {
      const { fcmToken } = req.body;
      const userId = req.user._id;
  
      if (!fcmToken) {
        return res.status(400).json({ status: false, message: "FCM Token required" });
      }
  
      const student = await Student.findById(userId);
      if (student) {
        student.fcmTokens = student.fcmTokens.filter(t => t !== fcmToken);
        await student.save();
      }
  
      res.status(200).json({ status: true, message: "Token removed successfully" });
  
    } catch (error) {
      console.error("Error removing FCM token:", error);
      res.status(500).json({ status: false, message: "Internal Server Error" });
    }
  });

// Test Notification Endpoint (Admin or Dev only ideally)
notificationRouter.post('/test-send', isAuthenticated, async (req, res) => {
    try {
        const userId = req.user._id;
        const student = await Student.findById(userId);
        
        if (!student || !student.fcmTokens || student.fcmTokens.length === 0) {
            return res.status(400).json({ status: false, message: "No tokens found for user" });
        }

        const message = {
            notification: {
                title: 'Test Notification',
                body: 'This is a test notification from Smart Insti App!'
            },
            data: {
                type: 'test',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            tokens: student.fcmTokens
        };

        const response = await messaging.sendEachForMulticast(message);
        console.log('Successfully sent message:', response);
        
        // Clean up invalid tokens
        if (response.failureCount > 0) {
             const failedTokens = [];
             response.responses.forEach((resp, idx) => {
                 if (!resp.success) {
                     failedTokens.push(student.fcmTokens[idx]);
                 }
             });
             if (failedTokens.length > 0) {
                 student.fcmTokens = student.fcmTokens.filter(t => !failedTokens.includes(t));
                 await student.save();
             }
        }

        res.status(200).json({ status: true, message: "Notification sent", response });

    } catch (error) {
        console.error("Error sending notification:", error);
        res.status(500).json({ status: false, message: "Internal Server Error", error: error.message });
    }
});

export default notificationRouter;
