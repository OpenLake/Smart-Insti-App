import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import testResource from "./resources/testResource.js";
import userResource from "./resources/userResource.js";
import authResource from "./resources/authResource.js";
import otpResource from "./resources/otpResource.js";
import studentResource from "./resources/studentResouce.js";
import facultyResource from "./resources/facultyResource.js";
import skillResource from "./resources/skillResource.js";
import achievementResource from "./resources/achievementResource.js";
import courseResource from "./resources/courseResource.js";
import Connection from "./database/db.js";
import cors from "cors";
import auth from "./middlewares/auth.js";
import achievementRouter from "./resources/achievementResource.js";
const PORT =`${process.env.PORT || 3000}`;
const app = express();

app.use(logger("dev"));
app.use(express.json())
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(cors());

// Get Database connection
Connection();
app.use(authResource);
app.use(userResource);
app.use(otpResource);
app.use(studentResource);
app.use(facultyResource);
app.use(skillResource);
app.use(courseResource);
app.use(achievementResource);
app.use("/", testResource);

app.get('/protected', auth, (req, res) => {
  res.json({ message: 'Access granted' });
});
export default app;
