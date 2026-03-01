import dotenv from "dotenv";

dotenv.config();

/**
 * Middleware to verify the X-Hub-Secret header for internal requests.
 */
const hubAuth = (req, res, next) => {
  const hubSecret = req.header("X-Hub-Secret");
  const internalSecret = process.env.HUB_INTERNAL_SECRET;

  if (!internalSecret) {
    console.error("❌ HUB_INTERNAL_SECRET is not defined in the environment.");
    return res.status(500).json({
      status: "error",
      message: "Internal server configuration error",
    });
  }

  if (!hubSecret || hubSecret !== internalSecret) {
    return res.status(401).json({
      status: "error",
      message: "Unauthorized: Invalid or missing X-Hub-Secret",
    });
  }

  next();
};

export default hubAuth;
