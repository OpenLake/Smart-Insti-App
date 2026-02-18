import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../models/user.js";

dotenv.config();

const isAuthenticated = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Token is required" });
    }

    const token = authHeader.split(" ")[1];
    
    // Verify Access Token
    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

    // Attach user to request
    req.user = await User.findById(decoded.id);

    if (!req.user) {
      return res.status(401).json({ message: "User belonging to this token no longer exists." });
    }

    // Optional: Check if user changed password after token was issued (iat check)
    // Optional: Check onboarding status
    // if (!req.user.isVerified) ...

    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
       return res.status(401).json({ message: "Token expired" });
    }
    return res.status(401).json({ message: "Invalid token" });
  }
};

export default isAuthenticated;
