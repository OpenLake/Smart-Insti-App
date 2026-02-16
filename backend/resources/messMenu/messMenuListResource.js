import express from "express";
import * as messages from "../../constants/messages.js";
import MessMenu from "../../models/mess_menu.js";
import tokenRequired from "../../middlewares/tokenRequired.js";

const messMenuListRouter = express.Router();

/**
 * @route GET /mess-menu
 * @desc Retrieve all mess menus
 */
//working
messMenuListRouter.get("/", async (req, res) => {
  try {
    const messMenuData = await MessMenu.find();
    res.status(200).json({ status: true, data: messMenuData });
  } catch (error) {
    console.error("Error fetching mess menu:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route POST /mess-menu
 * @desc Add a new mess menu
 */
//working
messMenuListRouter.post("/", tokenRequired, async (req, res) => {
  try {
    const { kitchenName, messMenu } = req.body;

    if (!kitchenName || !messMenu) {
      return res
        .status(400)
        .json({ status: false, message: messages.invalidData });
    }

    const newMessMenu = new MessMenu({ kitchenName, messMenu });
    await newMessMenu.save();

    res.status(201).json({
      status: true,
      message: messages.messMenuAdded,
      data: newMessMenu,
    });
  } catch (error) {
    console.error("Error adding mess menu:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default messMenuListRouter;
