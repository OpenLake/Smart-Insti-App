import { Server } from "socket.io";
import jwt from "jsonwebtoken";
import User from "./models/user.js";

let io;

export const initSocket = (server) => {
  io = new Server(server, {
    cors: {
      origin: "*", 
      methods: ["GET", "POST"]
    }
  });

  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth.token || socket.handshake.headers.token;
      if (!token) return next(new Error("Authentication error"));
      
      const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
      // Minimal user fetch, or just trust token id? 
      // Fetching ensures user still exists / not banned.
      const user = await User.findById(decoded.id).select("_id name email roles"); 
      if (!user) return next(new Error("User not found"));

      socket.user = user;
      next();
    } catch (e) {
      next(new Error("Authentication error"));
    }
  });

  io.on("connection", (socket) => {
    console.log("Socket connected:", socket.user?.name);
    
    // Join personal room for DMs/Notifications
    socket.join(socket.user._id.toString());

    socket.on("disconnect", () => {
      console.log("Socket disconnected:", socket.user?.name);
    });
  });
  
  return io;
};

export const getIO = () => {
  if (!io) {
    throw new Error("Socket.io not initialized!");
  }
  return io;
};
