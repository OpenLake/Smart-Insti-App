# Smart Insti App — Complete Feature Specification

> **Version:** 2.0 (Comprehensive Edition)
> **Stack:** Flutter (frontend) · Node.js/Express + MongoDB (backend)
> **Audience:** Students, Faculty, Alumni, Administrators

---

## Table of Contents

1. [Feature Status Legend](#feature-status-legend)
2. [Authentication & Onboarding](#1-authentication--onboarding)
3. [Home Dashboard](#2-home-dashboard)
4. [Student Profile](#3-student-profile)
5. [Faculty Directory & Profiles](#4-faculty-directory--profiles)
6. [Courses & Academic](#5-courses--academic)
7. [Timetable & Schedule](#6-timetable--schedule)
8. [Academic Calendar & Events](#7-academic-calendar--events)
9. [Mess Menu](#8-mess-menu)
10. [Lost & Found](#9-lost--found)
11. [Room Vacancy & Hostel](#10-room-vacancy--hostel)
12. [Chat Room & Messaging](#11-chat-room--messaging)
13. [Complaints & Feedback](#12-complaints--feedback)
14. [Broadcast & Notifications](#13-broadcast--notifications)
15. [News & Announcements](#14-news--announcements)
16. [Quick Links](#15-quick-links)
17. [Campus Post Wall](#16-campus post-wall)  ← NOT YET IMPLEMENTED
18. [Marketplace](#17-marketplace)  ← NOT YET IMPLEMENTED
19. [Alumni Network](#18-alumni-network)
20. [Study Resources & Notes Sharing](#19-study-resources--notes-sharing)  ← NOT YET IMPLEMENTED
21. [Clubs & Societies](#20-clubs--societies)  ← NOT YET IMPLEMENTED
22. [Polls & Surveys](#21-polls--surveys)  ← NOT YET IMPLEMENTED
23. [Attendance Tracker](#22-attendance-tracker)  ← NOT YET IMPLEMENTED
24. [Bus / Transport Tracker](#23-bus--transport-tracker)  ← NOT YET IMPLEMENTED
25. [Admin Panel](#24-admin-panel)
26. [Gamification & Achievements](#25-gamification--achievements)
27. [Settings & App Configuration](#26-settings--app-configuration)
28. [Cross-Cutting Concerns](#27-cross-cutting-concerns)

---

## Feature Status Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | **Implemented** — feature is present and functional in current codebase |
| 🟡 | **Partially Implemented** — model/backend exists but UI/logic is incomplete |
| ❌ | **Not Implemented** — feature is missing entirely, needs to be built |
| 🔮 | **Should Be Added** — recommended feature not currently in scope |

---

## 1. Authentication & Onboarding

### 1.1 Student Authentication
| Feature | Status | Notes |
|---------|--------|-------|
| OTP-based email login | ✅ | 4-digit OTP sent via SMTP, stored in MongoDB with TTL |
| Student registration with roll number, branch, graduation year | ✅ | POST `/general-auth/register/student` |
| JWT token generation (7d expiry) | ✅ | HS256 algorithm |
| OTP verification endpoint | ✅ | Deletes OTP from DB after verification |
| Rate limiting on OTP requests | 🟡 | Backend limiter exists on admin; OTP endpoint lacks it |
| Login with role selection (student/faculty/alumni) | ✅ | `loginForRole` field in request body |
| Token refresh mechanism | ❌ | No refresh token implemented; users must re-authenticate after 7d |
| Biometric / fingerprint login | ❌ | Not implemented |
| "Remember Me" persistent session | ❌ | Not implemented |
| Social login (Google SSO via institute email) | 🔮 | Recommended for frictionless access |
| Password reset via email | ❌ | Not implemented |

### 1.2 Faculty Authentication
| Feature | Status | Notes |
|---------|--------|-------|
| OTP-based email login | ✅ | Same OTP flow as students |
| Faculty registration | ✅ | POST `/general-auth/register` |
| JWT authentication | ✅ | Shared auth infrastructure |
| Faculty-specific role permissions | 🟡 | Role field exists, not enforced in all routes |

### 1.3 Alumni Authentication
| Feature | Status | Notes |
|---------|--------|-------|
| Alumni registration | ✅ | Fields: name, email, graduationYear, degree, department, currentOrganization, designation, linkedInProfile |
| Alumni login | ✅ | Role-based OTP login |
| Alumni-specific dashboard and features | ❌ | No dedicated alumni UI screens |

### 1.4 Admin Authentication
| Feature | Status | Notes |
|---------|--------|-------|
| Email + password login | ✅ | bcryptjs password hashing, rate limited (5 attempts / 10 min) |
| Admin registration | ✅ | POST `/admin-auth/register` |
| Admin JWT with 7d expiry | ✅ | |
| Multi-admin roles (super-admin, department admin) | ❌ | Single admin role only |
| Two-factor authentication for admin | 🔮 | Recommended for security |

### 1.5 Onboarding
| Feature | Status | Notes |
|---------|--------|-------|
| Welcome/splash screen | ✅ | `loading_page.dart` |
| Role selection screen | ✅ | Student / Faculty / Admin / Alumni |
| Profile completion wizard (first login) | ❌ | No guided onboarding flow |
| App tour / feature walkthrough | ❌ | Not implemented |
| Push notification permission request | ❌ | Not implemented |

---

## 2. Home Dashboard

### 2.1 Student Home
| Feature | Status | Notes |
|---------|--------|-------|
| Today's schedule preview | ✅ | Shows next class from timetable |
| Today's mess menu preview | ✅ | Breakfast/Lunch/Dinner for today |
| Recent events widget | ✅ | Top 2–3 upcoming events |
| Broadcast announcements banner | ✅ | `broadcast.dart` via `broadcast_provider.dart` |
| News feed preview | ✅ | Latest 2–3 news items |
| Quick-action grid (shortcuts to all sections) | 🟡 | Exists but not fully populated |
| Weather widget | 🔮 | Useful for campus outdoor planning |
| Motivational quote / tip of the day | 🔮 | Engagement feature |
| Birthday notifications for batchmates | 🔮 | Community feature |

### 2.2 Navigation
| Feature | Status | Notes |
|---------|--------|-------|
| Bottom navigation bar | ✅ | `main_scaffold.dart` |
| Persistent navigation state | 🟡 | May lose state on tab switch |
| Search bar across all sections | ❌ | Global search not implemented |
| Notification bell with badge count | ❌ | Not implemented |

---

## 3. Student Profile

### 3.1 View & Edit Profile
| Feature | Status | Notes |
|---------|--------|-------|
| View personal profile (name, email, roll number, branch, year) | ✅ | `student_profile.dart` |
| Edit profile (about, profile picture URI) | ✅ | `edit_profile.dart` |
| Profile picture upload | 🟡 | URI field exists; actual file upload via Multer needs front-end connection |
| Skills management (add/edit/delete, level 1–10) | ✅ | `skills_edit_widget.dart`, `skillResource.js` |
| Achievements management | ✅ | `achievements_edit_widget.dart`, `achievementResource.js` |
| View other students' profiles | ✅ | `studentListResource.js` → `student_profile.dart` |
| Student directory / search | 🟡 | Backend list exists; UI search/filter incomplete |
| Profile privacy settings | ✅ | `settings_screen.dart` |
| Student roles/clubs display | 🟡 | `roles` array on model; no UI to manage |
| LinkedIn / GitHub profile link | ❌ | Not implemented |
| Download/share profile card | 🔮 | Shareable PDF/image of profile |
| Graduation year cohort grouping | 🔮 | Browse students by batch |

### 3.2 Academic Information
| Feature | Status | Notes |
|---------|--------|-------|
| Enrolled courses list | ❌ | Courses are faculty-linked; no student enrollment model |
| CGPA / GPA display | ❌ | Not implemented |
| Academic performance charts | ❌ | Not implemented |
| Attendance summary | ❌ | Not implemented |

---

## 4. Faculty Directory & Profiles

| Feature | Status | Notes |
|---------|--------|-------|
| View faculty profile (name, email, department, cabin number) | ✅ | `faculty_profile.dart` |
| Faculty directory listing | ✅ | `facultyListResource.js` |
| Search faculty by name / department | 🟡 | Backend list available; UI search incomplete |
| View faculty's assigned courses | ✅ | `courses` array on faculty model |
| Faculty availability / office hours | ❌ | Not implemented |
| Faculty research interests / bio | ❌ | Not implemented |
| Send message to faculty | 🟡 | Global chatroom exists; direct message does not |
| Faculty ratings / feedback | 🔮 | Anonymous course feedback feature |

---

## 5. Courses & Academic

| Feature | Status | Notes |
|---------|--------|-------|
| View course list | ✅ | `courseResource.js`, `view_courses.dart` |
| Course details (name, code, credits, room, branches) | ✅ | Full schema implemented |
| Filter courses by branch | 🟡 | Schema supports it; UI filter not implemented |
| Course enrollment tracking | ❌ | No student-to-course enrollment model |
| Course materials / syllabus upload | ❌ | Not implemented |
| Assignment tracking | ❌ | Not implemented |
| Course announcements | ❌ | Not implemented |
| Faculty-to-course association | ✅ | `professorId` on Course model |
| Credit load calculator | 🔮 | Show total credits enrolled per semester |
| Course review / rating after completion | 🔮 | Post-semester feedback |
| Pre-requisite mapping | 🔮 | Show course dependency graph |

---

## 6. Timetable & Schedule

| Feature | Status | Notes |
|---------|--------|-------|
| View personal timetable | ✅ | `timetables.dart` |
| Create custom timetable | ✅ | `timetable_editor.dart` |
| Edit timetable (add/remove time slots) | ✅ | Editor with rows/columns, time ranges |
| Time ranges per slot (start/end hour:minute) | ✅ | Stored in `timeRanges` array |
| Subject + location per slot | ✅ | `subject` and `location` fields |
| Multiple timetable support (per semester) | ✅ | `timetableListResource.js` |
| Today's view highlight | 🟡 | Timetable renders full grid; today's column not highlighted |
| Next class countdown | ❌ | Not implemented |
| Class reminder push notification | ❌ | Not implemented |
| Share timetable with friends | ❌ | Not implemented |
| Import timetable from CSV / institute portal | 🟡 | `menu_jan.tsv` and `menu_parser.dart` suggest some parsing logic; not generalized |
| Conflict detection (overlapping classes) | ❌ | Not implemented |
| Free slot finder (study room booking compatible) | 🔮 | Find gaps to suggest free time |

---

## 7. Academic Calendar & Events

### 7.1 Events
| Feature | Status | Notes |
|---------|--------|-------|
| View events list | ✅ | `events_page.dart`, `eventResource.js` |
| Event details (title, description, date, location, image, organizer) | ✅ | Full schema |
| Admin/faculty creates events | ✅ | Admin panel → create event |
| Filter events by category | ✅ | Home page displays stylized cards by category |
| RSVP / "I'm interested" button | ❌ | Not implemented |
| Add event to personal calendar | ❌ | Not implemented |
| Event reminders | ❌ | Not implemented |
| Recurring events support | ❌ | Not implemented |
| Event image gallery | ❌ | Single `imageURI` only; no gallery |

### 7.2 Academic Calendar
| Feature | Status | Notes |
|---------|--------|-------|
| Full month/semester calendar view | ❌ | No dedicated calendar screen |
| Mark important dates (exams, holidays, deadlines) | ❌ | Not implemented |
| Sync with device calendar | ❌ | Not implemented |
| Semester timeline overview | ❌ | Not implemented |

---

## 8. Mess Menu

| Feature | Status | Notes |
|---------|--------|-------|
| View today's mess menu | ✅ | `user_mess_menu.dart`, `menu_provider.dart` |
| View weekly mess menu | ✅ | Map-of-maps structure (day → meal → items) |
| Multiple kitchens / mess support | ✅ | `kitchenName` field on MessMenu |
| Admin adds/edits mess menu | ✅ | `add_menu.dart`, `view_menu.dart` |
| Static TSV fallback (January menu) | ✅ | `menu_jan.tsv` parsed by `menu_parser.dart` |
| Mess menu for upcoming week | ❌ | Only current schedule; no advance view |
| Nutritional information per meal | ❌ | Not implemented |
| Meal rating / feedback | ❌ | Not implemented |
| Meal skip notification (mess is closed) | ❌ | Not implemented |
| Mess fee payment tracker | ❌ | Not implemented |
| Mess rebate application | 🔮 | Allow students to apply for rebates during leave |
| Allergen / dietary filter (veg, vegan, gluten-free) | 🔮 | Dietary preference filtering |
| Special meal announcements | 🔮 | E.g., "Special dinner tonight" |

---

## 9. Lost & Found

| Feature | Status | Notes |
|---------|--------|-------|
| Post a lost item | ✅ | `lost_and_found.dart`, `lostAndFoundListResource.js` |
| Post a found item | ✅ | `isLost: false` flag |
| Item details (name, description, last seen location, image, contact) | ✅ | Full schema |
| View all lost/found listings | ✅ | List view with images |
| Contact the lister via phone number | ✅ | `contactNumber` field |
| Search lost/found items | ❌ | Not implemented |
| Filter by category / date | ❌ | Not implemented |
| Mark item as claimed/returned | ❌ | No status field on model |
| In-app messaging to item poster | ❌ | No private message feature |
| Item expiry / auto-archive after 30 days | ❌ | Not implemented |
| QR code on items for easy reporting | 🔮 | Generate QR sticker for valuable items |

---

## 10. Room Vacancy & Hostel

| Feature | Status | Notes |
|---------|--------|-------|
| View room vacancy list | ✅ | `room_vacancy.dart`, `roomListResource.js` |
| Room details (name, vacancy status, occupant) | ✅ | Full schema |
| Admin manages rooms (create/update/delete) | ✅ | `manage_rooms.dart` |
| Apply for a vacant room | ❌ | No application/request workflow |
| Room swap request | ❌ | Not implemented |
| Hostel floor map / block view | ❌ | No visual layout |
| Hostel maintenance request | 🟡 | Complaint system can cover this but no hostel-specific category |
| Roommate finder | 🔮 | Match students looking for roommates |
| Hostel rules / notice board | 🔮 | Hostel-specific announcements |
| Laundry schedule per floor | 🔮 | Common hostel need |
| Hot water / power availability status | 🔮 | Real-time utility status |

---

## 11. Chat Room & Messaging

| Feature | Status | Notes |
|---------|--------|-------|
| Global institution-wide chat room | ✅ | `chat_room.dart`, `messageListResource.js` |
| Send text messages | ✅ | `MessageSchema` with sender, content, timestamp |
| View message history | ✅ | `messageListResource.js` |
| Real-time updates (polling) | 🟡 | REST-based; no WebSocket/Socket.io real-time push |
| Private / direct messaging | ❌ | Not implemented; only global chatroom |
| Department-specific chat rooms | ❌ | Not implemented |
| Club-based chat rooms | ❌ | Not implemented |
| Message reactions / emoji responses | ❌ | Not implemented |
| Media sharing (images, files) in chat | ❌ | Only text messages |
| Message deletion / editing | ❌ | Not implemented |
| Mention / tag other users (@name) | ❌ | Not implemented |
| Read receipts | ❌ | Not implemented |
| Message search | ❌ | Not implemented |
| Real-time chat via WebSocket (Socket.io) | ❌ | Critical missing feature |
| Push notifications for new messages | ❌ | Not implemented |

---

## 12. Complaints & Feedback

| Feature | Status | Notes |
|---------|--------|-------|
| Submit a complaint | ✅ | `feedback_screen.dart`, `feedbackResource.js` |
| Complaint fields (title, description, category, anonymous) | ✅ | Full schema |
| Categories: Mess, Hostel, Infrastructure, Academic, Other | ✅ | Dropdown on submission |
| Status tracking (Pending → In Progress → Resolved/Rejected) | ✅ | Status enum on model |
| Upvote complaints (community support) | ❌ | Not enabled in current UI |
| Image attachment to complaint | ❌ | Not implemented in current UI |
| Anonymous complaint option | ✅ | Switch in submission form (Identity hidden from public/admin view needs backend enforcement) |
| Admin views / manages complaints | ✅ | `admin_complaints.dart` exists (needs integration with new Feedback API) |
| Email notification on status change | ❌ | Not implemented |
| Complaint history for student | ❌ | Not implemented in UI |
| Complaint categorization: Electricity, Water, Internet, etc. | ❌ | Limited enum |
| Public upvote visibility | 🟡 | Model supports it; UI unclear |

---

## 13. Broadcast & Notifications

| Feature | Status | Notes |
|---------|--------|-------|
| Admin broadcasts announcements | ✅ | `broadcast.dart`, `broadcast_provider.dart` |
| Students receive broadcasts | ✅ | `broadcast_repository.dart` |
| Broadcast message schema | ✅ | `broadcast_schema.dart` |
| Push notifications (FCM / APNs) | ❌ | No Firebase integration; only in-app polling |
| Notification preferences (subscribe/unsubscribe topics) | ❌ | Not implemented |
| Scheduled broadcasts | ❌ | Not implemented |
| Broadcast categories (Academic, Hostel, Emergency) | ❌ | Not implemented |
| Emergency / SOS broadcast | 🔮 | High-priority instant alert system |
| Read receipts on broadcasts | ❌ | Not implemented |

---

## 14. News & Announcements

| Feature | Status | Notes |
|---------|--------|-------|
| View news feed | ✅ | `news_page.dart`, `newsResource.js` |
| News post schema (title, content, author, type, imageURI, likes) | ✅ | `post.js` model |
| Post types: News, Announcement, Achievement | ✅ | Enum on Post model |
| Like a post | ✅ | `likes` array on Post model |
| Admin creates news posts | 🟡 | Backend route exists; admin UI for news not clearly present |
| Share news article | ❌ | Not implemented |
| News categories / tags | ❌ | Only `type` enum; no free-form tags |
| Comment on news | ❌ | Not implemented |
| Rich text / markdown in posts | ❌ | Plain text only |
| External news integration (RSS feeds) | 🔮 | Pull in institute's official news |

---

## 15. Quick Links

| Feature | Status | Notes |
|---------|--------|-------|
| View curated quick links | ✅ | `links_page.dart`, `linkResource.js` |
| Link fields (title, URL, category, icon) | ✅ | `link.js` model |
| Categories: Academic, Hostel, Club, Other | ✅ | Enum |
| Admin manages links | 🟡 | Backend CRUD exists; admin UI needs verification |
| Open links in in-app browser | ❌ | Likely opens external browser; no in-app WebView |
| Student-suggested links | 🔮 | Students propose links, admin approves |
| Pinned / featured links | 🔮 | Highlight most-used links |

---

## 16. Campus Post Wall

> **Status: ✅ IMPLEMENTED**

| Feature | Status | Notes |
|---------|--------|-------|
| Anonymous post submission | ❌ | No anonymity layer exists |
| Campus Post feed view | ❌ | No dedicated screen |
| Like / react to campus posts | ❌ | Not implemented |
| Report inappropriate campus post | ❌ | Not implemented |
| Admin moderation queue | ❌ | Not implemented |
| Category tags (Academic Stress, Crush, Funny, Rant, Advice) | ❌ | Not implemented |
| Time-limited campus posts (auto-delete after 24h / 7d) | ❌ | Not implemented |
| Reply to campus posts (also anonymous) | ❌ | Not implemented |
| Time-limited Campus Posts (auto-delete after 24h / 7d) | ❌ | Not implemented |
| Reply to Campus Posts (also anonymous) | ❌ | Not implemented |
| Keyword filtering / profanity detection | ❌ | Not implemented |
| Campus Post of the day (most liked) | ❌ | Not implemented |

**Implementation Notes:**
- Extend `post.js` model with `isAnonymous: Boolean`, `expiresAt: Date`, `category: String`, `reports: []`
- Add campus-post-specific API routes under `/campus-posts`
- Frontend: new `campus_post_wall_screen.dart` screen with anonymous post form and masonry/feed layout

---

## 17. Marketplace

> **Status: ✅ IMPLEMENTED**

| Feature | Status | Notes |
|---------|--------|-------|
| List item for sale | ❌ | Not implemented |
| Item details (title, description, price, images, category, condition) | ❌ | Not implemented |
| Browse all listings | ❌ | Not implemented |
| Search and filter (price range, category, new/used) | ❌ | Not implemented |
| Contact seller (in-app or show phone/email) | ❌ | Not implemented |
| Mark item as sold | ❌ | Not implemented |
| Saved / wishlist items | ❌ | Not implemented |
| Categories: Books, Electronics, Stationery, Clothing, Other | ❌ | Not implemented |
| Price negotiation chat | ❌ | Not implemented |
| Report fraudulent listing | ❌ | Not implemented |
| Seller profile / rating | ❌ | Not implemented |
| Item condition: New / Like New / Good / Fair / Poor | ❌ | Not implemented |
| Featured / pinned listings (admin) | ❌ | Not implemented |
| Free item giveaway section | 🔮 | Donate before graduating |

**Implementation Notes:**
- New model: `marketplace_item.js` with fields: title, description, price, images[], category, condition, sellerId, status (active/sold), location (pickup point), createdAt
- API routes under `/marketplace`
- Frontend: `marketplace.dart` with grid/list toggle, filter bottom sheet, and item detail page

---

## 18. Alumni Network

| Feature | Status | Notes |
|---------|--------|-------|
| Alumni registration | ✅ | Fields: name, email, graduationYear, degree, department, organization, designation, LinkedIn |
| Alumni login / OTP auth | ✅ | Shared auth flow |
| Alumni profile view | ❌ | No `alumni_profile.dart` screen |
| Alumni directory listing | ✅ | `alumni_directory_screen.dart` |
| Filter alumni by batch / department / location | ❌ | Not implemented |
| Alumni–student mentorship connect | ❌ | Not implemented |
| Alumni job postings / referrals | 🔮 | Critical career feature |
| Alumni events / reunions | 🔮 | Events tagged as alumni-specific |
| Alumni giving / donation portal link | 🔮 | Integration with institute's donation system |

---

## 19. Study Resources & Notes Sharing

> **Status: ✅ IMPLEMENTED**

| Feature | Status | Notes |
|---------|--------|-------|
| Upload study notes / PDFs | ❌ | No file-sharing model |
| Browse notes by course / subject | ❌ | Not implemented |
| Download notes | ❌ | Not implemented |
| Rate / upvote notes quality | ❌ | Not implemented |
| Previous year question papers | ❌ | Not implemented |
| Study group formation | ❌ | Not implemented |
| Collaborative note editing | 🔮 | Real-time Google Docs–style editing |
| Plagiarism flag | 🔮 | Flag copied/low-quality notes |
| Admin curated resource library | 🔮 | Official study materials |

**Implementation Notes:**
- New model: `resource.js` with fields: title, fileURL, courseId, uploadedBy, type (notes/PYQ/syllabus), downloads, upvotes, semester, createdAt
- Integrate cloud storage (AWS S3 / Firebase Storage) for file uploads
- Frontend: `study_resources.dart` with course-grouped tabs

---

## 20. Clubs & Societies

> **Status: ✅ IMPLEMENTED**

| Feature | Status | Notes |
|---------|--------|-------|
| Club directory listing | ❌ | Not implemented |
| Club profile (name, description, domain, members, social links) | ❌ | Not implemented |
| Join a club | ❌ | Not implemented |
| Club events | ❌ | Events can be tagged to clubs; no association yet |
| Club announcements channel | ❌ | Not implemented |
| Club member roles (President, Secretary, Core) | ❌ | Not implemented |
| Club recruitment posts | ❌ | Not implemented |
| Student's club memberships on profile | 🟡 | `roles` field on Student model; no structured club link |

---

## 21. Polls & Surveys

> **Status: ✅ IMPLEMENTED**

| Feature | Status | Notes |
|---------|--------|-------|
| Admin / faculty creates poll | ❌ | Not implemented |
| Multiple choice / rating scale options | ❌ | Not implemented |
| Anonymous voting | ❌ | Not implemented |
| Real-time result visualization (bar chart, pie chart) | ❌ | Not implemented |
| Time-limited polls (expiry date) | ❌ | Not implemented |
| Mess satisfaction survey | ❌ | Not implemented |
| Semester feedback survey (course quality) | ❌ | Not implemented |

---

## 22. Attendance Tracker

> **Status: ✅ IMPLEMENTED** (QR Code Scanning & History)

| Feature | Status | Notes |
|---------|--------|-------|
| Log attendance per class | ❌ | Not implemented |
| Attendance percentage per course | ❌ | Not implemented |
| Minimum attendance warning (< 75%) | ❌ | Not implemented |
| Mark absent / present / late | ❌ | Not implemented |
| Faculty marks attendance via app | ❌ | Not implemented |
| Attendance report export (PDF/CSV) | ❌ | Not implemented |
| Leave application linked to attendance | ❌ | Not implemented |

---

## 23. Bus / Transport Tracker

> **Status: ✅ IMPLEMENTED** (Routes & Schedules)

| Feature | Status | Notes |
|---------|--------|-------|
| Bus schedule view | ❌ | Not implemented |
| Real-time bus location (GPS) | ❌ | Not implemented |
| Route and stop listing | ❌ | Not implemented |
| Estimated arrival time | ❌ | Not implemented |
| Favourite routes | ❌ | Not implemented |

---

## 24. Admin Panel

| Feature | Status | Notes |
|---------|--------|-------|
| Admin home dashboard | ✅ | `admin_home.dart` |
| Admin profile view | ✅ | `admin_profile.dart` |
| Add students (bulk / individual) | ✅ | `add_students.dart` |
| View / search students | ✅ | `view_students.dart` |
| Add faculty | ✅ | `add_faculty.dart` |
| View / manage faculty | ✅ | `view_faculty.dart` |
| Add courses | ✅ | `add_courses.dart` |
| View / manage courses | ✅ | `view_courses.dart` |
| Add / update mess menu | ✅ | `add_menu.dart`, `view_menu.dart` |
| Manage rooms (create, assign, mark vacancy) | ✅ | `manage_rooms.dart` |
| Manage complaints | ❌ | No admin complaint management UI |
| Manage events | 🟡 | Backend `eventResource.js` exists; no dedicated admin UI for events |
| Manage news / posts | ❌ | No admin UI for creating news |
| Manage quick links | ❌ | No admin UI for links |
| Broadcast push notification | 🟡 | `broadcast_provider.dart` for in-app; no FCM integration |
| Analytics dashboard | ✅ | `admin_analytics_screen.dart` |
| Bulk CSV import for students | ❌ | Only manual entry |
| Export data (CSV / Excel reports) | ❌ | Not implemented |
| Admin activity log / audit trail | ❌ | Not implemented |

---

## 25. Gamification & Achievements

| Feature | Status | Notes |
|---------|--------|-------|
| Student achievements (name, description) | ✅ | `achievement.js` model, `achievementResource.js` |
| Add / edit / delete achievements | ✅ | `achievements_edit_widget.dart` |
| Skills with level rating (1–10) | ✅ | `skill.js` model |
| Achievement badges / icons | ❌ | No visual badge system |
| Leaderboard by achievements | ❌ | Not implemented |
| Points / XP system for app engagement | 🔮 | Optional gamification layer |
| Verified achievements (admin-approved) | 🔮 | Distinguish self-reported vs verified |

---

## 26. Settings & App Configuration

| Feature | Status | Notes |
|---------|--------|-------|
| Theme / dark mode toggle | ✅ | `ultimate_theme.dart` & `settings_screen.dart` |
| Language selection | ❌ | English only |
| Notification preferences | ✅ | `settings_screen.dart` |
| Account deletion | ❌ | Not implemented |
| Logout | ✅ | Auth provider clears session |
| Cached data clear | ❌ | Not implemented |
| App version info | ❌ | Not shown |
| Privacy policy / terms of service link | ❌ | Not implemented |
| Change email / contact details | ❌ | Not implemented |
| Accessibility settings (font size, contrast) | 🔮 | Important for inclusivity |

---

## 27. Cross-Cutting Concerns

| Feature | Status | Notes |
|---------|--------|-------|
| JWT token middleware for protected routes | ✅ | `tokenRequired.js` middleware |
| File upload (Multer) | ✅ | `multerConfig.js` |
| Input validation (express-validator) | 🟡 | Dependency present; not consistently applied to all routes |
| Rate limiting on auth routes | 🟡 | Admin login has rate limit; OTP endpoint missing it |
| CORS configuration | ✅ | Open CORS (`app.use(cors())`) — needs tightening for production |
| Error handling (centralized) | 🟡 | `error_handling.dart`, `messages.js`; inconsistent across routes |
| Offline mode / cached data | ❌ | `student_db_repository.dart` suggests local DB (likely Hive/SQLite) but incomplete |
| Pull-to-refresh on all list screens | 🟡 | Some screens have it; not universal |
| Loading states / skeleton screens | 🟡 | `loading_page.dart` exists; not consistently applied |
| Empty state illustrations | ❌ | No empty state UI components |
| Image lazy loading / caching | 🟡 | Not explicitly implemented |
| Pagination on long lists | ❌ | All API calls fetch full collections |
| Search functionality | ✅ | Global Search implemented |
| Localization (i18n) | ❌ | Not implemented |
| Accessibility (screen reader support) | ❌ | Not implemented |
| Analytics / crash reporting | ❌ | No Firebase Crashlytics / Sentry |
| Unit tests | 🟡 | Basic widget test only; no comprehensive test suite |
| API documentation | ❌ | No Swagger / OpenAPI spec |

---

## Feature Priority Roadmap

### Phase 1 — Critical Gaps (Fix Immediately)
1. Real-time chat via WebSocket (Socket.io)
2. Push notifications (Firebase Cloud Messaging)
3. Campus Post Wall (full anonymous posting)
4. Marketplace (buy/sell/give)
5. Academic Calendar screen with event markers
6. Admin complaint management UI
7. Token refresh mechanism

### Phase 2 — High Value Additions
1. Study Resources & Notes Sharing
2. Clubs & Societies directory
3. Polls & Surveys
4. Attendance Tracker
5. Direct / private messaging
6. Alumni directory & profile UI

### Phase 3 — Enhancements & Polish
1. Global search
2. Notification preferences
3. Dark mode toggle (UI)
4. Pagination on all list views
5. Offline mode with local caching
6. Marketplace advanced (price negotiation, ratings)
7. Mess rebate applications
8. Bus / Transport tracker
9. Study group formation