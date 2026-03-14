import express from "express";
import * as messages from "../../constants/messages.js";
import MessMenu from "../../models/mess_menu.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const messMenuRouter = express.Router();

/**
 * @route PUT /mess-menu/:id
 * @desc Update an existing mess menu
 */
//working
// Resource logic disabled during transition to Supabase SQL.
// Endpoint: PUT /mess-menu/:id
// Endpoint: DELETE /mess-menu/:id

messMenuRouter.put("/:id", (req, res) => {
  res.status(501).json({ status: false, message: "Use the admin panel for mess menu updates." });
});

messMenuRouter.delete("/:id", (req, res) => {
  res.status(501).json({ status: false, message: "Use the admin panel for mess menu deletions." });
});

export default messMenuRouter;
