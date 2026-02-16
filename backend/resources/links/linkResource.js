import express from "express";
import Link from "../../models/link.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const linkResource = express.Router();

linkResource.get("/", async (req, res) => {
  try {
    const links = await Link.find();
    res.status(200).json({ status: true, data: links });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

linkResource.post("/", tokenRequired, async (req, res) => {
  try {
    const newLink = new Link(req.body);
    await newLink.save();
    res.status(201).json({ status: true, data: newLink });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

linkResource.delete("/:id", tokenRequired, async (req, res) => {
    try {
        await Link.findByIdAndDelete(req.params.id);
        res.status(200).json({ status: true, message: "Link deleted" });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

export default linkResource;
