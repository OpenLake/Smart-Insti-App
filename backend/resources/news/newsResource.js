import express from "express";
import Post from "../../models/post.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const newsResource = express.Router();

newsResource.get("/", async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });
    res.status(200).json({ status: true, data: posts });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

newsResource.post("/", tokenRequired, async (req, res) => {
  try {
    const newPost = new Post(req.body);
    await newPost.save();
    res.status(201).json({ status: true, data: newPost });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
});

newsResource.put("/:id/like", tokenRequired, async (req, res) => {
    try {
        const post = await Post.findById(req.params.id);
        if(!post) return res.status(404).json({ status: false, message: "Post not found" });

        if(post.likes.includes(req.user._id)){
            post.likes.pull(req.user._id);
        } else {
            post.likes.push(req.user._id);
        }
        await post.save();
        res.status(200).json({ status: true, data: post });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message });
    }
});

export default newsResource;
