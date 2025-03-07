import express from "express";
import * as messages from "../../constants/messages.js";
import MessMenu from "../../models/mess_menu.js";

const messMenuRouter = express.Router();

/**
 * @route PUT /mess-menu/:id
 * @desc Update an existing mess menu
 */
//working
messMenuRouter.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { messMenu } = req.body;

    if (!messMenu) {
      return res
        .status(400)
        .json({ status: false, message: messages.invalidData });
    }

    const updatedMenu = await MessMenu.findByIdAndUpdate(
      id,
      { messMenu },
      { new: true }
    );

    if (!updatedMenu) {
      return res
        .status(404)
        .json({ status: false, message: messages.messMenuNotFound });
    }

    res.status(200).json({
      status: true,
      message: messages.messMenuUpdated,
      data: updatedMenu,
    });
  } catch (error) {
    console.error("Error updating mess menu:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

/**
 * @route DELETE /mess-menu/:id
 * @desc Delete a mess menu by ID
 */
//working
messMenuRouter.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const deletedMenu = await MessMenu.findByIdAndDelete(id);

    if (!deletedMenu) {
      return res
        .status(404)
        .json({ status: false, message: messages.messMenuNotFound });
    }

    res.status(200).json({
      status: true,
      message: "Mess menu successfully deleted",
      data: deletedMenu,
    }); // 204 No Content (successful deletion)
  } catch (error) {
    console.error("Error deleting mess menu:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

export default messMenuRouter;
