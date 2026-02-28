import { createClient } from "@supabase/supabase-js";
import dotenv from "dotenv";
import User from "../models/user.js";

dotenv.config();

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

/**
 * Middleware to verify Supabase authentication token.
 */
const tokenRequired = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Token is required" });
    }

    const token = authHeader.split(" ")[1];

    // Verify with Supabase
    const { data: { user }, error } = await supabase.auth.getUser(token);

    if (error || !user) {
      return res.status(401).json({ message: "Invalid or expired token" });
    }

    // Identify the user and link Supabase ID if not already linked
    let localUser = await User.findOne({ 
      $or: [
        { supabaseId: user.id },
        { email: user.email }
      ]
    });

    if (localUser && !localUser.supabaseId) {
        localUser.supabaseId = user.id;
        await localUser.save();
    }

    if (!localUser) {
        // Create a basic User record to start with
        localUser = await User.create({
            name: user.user_metadata?.name || 'Smart Insti User',
            email: user.email,
            supabaseId: user.id,
            roles: [user.user_metadata?.role || 'student'],
            profilePicURI: user.user_metadata?.avatar_url || ''
        });
    }

    // Attach the local user to the request object
    req.user = localUser;
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};

export default tokenRequired;
