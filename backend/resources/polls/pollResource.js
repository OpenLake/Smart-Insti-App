
import express from "express";
import mongoose from "mongoose";
import isAuthenticated from "../../middlewares/isAuthenticated.js";
import Poll from "../../models/poll.js";

const pollRouter = express.Router();

// Create a Poll
pollRouter.post("/create", isAuthenticated, async (req, res) => {
  try {
    const { question, options, expiryHours, target } = req.body;
    const userId = req.user._id;
    const userRole = req.user.role || "Student"; // Assuming role is attached to req.user

    if (!question || !options || options.length < 2) {
        return res.status(400).json({ status: false, message: "Question and at least 2 options required" });
    }

    const expiryDate = new Date();
    expiryDate.setHours(expiryDate.getHours() + (expiryHours || 24));

    const poll = new Poll({
        question,
        options: options.map(opt => ({ text: opt, votes: 0 })),
        createdBy: userId,
        creatorRole: userRole,
        expiry: expiryDate,
        target: target || "All"
    });

    await poll.save();

    res.status(201).json({ status: true, message: "Poll created successfully", data: poll });

  } catch (err) {
    console.error("Error creating poll:", err);
    res.status(500).json({ status: false, message: "Internal server error" });
  }
});

// Get Active Polls
pollRouter.get("/active", isAuthenticated, async (req, res) => {
    try {
        const userId = req.user._id;

        // Find active polls that haven't expired
        // Optional: Filter by target if needed
        const polls = await Poll.find({ 
            isActive: true, 
            expiry: { $gt: new Date() } 
        })
        .sort({ createdAt: -1 })
        .populate("createdBy", "name"); // Populate creator name

        // Add 'hasVoted' flag for the current user
        const pollsWithStatus = polls.map(poll => {
            const pollObj = poll.toObject();
            pollObj.hasVoted = poll.votedBy.includes(userId);
            // Calculate total votes
            pollObj.totalVotes = poll.options.reduce((acc, curr) => acc + curr.votes, 0);
            return pollObj;
        });

        res.status(200).json({ status: true, data: pollsWithStatus });

    } catch (err) {
        console.error("Error getting polls:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

// Vote on a Poll
pollRouter.post("/:id/vote", isAuthenticated, async (req, res) => {
    try {
        const pollId = req.params.id;
        const { optionIndex } = req.body; // Index of the option selected
        const userId = req.user._id;

        const poll = await Poll.findById(pollId);
        if (!poll) return res.status(404).json({ status: false, message: "Poll not found" });

        if (poll.expiry < new Date()) {
            return res.status(400).json({ status: false, message: "Poll has expired" });
        }

        if (poll.votedBy.includes(userId)) {
            return res.status(400).json({ status: false, message: "You have already voted" });
        }

        if (optionIndex < 0 || optionIndex >= poll.options.length) {
            return res.status(400).json({ status: false, message: "Invalid option" });
        }

        // Increment vote and add user to votedBy
        poll.options[optionIndex].votes += 1;
        poll.votedBy.push(userId);

        await poll.save();

        res.status(200).json({ status: true, message: "Vote recorded successfully" });

    } catch (err) {
        console.error("Error voting:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

// Delete a Poll
pollRouter.delete("/:id", isAuthenticated, async (req, res) => {
    try {
        const pollId = req.params.id;
        const userId = req.user._id;

        const poll = await Poll.findById(pollId);
        if (!poll) return res.status(404).json({ status: false, message: "Poll not found" });

        // Check ownership
        if (poll.createdBy.toString() !== userId.toString()) {
            return res.status(403).json({ status: false, message: "Unauthorized" });
        }

        await Poll.findByIdAndDelete(pollId);
        res.status(200).json({ status: true, message: "Poll deleted successfully" });

    } catch (err) {
        console.error("Error deleting poll:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default pollRouter;
