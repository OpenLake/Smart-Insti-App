import express from "express";
import { supabase } from "../../utils/supabase.js";
import * as messages from "../../constants/messages.js";

const messMenuListRouter = express.Router();

/**
 * @route GET /mess-menus
 * @desc Retrieve all mess menus (aggregated from Supabase SQL)
 */
messMenuListRouter.get("/", async (req, res) => {
  try {
    // Sort order for days to ensure consistency
    const daysOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

    const { data: menuRows, error } = await supabase
      .from('mess_menu')
      .select('*');

    if (error) throw error;

    // Aggregate into the format expected by the frontend
    // We group by kitchen (currently only "Veg Mess") and week parity
    const kitchens = {};

    menuRows.forEach(row => {
      const kitchenKey = `Veg Mess (Week ${row.week_parity})`;
      if (!kitchens[kitchenKey]) {
        kitchens[kitchenKey] = {
          _id: `supabase-veg-w${row.week_parity}`,
          kitchenName: kitchenKey,
          messMenu: {}
        };
      }

      if (!kitchens[kitchenKey].messMenu[row.day_of_week]) {
        kitchens[kitchenKey].messMenu[row.day_of_week] = {};
      }

      // The frontend MessMenu model expects Map<String, List<String>> for each day
      // Our menu_items is a JSON object { "Category": "Items" }
      // We convert it to a flat list of strings for now as per legacy model
      const itemsList = Object.values(row.menu_items);
      kitchens[kitchenKey].messMenu[row.day_of_week][row.meal_type] = itemsList;
    });

    res.status(200).json({ 
      status: true, 
      data: Object.values(kitchens) 
    });
  } catch (error) {
    console.error("Error fetching mess menu from Supabase:", error);
    res
      .status(500)
      .json({ status: false, message: messages.internalServerError });
  }
});

// POST/PUT/DELETE routes are disabled for now as we transitioned to Supabase SQL.
// These will be implemented when the admin panel is ready to handle SQL-based menu management.

export default messMenuListRouter;
