import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import testResource from "./resources/testResource.js";

import authResource from "./resources/authResource.js";
import otpResource from "./resources/otpResource.js";
import Connection from "./database/db.js";
import bodyParser from "body-parser";
import cors from "cors";
const PORT =`${process.env.PORT || 3000}`;
const app = express();

app.use(logger("dev"));
app.use(express.json())
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(cors());

// Get Database connection
Connection();

app.use(otpResource);
app.use("/", testResource);

export default app;
