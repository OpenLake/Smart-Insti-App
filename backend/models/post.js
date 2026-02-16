import mongoose from "mongoose";

const postSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    content: { type: String, required: true, trim: true },
    author: { type: String, required: true, trim: true }, // Name of the person/body posting
    type: {
      type: String,
      enum: ["News", "Announcement", "Achievement"],
      default: "News",
    },
    imageURI: { type: String, trim: true },
    likes: [{ type: mongoose.Schema.Types.ObjectId }], // Generic user IDs
  },
  { timestamps: true }
);

const Post = mongoose.model("Post", postSchema);
export default Post;
