import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import testResource from "./resources/testResource.js";
import authResource from "./resources/generalAuthResource.js";
import otpResource from "./resources/otpResource.js";
import Connection from "./database/db.js";
import cors from "cors";
import tokenRequired from "./middlewares/tokenRequired.js";
const PORT = `${process.env.PORT || 3000}`;
const app = express();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(cors());

// Get Database connection
Connection();
app.use(authResource);
app.use(otpResource);
app.use("/", testResource);

app.get("/protected", tokenRequired, (req, res) => {
  res.json({ message: "Access granted" });
});
export default app;
