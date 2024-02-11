import jwt from "jsonwebtoken";
import * as errorMessages from "../constants/errorMessages.js";
const secretKey = process.env.ACCESS_TOKEN_SECRET;

const auth = async (req, res, next) => {
  try {
    const bearerHeader = req.headers["authorization"];
    if (typeof bearerHeader !== "undefined") {
      const bearer = bearerHeader.split(" ");
      const bearerToken = bearer[1];
      // Verify the token
      jwt.verify(bearerToken, secretKey, (err, user) => {
        if (err) {
          res.sendStatus(403);
        } else {
          req.user = user;
          next();
        }
      });
    }
  } catch (error) {
    res.status(500).json({ error: err.message });
  }
};

export default auth;
