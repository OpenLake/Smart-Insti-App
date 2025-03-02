import jwt from "jsonwebtoken";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

const secretKey = process.env.ACCESS_TOKEN_SECRET;

if (!secretKey) {
  console.error("❌ ACCESS_TOKEN_SECRET is not defined in .env file");
  process.exit(1); // Stop the server if the secret key is missing
}

/**
 * Middleware to verify JWT authentication token.
 */
const tokenRequired = async (req, res, next) => {
  try {
    const authHeader = req.headers["authorization"];

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Token is required" });
    }

    const token = authHeader.split(" ")[1]; // Extract the token after "Bearer"

    // Verify JWT token
    const decoded = jwt.verify(token, secretKey);

    // Attach the decoded payload to the request object
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};

export default tokenRequired;
