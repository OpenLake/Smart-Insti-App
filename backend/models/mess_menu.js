import mongoose from "mongoose";

const messMenuSchema = new mongoose.Schema(
  {
    kitchenName: { type: String, required: true, trim: true, index: true },
    messMenu: {
      type: Map,
      of: {
        type: Map,
        of: [String],
      },
      required: true,
      validate: {
        validator: (menu) => menu.size > 0,
        message: "Mess menu cannot be empty",
      },
    },
  },
  { timestamps: true } // Adds createdAt & updatedAt fields
);

const MessMenu = mongoose.model("MessMenu", messMenuSchema);
export default MessMenu;
