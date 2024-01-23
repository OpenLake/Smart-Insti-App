import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import testResource from "./resources/testResource.js";

import authResource from "./resources/authResource.js";
import otpResource from "./resources/otpResource.js";
import Connection from "./database/db.js";
import bodyParser from "body-parser";

const app = express();

app.use(logger("dev"));
app.use(express.json())
app.use(bodyParser.json());;
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Get Database connection
Connection();

app.use(authResource);
app.use("/signin",otpResource);
app.use("/", testResource);

export default app;
