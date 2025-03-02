import mongoose from "mongoose";
import dotenv from "dotenv";

// Load environment variables
dotenv.config();

/**
 * Establishes a connection to MongoDB with proper error handling.
 */
const Connection = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      serverSelectionTimeoutMS: 5000, // Timeout after 5s instead of endless retries
    });

    console.log("✅ Database connected successfully");
  } catch (error) {
    console.error("❌ Error connecting to the database:", error.message);
    process.exit(1); // Exit process if DB connection fails
  }
};

// Handle database disconnection events
mongoose.connection.on("disconnected", () => {
  console.warn("⚠️ Database disconnected");
});

// Gracefully close MongoDB connection when app exits
process.on("SIGINT", async () => {
  await mongoose.connection.close();
  console.log("🔌 MongoDB connection closed due to app termination");
  process.exit(0);
});

export default Connection;
