import express from "express";
import cookieParser from "cookie-parser";
import logger from "morgan";
import testResource from "./resources/testResource.js";
import generalAuthResource from "./resources/auth/generalAuthResource.js";
import adminAuthResource from "./resources/auth/adminAuthResource.js";
import otpResource from "./resources/auth/otpResource.js";
import studentResource from "./resources/student/studentResource.js";
import skillResource from "./resources/student/skillResource.js";
import achievementResource from "./resources/student/achievementResource.js";
import facultyResource from "./resources/faculty/facultyResource.js";
import Connection from "./database/db.js";
import cors from "cors";
import tokenRequired from "./middlewares/tokenRequired.js";
import adminResource from "./resources/admin/adminResource.js";
import roomListResource from "./resources/rooms/roomListResource.js";
import roomResource from "./resources/rooms/roomResource.js";
import lostAndFoundListResource from "./resources/lostAndFound/lostAndFoundListResource.js";
import studentListResource from "./resources/student/studentListResource.js";
import facultyListResource from "./resources/faculty/facultyListResource.js";
import messageResource from "./resources/chatroom/messageListResource.js";
import lostAndFoundResource from "./resources/lostAndFound/lostAndFoundResource.js";
import timetableListResource from "./resources/timetable/timetableListResource.js";
import timetableResource from "./resources/timetable/timetableResource.js";
import messMenuListResource from "./resources/messMenu/messMenuListResource.js";
import messMenuResource from "./resources/messMenu/messMenuResource.js";
import courseResource from "./resources/faculty/courseResource.js";
import eventResource from "./resources/events/eventResource.js";
import complaintResource from "./resources/complaints/complaintResource.js";
import linkResource from "./resources/links/linkResource.js";
import newsResource from "./resources/news/newsResource.js";
import chatResource from "./resources/chat/chatResource.js";
import listingResource from "./resources/marketplace/listingResource.js";
import orderResource from "./resources/marketplace/orderResource.js";
import announcementResource from "./resources/announcement/announcementResource.js";
import pollResource from "./resources/polls/pollResource.js";
import resourceResource from "./resources/study_material/resourceResource.js";
import clubResource from "./resources/clubs/clubResource.js";
import attendanceResource from "./resources/attendance/attendanceResource.js";
import confessionResource from "./resources/confessions/confessionResource.js";
import notificationResource from "./resources/notifications/notificationResource.js";
import alumniResource from "./resources/alumni/alumniResource.js";
import busRouteResource from "./resources/transport/busRouteResource.js";
import leaderboardResource from "./resources/gamification/leaderboardResource.js";
import analyticsResource from "./resources/admin/analyticsResource.js";
import searchResource from "./resources/search/searchResource.js";
import "./models/student.js";
import "./models/skill.js";
import "./models/achievement.js";
import "./models/event.js";
import "./models/complaint.js";
import "./models/link.js";
import "./models/post.js";
import "./models/attendance.js";
import "./models/poll.js";

const PORT = `${process.env.PORT || 3000}`;
const app = express();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(cors());

// Get Database connection
Connection();
app.use("/admin", adminResource);
app.use("/student", studentResource);
app.use("/students", studentListResource);
app.use("/faculty", facultyResource);
app.use("/faculties", facultyListResource);
app.use("/timetable", timetableResource);
app.use("/timetables", timetableListResource);
app.use("/mess-menu", messMenuResource);
app.use("/mess-menus", messMenuListResource);

app.use("/admin-auth", adminAuthResource);
app.use("/general-auth", generalAuthResource);
app.use("/otp", otpResource);
app.use("/", testResource);
app.use("/rooms", roomListResource);
app.use("/room", roomResource);
app.use("/lost-and-found", lostAndFoundListResource);
app.use("/lost-and-found-item", lostAndFoundResource);
app.use("/messages", messageResource);
app.use("/course", courseResource);
app.use("/student", skillResource);
app.use("/student", achievementResource);
app.use("/events", eventResource);
app.use("/complaints", complaintResource);
app.use("/links", linkResource);
app.use("/news", newsResource);
app.use("/chat", chatResource);
app.use("/marketplace/listings", listingResource);
app.use("/marketplace/orders", orderResource);
app.use("/announcements", announcementResource);
app.use("/polls", pollResource);
app.use("/resources", resourceResource);
app.use("/clubs", clubResource);
app.use("/attendance", attendanceResource);
app.use("/confessions", confessionResource);
app.use("/notifications", notificationResource);
app.use("/alumni", alumniResource);
app.use("/transport", busRouteResource);
app.use("/leaderboard", leaderboardResource);
app.use("/analytics", analyticsResource);
app.use("/search", searchResource);







app.get("/protected", tokenRequired, (req, res) => {
  res.json({ message: "Access granted" });
});
export default app;
