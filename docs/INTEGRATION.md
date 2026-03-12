# Smart Insti App — External Integration & Feature Borrowing Map

> This document specifies precisely which backend features, API routes, data models, controllers, and utilities can be **directly adopted, adapted, or referenced** from the two external OpenLake repositories:
>
> - **`openlake-student_database_cosa`** → referred to as **COSA-DB** throughout this document
> - **`openlake-campus-marketplace`** → referred to as **MARKETPLACE** throughout this document
>
> For each feature area, we describe: what exists in the source repo, what needs to change for Smart Insti App, and how to wire it into the existing Flutter + Node.js/Express codebase.

---

## Table of Contents

1. [Integration Strategy Overview](#1-integration-strategy-overview)
2. [Authentication & User Model](#2-authentication--user-model)
3. [Student Profile & Academic Info](#3-student-profile--academic-info)
4. [Clubs & Organisations (Org Units)](#4-clubs--organisations-org-units)
5. [Positions of Responsibility (PORs)](#5-positions-of-responsibility-pors)
6. [Skills with Endorsement](#6-skills-with-endorsement)
7. [Achievements with Verification](#7-achievements-with-verification)
8. [Events (Rich Schema)](#8-events-rich-schema)
9. [Announcements (Targeted & Pinned)](#9-announcements-targeted--pinned)
10. [Feedback System](#10-feedback-system)
11. [Analytics Dashboard](#11-analytics-dashboard)
12. [Marketplace — Listings](#12-marketplace--listings)
13. [Marketplace — Orders](#13-marketplace--orders)
14. [Marketplace — Vendor / Club Storefront](#14-marketplace--vendor--club-storefront)
15. [Marketplace — Wishlist](#15-marketplace--wishlist)
16. [Marketplace — Reviews & Ratings](#16-marketplace--reviews--ratings)
17. [Marketplace — Chat (Private Messaging)](#17-marketplace--chat-private-messaging)
18. [Marketplace — Notifications](#18-marketplace--notifications)
19. [Marketplace — Reports / Moderation](#19-marketplace--reports--moderation)
20. [Marketplace — Activity Log](#20-marketplace--activity-log)
21. [Role-Based Access Control (RBAC)](#21-role-based-access-control-rbac)
22. [Room Booking / Room Requests](#22-room-booking--room-requests)
23. [Google OAuth / SSO](#23-google-oauth--sso)
24. [Refresh Token System](#24-refresh-token-system)
25. [Cloudinary Image Upload](#25-cloudinary-image-upload)
26. [Email Utilities](#26-email-utilities)
27. [Integration Priority Summary Table](#27-integration-priority-summary-table)
28. [Adaptation Notes & Caveats](#28-adaptation-notes--caveats)

---

## 1. Integration Strategy Overview

### Source Repos vs Smart Insti App

| Dimension | Smart Insti App (current) | COSA-DB | MARKETPLACE |
|---|---|---|---|
| Language / Runtime | Node.js (ESM) + Flutter | Node.js (CJS) | Node.js (ESM) |
| Database | MongoDB + Mongoose | MongoDB + Mongoose | MongoDB + Mongoose |
| Auth | JWT (OTP-based, 7d) | JWT + Google OAuth + Passport | JWT (access + refresh) + Google OAuth |
| File Storage | Multer (local) | Cloudinary | Cloudinary |
| Frontend | Flutter (Dart) | React.js | React + Vite |

**Key principle:** The Smart Insti App Flutter frontend will call a unified Node.js/Express API. We are **only borrowing backend models, controllers, and routes** from the two source repos — the React frontends are **not** being used.

### Module Type Conversion Note
COSA-DB uses CommonJS (`require`/`module.exports`). Smart Insti App backend uses ESM (`import`/`export`). Every file borrowed from COSA-DB must be converted: replace `require(...)` with `import ... from '...'` and `module.exports = ...` with `export default ...` or named exports.

---

## 2. Authentication & User Model

### Source: MARKETPLACE (`users.model.js`, `users.controller.js`, `auth.routes.js`)

The MARKETPLACE user model is significantly more complete than Smart Insti App's current student model. It should **replace and extend** the existing `student.js` model.

**What to borrow:**

**From `users.model.js`:**
```
- username (unique, lowercase, 3-30 chars)
- email (domain-validated: @iitbhilai.ac.in)
- password (bcrypt, select:false)
- academicInfo { studentId, department, year, batch }
- hostelLocation { hostel enum, room, notes }
- phone + whatsapp fields
- roles[] enum (student, vendor_admin, club_admin, moderator, admin)
- isVerified / domainVerified booleans
- verificationToken + verificationTokenExpires
- resetPasswordToken + resetPasswordExpires
- refreshTokens[] array (max 3 sessions)
- preferences { notifications{email,push}, privacy{showPhone,showEmail} }
- trustScore (0-100) — useful for marketplace seller reputation
- rating { average, count }
- loginAttempts + lockUntil (brute force protection)
- lastLogin timestamp
```

**From `users.controller.js`:**
```
- registerUser() — with domain validation BEFORE existence check (prevents email probing)
- loginUser() — with loginAttempts counter + account lockout
- generateAccessAndRefreshTokens() — dual token system (access: 1d, refresh: 7d)
- refreshAccessToken()
- logoutUser() — clears specific refreshToken from array
- changePassword()
- forgotPassword() + resetPassword() via email token
- verifyEmail()
- getCurrentUser()
- updateProfile()
```

**From COSA-DB (`passportConfig.js`):**
```
- Google OAuth 2.0 via Passport.js strategy
- Session handling for OAuth flow
- User creation from Google profile (if not existing)
```

**Adaptation required:**
- Merge with existing Smart Insti App `student.js` schema: keep `rollNumber`, `about`, `profilePicURI`, `branch`, `graduationYear`, `skills[]`, `achievements[]` from the current model
- Add `academicInfo` from MARKETPLACE as a sub-document (more structured than flat branch/year fields)
- The `hostelLocation` from MARKETPLACE directly maps to the existing `room.js` model — link them
- Drop the separate `admin.js` model; instead use `roles[]` array (already in MARKETPLACE model)
- Keep OTP login from Smart Insti App as an additional auth route alongside password auth

**Files to create/modify:**
```
backend/models/student.js       → Merge with MARKETPLACE users.model.js
backend/resources/auth/         → Add refreshToken, forgotPassword, verifyEmail routes
backend/models/passportConfig.js → Copy from COSA-DB, convert to ESM
```

---

## 3. Student Profile & Academic Info

### Source: COSA-DB (`routes/profile.js`, `routes/onboarding.js`)

COSA-DB has a full onboarding flow and structured profile management with role-awareness.

**What to borrow:**

**From `routes/onboarding.js`:**
```
- GET  /onboarding         — fetch onboarding status + required fields
- POST /onboarding         — submit onboarding data (name, academic info, branch, year)
- PATCH /onboarding/complete — mark onboarding as done; gate all other routes until complete
```

**From `routes/profile.js`:**
```
- GET  /profile/:id        — fetch any user's public profile (with field-level privacy)
- PATCH /profile/me        — update own profile fields
- POST /profile/photo      — upload profile photo to Cloudinary
- GET  /profile/me/por     — fetch own positions of responsibility
- GET  /profile/me/skills  — fetch own skills (with endorsement status)
- GET  /profile/me/achievements — fetch own achievements (with verification status)
```

**User schema additions from COSA-DB `schema.js` (userSchema):**
```
- academic_info { program, branch, batch_year, current_year, cgpa }
- personal_info { name, email, phone, profile_photo_url }
- onboardingComplete: Boolean
- status: enum ['active', 'inactive', 'alumni']
- strategy: enum ['google', 'local']
```

**Adaptation required:**
- Combine COSA-DB `personal_info` + `academic_info` subdocuments with MARKETPLACE's flat fields into a single unified schema
- The `onboardingComplete` gate is critical — add `isAuthenticated` middleware check on all routes that should block incomplete profiles
- Cloudinary upload (see Section 25) must replace the current Multer-based `profilePicURI` field

**Files to create/modify:**
```
backend/routes/onboarding.js    → Copy from COSA-DB, convert to ESM
backend/routes/profile.js       → Copy from COSA-DB, adapt with MARKETPLACE user fields
```

---

## 4. Clubs & Organisations (Org Units)

### Source: COSA-DB (`routes/orgUnit.js`, `models/schema.js → organizationalUnitSchema`)

This is one of the most powerful features to borrow. COSA-DB has a full **hierarchical club/council/committee system** with budgets, contact info, categories, and parent–child relationships.

**What to borrow:**

**From `organizationalUnitSchema`:**
```
- unit_id: String (unique human-readable ID like "CLUB_CULTURAL_OPENVERSE")
- name: String
- type: enum ['Council', 'Club', 'Committee', 'independent_position']
- description: String
- parent_unit_id: ObjectId ref OrganizationalUnit (enables tree structure)
- hierarchy_level: Number (0 = President, 1 = Council/Gensec, 2 = Club)
- category: enum ['cultural', 'scitech', 'sports', 'academic', 'independent']
- is_active: Boolean
- contact_info { email, social_media[{ platform, url }] }
- budget_info { allocated_budget, spent_amount }
- created_at, updated_at
```

**From `routes/orgUnit.js`:**
```
- GET  /api/orgUnit              — list all org units (with filters: category, type, is_active)
- GET  /api/orgUnit/:id          — fetch single org unit with child units
- POST /api/orgUnit              — create new org unit (admin/president only)
- PATCH /api/orgUnit/:id         — update org unit details
- DELETE /api/orgUnit/:id        — deactivate (soft delete)
- GET  /api/orgUnit/:id/members  — list all position holders of this unit
- GET  /api/orgUnit/:id/events   — list events organized by this unit
- GET  /api/orgUnit/most-active  — top clubs by event count / participation
```

**Adaptation required:**
- Clubs listing screen in Smart Insti App directly maps to `GET /api/orgUnit?type=Club`
- Club profile screen maps to `GET /api/orgUnit/:id` + child events + members
- Budget fields are internal (admin/coordinator only); don't expose in student-facing API
- `category` enum maps directly to the Clubs filter tabs in UIUX.md

**Files to create:**
```
backend/models/organizationalUnit.js  → Extract from COSA-DB schema.js
backend/resources/orgUnit/orgUnitResource.js  → Adapt from COSA-DB routes/orgUnit.js
```

---

## 5. Positions of Responsibility (PORs)

### Source: COSA-DB (`routes/por.js`, `routes/positionRoutes.js`, `models/schema.js → positionSchema + positionHolderSchema`)

Positions of Responsibility are club roles held by students. This is entirely missing from Smart Insti App and provides rich profile data.

**What to borrow:**

**From `positionSchema`:**
```
- position_id: String (unique)
- title: String (e.g., "President", "Tech Lead", "Design Head")
- unit_id: ObjectId → OrganizationalUnit
- position_type: String
- responsibilities: [String]
- requirements { min_cgpa, min_year, skills_required[] }
- description: String
- position_count: Number
```

**From `positionHolderSchema`:**
```
- por_id: String (unique)
- user_id: ObjectId → User
- position_id: ObjectId → Position
- tenure_year: String (e.g., "2024-25")
- appointment_details { appointed_by, appointment_date }
- performance_metrics { events_organized, budget_utilized, feedback }
- status: enum ['active', 'completed', 'terminated']
```

**From `routes/por.js` + `routes/positionRoutes.js`:**
```
- GET  /api/por/:type            — fetch PORs by category (Acad/Cult/Sports/Scietech)
- POST /api/por/add              — add new POR holder (admin/coordinator only)
- GET  /api/positions            — list all positions across all clubs
- POST /api/positions            — create a new position (admin only)
- GET  /api/positions/:id/holders — list all holders of a position
- PATCH /api/positions/holder/:id/status — update POR holder status
```

**Adaptation required:**
- In Smart Insti App's student profile, the `roles[]` string array on the Student model should be **replaced** with a proper reference to PositionHolder records
- The Flutter student profile screen should query `GET /api/por?userId=<id>` to display PORs with club + role + tenure
- PORs appear on student profile as structured cards (club name, role title, tenure year, status badge)

**Files to create:**
```
backend/models/position.js
backend/models/positionHolder.js
backend/resources/por/porResource.js
backend/resources/positions/positionResource.js
```

---

## 6. Skills with Endorsement

### Source: COSA-DB (`routes/skillsRoutes.js`, `models/schema.js → skillSchema + userSkillSchema`)

COSA-DB's skill system is significantly more powerful than Smart Insti App's simple level-1-to-10 skill model. It adds categorisation and a **GenSec endorsement workflow**.

**What to borrow:**

**From `skillSchema` (global skill registry):**
```
- skill_id: String (unique)
- name: String
- category: String
- type: enum ['technical', 'cultural', 'sports', 'academic', 'other']
- description: String
- is_endorsed: Boolean (whether the skill definition itself is approved)
```

**From `userSkillSchema` (per-student skill claim):**
```
- user_id: ObjectId → User
- skill_id: ObjectId → Skill
- proficiency_level: enum ['beginner', 'intermediate', 'advanced', 'expert']
- position_id: ObjectId → Position (optional — skill acquired via this POR)
- is_endorsed: Boolean (whether a GenSec/admin has endorsed this student's claim)
```

**From `routes/skillsRoutes.js`:**
```
- GET  /api/skills               — list all skills (global registry), filterable by type
- POST /api/skills               — propose a new skill (any student)
- GET  /api/skills/user/:userId  — get a student's skills with endorsement status
- POST /api/skills/user          — student claims a skill (creates UserSkill record)
- PATCH /api/skills/endorse/:id  — GenSec endorses a student's skill claim
- GET  /api/skills/unendorsed/:type — fetch unendorsed skills for GenSec review
- DELETE /api/skills/user/:id    — remove a skill claim
- GET  /api/skills/top           — top 5 most common skills across all students
```

**Adaptation required:**
- Replace the current `skill.js` model (name + level 1-10) with the dual Skill + UserSkill schema
- `proficiency_level` enum ('beginner'→'expert') replaces the numeric `level` field
- Add a `skills/pending` section in the admin panel for endorsement queue
- Student profile view should show endorsed skills differently from pending ones (visual badge)

**Files to modify/create:**
```
backend/models/skill.js          → Replace with COSA-DB's dual schema
backend/models/userSkill.js      → New file extracted from COSA-DB schema.js
backend/resources/student/skillResource.js → Expand with COSA-DB routes
```

---

## 7. Achievements with Verification

### Source: COSA-DB (`routes/achievements.js`, `models/schema.js → achievementSchema`)

COSA-DB's achievement model adds verification workflow, certificate upload, event linking, and categories. This is a direct upgrade to Smart Insti App's existing achievements.

**What to borrow:**

**From `achievementSchema`:**
```
- achievement_id: String (unique)
- user_id: ObjectId → User
- title: String
- description: String
- category: String (e.g., "Technical", "Sports", "Cultural")
- type: String
- level: String (e.g., "Institute", "State", "National", "International")
- date_achieved: Date (required)
- position: String (e.g., "1st Place", "Finalist")
- event_id: ObjectId → Event (optional — links to campus event)
- certificate_url: String (Cloudinary URL for certificate image/PDF)
- verified: Boolean (default false)
- verified_by: ObjectId → User (the GenSec/admin who verified)
```

**From `routes/achievements.js`:**
```
- GET  /api/achievements                — list own achievements
- POST /api/achievements                — submit new achievement for verification
- PATCH /api/achievements/:id           — edit own unverified achievement
- DELETE /api/achievements/:id          — delete own achievement
- GET  /api/achievements/unendorsed/:type — admin: fetch unverified achievements by type
- PATCH /api/achievements/verify/:id    — admin: mark achievement as verified
- POST /api/achievements/reject/:id     — admin: reject (delete) achievement
```

**Adaptation required:**
- Extend Smart Insti App's `achievement.js` with the new fields: `level`, `date_achieved`, `position`, `event_id`, `certificate_url`, `verified`, `verified_by`
- Add Cloudinary upload for certificate images (see Section 25)
- In the student profile, show a `✓ Verified` badge on verified achievements
- Add admin endorsement queue to admin home stats card

**Files to modify:**
```
backend/models/achievement.js              → Extend with COSA-DB fields
backend/resources/student/achievementResource.js → Add verification routes
```

---

## 8. Events (Rich Schema)

### Source: COSA-DB (`routes/events.js`, `controllers/eventControllers.js`, `models/schema.js → eventSchema`)

COSA-DB's event model is vastly more complete than Smart Insti App's current `eventSchema`. It adds: participant tracking, winners, room booking sub-documents, budget tracking, sponsors, and event lifecycle statuses.

**What to borrow:**

**From COSA-DB `eventSchema`:**
```
- event_id: String (unique)
- title, description
- category: enum ['cultural', 'technical', 'sports', 'academic', 'other']
- type: String (sub-type within category)
- organizing_unit_id: ObjectId → OrganizationalUnit
- organizers: [ObjectId → User]
- schedule { start: Date, end: Date, venue: String, mode: enum['online','offline','hybrid'] }
- registration { required: Boolean, start, end, fees, max_participants }
- budget { allocated, spent, sponsors[] }
- status: enum ['planned', 'ongoing', 'completed', 'cancelled']
- participants: [ObjectId → User]
- winners [{ user: ObjectId, position: String }]
- feedback_summary: Object
- media { images[], videos[], documents[] }
- room_requests [{ date, time, room, description, status, requested_at, reviewed_by }]
```

**From `routes/events.js` + `controllers/eventControllers.js`:**
```
- GET  /api/events                     — list events (filter: category, status, unit)
- POST /api/events                     — create event (coordinator/admin)
- GET  /api/events/:id                 — event detail with full schema
- PATCH /api/events/:id                — update event
- DELETE /api/events/:id               — cancel/delete event
- POST /api/events/:id/register        — student registers for event
- DELETE /api/events/:id/register      — student unregisters
- POST /api/events/:id/room-request    — request a room for the event
- PATCH /api/events/:id/room-request/:reqId — admin approves/rejects room request
- GET  /api/events/:id/participants    — list all registered participants
- POST /api/events/:id/winners         — add/update winners (post-event)
```

**Adaptation required:**
- The current Smart Insti App `event.js` model (title, description, date, location, imageURI, organizedBy) should be **replaced** with COSA-DB's schema
- `organizing_unit_id` links events to clubs — this powers the club profile's "Events" tab
- The `room_requests` sub-document directly feeds the Room Vacancy / admin room management screens
- `participants[]` array enables the RSVP feature ("I'm Interested") from FEATURES.md
- Media `images[]` (multi-image Cloudinary) replaces the single `imageURI` field

**Files to modify:**
```
backend/models/event.js              → Replace with COSA-DB eventSchema
backend/resources/events/eventResource.js → Expand with COSA-DB routes
```

---

## 9. Announcements (Targeted & Pinned)

### Source: COSA-DB (`routes/announcements.js`, `models/schema.js → announcementSchema`)

COSA-DB's announcement system is much richer than Smart Insti App's current broadcast. It supports **targeted announcements** (linked to specific Events, OrgUnits, or Positions), pinning, full pagination, sorting, and search.

**What to borrow:**

**From `announcementSchema`:**
```
- title, content
- author: ObjectId → User
- type: enum ['General', 'Event', 'Organizational_Unit', 'Position']
- target_id: ObjectId (dynamic ref based on type — links to specific entity)
- is_pinned: Boolean
- createdAt, updatedAt
```

**From `routes/announcements.js`:**
```
- GET  /api/announcements          — list with filter (type, author, isPinned), search, pagination, sort
- POST /api/announcements          — create (authenticated users)
- GET  /api/announcements/:id      — fetch single announcement with populated target
- PUT  /api/announcements/:id      — update (author only)
- DELETE /api/announcements/:id    — delete (author only)
```

**Adaptation required:**
- Replace Smart Insti App's current flat broadcast model with this richer schema
- The `broadcast.dart` Flutter screen maps directly to `GET /api/announcements?type=General`
- Club-specific announcements: `GET /api/announcements?type=Organizational_Unit&targetId=<clubId>`
- Pinned announcements show as sticky banners on the Home Dashboard
- Admin-created announcements use the same route (author-based ownership)

**Files to modify:**
```
backend/models/announcement.js         → Extract from COSA-DB schema.js (rename from broadcast)
backend/resources/news/newsResource.js → Replace with COSA-DB announcements routes
```

---

## 10. Feedback System

### Source: COSA-DB (`routes/feedbackRoutes.js`, `models/schema.js → feedbackSchema`)

COSA-DB's feedback system supports anonymous feedback, resolution tracking, star ratings, and targeting any entity (events, clubs, positions). This can serve both as the course feedback system and the mess rating system.

**What to borrow:**

**From `feedbackSchema`:**
```
- feedback_id: String (unique)
- type: String (e.g., "event_feedback", "mess_rating", "course_feedback")
- target_id: ObjectId (the event, course, or mess kitchen being rated)
- target_type: String (dynamic reference)
- feedback_by: ObjectId → User
- rating: Number (1-5)
- comments: String
- is_anonymous: Boolean
- is_resolved: Boolean
- actions_taken: String
- resolved_at: Date
- resolved_by: ObjectId → User
```

**From `routes/feedbackRoutes.js`:**
```
- GET  /api/feedback               — list feedback (filter by type, target, resolved)
- POST /api/feedback               — submit feedback
- GET  /api/feedback/:id           — single feedback item
- PATCH /api/feedback/:id/resolve  — admin/coordinator marks as resolved with notes
- GET  /api/feedback/target/:id    — all feedback for a specific target entity
- GET  /api/feedback/stats/:targetId — aggregated rating stats for a target
```

**Adaptation required:**
- `type = "mess_rating"` + `target_id = kitchenId` → powers the "Rate Today's Meal" button
- `type = "course_feedback"` + `target_id = courseId` → powers course feedback after semester
- `type = "event_feedback"` + `target_id = eventId` → powers event feedback form
- `is_anonymous = true` → enables the anonymous complaint analogue
- Complaints in Smart Insti App can be **migrated** to use this feedback schema, with `type = "complaint"` and `is_resolved` replacing the current status enum
- GenSec/admin resolution tracking directly maps to the admin complaint management screen

**Files to create:**
```
backend/models/feedback.js
backend/resources/complaints/complaintResource.js → Refactor to use feedback schema
backend/resources/feedback/feedbackResource.js    → New general feedback routes
```

---

## 11. Analytics Dashboard

### Source: COSA-DB (`controllers/analyticsController.js`, `routes/analytics.js`, `controllers/dashboardController.js`, `routes/dashboard.js`)

COSA-DB has a fully built role-aware analytics system with MongoDB aggregation pipelines for President, GenSec, Club Coordinator, and Student views.

**What to borrow:**

**From `analyticsController.js`:**
```
- getPresidentAnalytics()  — user stats, demographics, event stats, org stats, POR distribution, top clubs, participation trends
- getGensecAnalytics()     — council-scoped: child clubs count, pending endorsements, budget, event counts
- getClubCoordinatorAnalytics() — club-scoped: members, events, pending reviews, budget
- getStudentAnalytics()    — personal: participation trend (12mo), skill categories (pie), event preferences (pie), achievement status, engagement score
```

**From `controllers/dashboardController.js`:**
```
- getDashboardStats()  — role-switched quick stats (same role enum as above)
  - STUDENT: { totalSkills, totalFeedbacksGiven, totalAchievements, totalPORs }
  - GENSEC: { budget, parentOfClubs, pendingSkillsEndorsement, pendingAchievementEndorsement }
  - CLUB_COORDINATOR: { budget, totalEvents, totalActiveMembers, pendingReviews }
  - PRESIDENT: { pendingRoomRequests, totalOrgUnits, budget }
```

**From `routes/analytics.js`:**
```
- GET /api/analytics/president      → President role only
- GET /api/analytics/gensec         → GenSec roles only
- GET /api/analytics/club-coordinator → Club Coordinator only
- GET /api/analytics/student        → Student role
```

**Adaptation required:**
- Map COSA-DB roles to Smart Insti App roles: `PRESIDENT` → admin super role; `GENSEC_*` → admin department roles; `CLUB_COORDINATOR` → club lead student role; `STUDENT` → default student role
- The admin home dashboard in Smart Insti App should call `GET /api/dashboard` and render role-appropriate stat cards
- Student home dashboard `GET /api/analytics/student` returns personal engagement score — display as a gamification card on student home
- Participation trend chart: use `participationTrend` data to render a 12-month bar chart in student profile
- `getTenureRange()` utility from COSA-DB (`utils/getTenureRange.js`) should be copied as-is

**Files to create:**
```
backend/controllers/analyticsController.js → Copy + convert from COSA-DB (ESM)
backend/controllers/dashboardController.js → Copy + convert from COSA-DB (ESM)
backend/routes/analytics.js
backend/routes/dashboard.js
backend/utils/getTenureRange.js → Copy from COSA-DB
```

---

## 12. Marketplace — Listings

### Source: MARKETPLACE (`models/listing.model.js`, `controllers/listing.controller.js`, `routes/listing.routes.js`)

The entire Marketplace feature for Smart Insti App is built on top of the MARKETPLACE repo's listings system. This is the **highest priority borrow** for the marketplace feature.

**What to borrow:**

**From `listing.model.js` / `schemas.json → Listing`:**
```
- title (text-indexed for search)
- description (text-indexed for search, min 10 chars)
- price, originalPrice, priceHistory[], negotiable
- images[] { url, publicId, isPrimary }
- category: enum ['books', 'electronics', 'cycle', 'hostel-item', 'clothing', 'stationery', 'sports', 'food', 'other']
- subcategory, brand, model
- condition: enum ['new', 'like-new', 'good', 'fair', 'poor']
- owner: ObjectId → User
- status: enum ['active', 'sold', 'reserved', 'expired', 'banned']
- isAvailable, isFeatured, isUrgent booleans
- location { hostel enum, pickupPoint, deliveryAvailable }
- tags[]
- views { total }
- likes[]
- soldTo, soldAt, soldPrice
- expiresAt (TTL index)
```

**From `controllers/listing.controller.js`:**
```
- createListing()         — multi-image upload to Cloudinary, slug generation
- getAllListings()         — paginated, filterable (category, condition, price range, hostel, search text)
- getListingById()        — full detail with seller info populated
- updateListing()         — owner only, re-upload images if changed
- deleteListing()         — owner or admin; soft-delete (status → 'banned') or hard-delete
- getMyListings()         — seller's own listings with status filter
- toggleWishlist()        — add/remove from user's wishlist
- markAsSold()            — seller marks item sold; updates status + logs
- searchListings()        — full-text search via MongoDB text index
- getFeaturedListings()   — isFeatured = true listings for home banner
- getRelatedListings()    — same category, exclude current, limit 4
```

**From `routes/listing.routes.js`:**
```
- GET    /api/listings               — browse all (public)
- POST   /api/listings               — create (authenticated)
- GET    /api/listings/featured      — featured listings (public)
- GET    /api/listings/my            — own listings (authenticated)
- GET    /api/listings/:id           — detail (public)
- PUT    /api/listings/:id           — update (owner)
- DELETE /api/listings/:id           — delete (owner or admin)
- PATCH  /api/listings/:id/sold      — mark sold (owner)
```

**Adaptation required:**
- The hostel enum (`['kanhar', 'Gopad', 'Indravati', 'Shivnath']`) is IIT Bhilai-specific — verify these are the correct hostel names for your institution and update accordingly
- Pagination uses `mongoose-paginate-v2` — add this dependency to Smart Insti App backend
- Image upload uses Cloudinary (see Section 25)
- Multi-step listing form in Flutter: BasicInfo → Images → Location → Pricing (maps to `steps/` components in MARKETPLACE frontend, which describe the form flow)

**Files to create:**
```
backend/models/listing.js
backend/resources/marketplace/listingResource.js
```

---

## 13. Marketplace — Orders

### Source: MARKETPLACE (`models/order.model.js`, `controllers/order.controller.js`, `routes/order.routes.js`)

**What to borrow:**

**From `order.model.js`:**
```
- buyer: ObjectId → User
- seller: ObjectId → User
- items[] { listing: ObjectId, quantity, price }
- totalAmount: Number
- address: String (pickup point)
- paymentStatus: enum ['pending', 'completed', 'failed', 'refunded']
- deliveryStatus: enum ['pending', 'in-progress', 'delivered', 'cancelled']
```

**From `controllers/order.controller.js`:**
```
- createOrder()        — validates items, calculates total, MVP: single seller per order
- getOrderById()       — buyer/seller/admin access control
- updateOrderStatus()  — seller updates delivery status; auto-marks listing sold on 'delivered'
- getMyOrders()        — buyer's purchase history
- getMySales()         — seller's sales history
```

**From `routes/order.routes.js`:**
```
- POST   /api/orders             — create order
- GET    /api/orders/my          — my purchases
- GET    /api/orders/sales       — my sales
- GET    /api/orders/:id         — order detail
- PATCH  /api/orders/:id/status  — update delivery status
```

**Adaptation required:**
- Payment integration is out of scope for MVP; `paymentStatus` stays as `pending` until manual confirmation
- Add a UPI QR display on order confirmation screen (static link to seller's UPI ID)
- Single-seller restriction per order is correct for MVP; remove for future cart feature

**Files to create:**
```
backend/models/order.js
backend/resources/marketplace/orderResource.js
```

---

## 14. Marketplace — Vendor / Club Storefront

### Source: MARKETPLACE (`models/vendors.model.js`, `controllers/vendor.controller.js`, `routes/vendor.routes.js`)

This enables campus food stalls (Tech Café, AtMart) and clubs to have official storefronts.

**What to borrow:**

**From `vendors.model.js`:**
```
- name, description
- logoUrl (Cloudinary)
- vendorType: enum ['food', 'clubs', 'sports', 'stationery', 'other']
- admins: [ObjectId → User]
- isOpen: Boolean
- location: String
- contactInfo { phone, email }
- rating { average, count }
- operatingHours { open, close, days[] }
```

**From `controllers/vendor.controller.js`:**
```
- createVendor()
- getVendors()        — list all, filterable by type
- getVendorById()     — full detail with listings
- updateVendor()      — vendor admin only
- toggleVendorStatus() — open/close toggle
```

**Adaptation required:**
- Clubs from COSA-DB OrganizationalUnit can auto-create a Vendor record when a club coordinator wants to sell merch
- `vendorType = 'clubs'` listings appear in the Marketplace's "Club Merch" section
- `isOpen` toggle is the "Online/Offline" status shown in the marketplace header

**Files to create:**
```
backend/models/vendor.js
backend/resources/marketplace/vendorResource.js
```

---

## 15. Marketplace — Wishlist

### Source: MARKETPLACE (`models/wishlist.model.js`, `controllers/wishlist.controller.js`, `routes/wishlist.routes.js`)

**What to borrow:**

**From `wishlist.model.js`:**
```
- user: ObjectId → User
- items[] { listing: ObjectId, addedAt: Date }
```

**From `controllers/wishlist.controller.js`:**
```
- addToWishlist()     — add a listing to user's wishlist (prevent duplicates)
- removeFromWishlist() — remove by listingId
- getWishlist()       — user's full wishlist with populated listing details
```

**Routes:**
```
- GET    /api/wishlist         — fetch wishlist
- POST   /api/wishlist/:listingId  — add item
- DELETE /api/wishlist/:listingId  — remove item
```

**Adaptation required:** Minimal. The User model from MARKETPLACE also has an embedded `wishlist[]` array — use the separate Wishlist model to avoid bloating the user document.

**Files to create:**
```
backend/models/wishlist.js
backend/resources/marketplace/wishlistResource.js
```

---

## 16. Marketplace — Reviews & Ratings

### Source: MARKETPLACE (`models/reviews.model.js`, `controllers/review.controller.js`, `routes/review.routes.js`)

**What to borrow:**

**From `reviews.model.js`:**
```
- reviewer: ObjectId → User
- reviewee: ObjectId → User (the seller)
- listing: ObjectId → Listing
- vendor: ObjectId → Vendor
- rating: Number (1-5)
- comment: String
- verified: Boolean (only buyers who completed an order can review)
```

**Routes:**
```
- POST   /api/reviews            — submit review (only verified buyers)
- GET    /api/reviews/user/:id   — reviews for a specific seller
- GET    /api/reviews/listing/:id — reviews for a listing
```

**Adaptation required:**
- Gate review submission: only allow if an `Order` with `deliveryStatus='delivered'` exists between reviewer and reviewee
- Seller `rating.average` and `rating.count` on the User model (from MARKETPLACE) updates via a post-save hook on Review

**Files to create:**
```
backend/models/review.js
backend/resources/marketplace/reviewResource.js
```

---

## 17. Marketplace — Chat (Private Messaging)

### Source: MARKETPLACE (`models/chat.model.js`, `controllers/chat.controller.js`, `routes/chat.routes.js`)

This fills the **critical missing feature** of private messaging in Smart Insti App.

**What to borrow:**

**From `chat.model.js`:**
```
- Conversation model:
  participants: [ObjectId → User] (exactly 2 for DM)
  lastMessage: ObjectId → Message
  updatedAt: Date

- Message model:
  conversation: ObjectId → Conversation
  sender: ObjectId → User
  content: String
  isRead: Boolean
  readAt: Date
  messageType: enum ['text', 'image', 'system']
  imageUrl: String (optional)
```

**From `controllers/chat.controller.js`:**
```
- getOrCreateConversation()   — start DM with seller (triggered from listing page)
- getMyConversations()        — chat list with last message + unread count
- getMessages()               — paginated message history for a conversation
- sendMessage()               — send text or image in a conversation
- markAsRead()                — mark all unread messages as read
```

**Routes:**
```
- GET    /api/chat/conversations         — list all DM conversations
- POST   /api/chat/conversations/:userId — start/get DM with user
- GET    /api/chat/conversations/:id/messages — message history
- POST   /api/chat/conversations/:id/messages — send message
- PATCH  /api/chat/conversations/:id/read     — mark as read
```

**Adaptation required:**
- Add Socket.io to Smart Insti App backend for real-time message delivery (this is the single most impactful infrastructure addition needed)
- The global chatroom (`/messages`) stays as-is; this new system is for private DMs
- "Chat with Seller" button on a marketplace listing page creates/opens a conversation via `POST /api/chat/conversations/:sellerId`
- Unread count feeds the notification bell badge on the home AppBar

**Files to create:**
```
backend/models/conversation.js
backend/models/message.js   (rename/extend existing message.js)
backend/resources/chat/chatResource.js
```

**Additional dependency:**
```
npm install socket.io
```

---

## 18. Marketplace — Notifications

### Source: MARKETPLACE (`models/notification.model.js`, `controllers/notification.controller.js`, `routes/notification.routes.js`)

**What to borrow:**

**From `notification.model.js` / `schemas.json → Notification`:**
```
- recipient: ObjectId → User
- sender: ObjectId → User
- type: enum ['order_placed', 'order_completed', 'order_cancelled', 'new_listing', 'listing_sold', 'review_received', 'message_received']
- title, message
- relatedId: ObjectId (the order/listing/etc.)
- relatedModel: enum ['Order', 'Listing', 'User', 'Review']
- isRead: Boolean
- readAt: Date
```

**From `controllers/notification.controller.js`:**
```
- getNotifications()         — paginated list for current user
- markNotificationRead()     — mark single notification as read
- markAllRead()              — mark all as read
- deleteNotification()
- getUnreadCount()           — for badge display
```

**Routes:**
```
- GET    /api/notifications              — list notifications
- GET    /api/notifications/unread-count — badge count
- PATCH  /api/notifications/:id/read    — mark read
- PATCH  /api/notifications/read-all    — mark all read
- DELETE /api/notifications/:id
```

**Adaptation required:**
- Extend `type` enum to include Smart Insti App-specific types: `'new_complaint_resolved'`, `'broadcast_received'`, `'event_reminder'`, `'achievement_verified'`, `'skill_endorsed'`
- Notification creation is triggered server-side (in order, complaint, broadcast controllers) — not called directly by the client
- The existing `broadcast_provider.dart` in Flutter should be refactored to poll this API instead of its current custom endpoint

**Files to create:**
```
backend/models/notification.js
backend/resources/notifications/notificationResource.js
```

---

## 19. Marketplace — Reports / Moderation

### Source: MARKETPLACE (`models/report.model.js`, `controllers/report.controller.js`, `routes/report.routes.js`)

**What to borrow:**

**From `report.model.js` / `schemas.json → Report`:**
```
- reporter: ObjectId → User
- reportedItem: ObjectId (the listing/user/review being reported)
- reportedItemType: enum ['Listing', 'User', 'Review']
- type: enum ['inappropriate_content', 'spam', 'fraud', 'harassment', 'fake_listing', 'other']
- description: String (max 500)
- status: enum ['pending', 'reviewed', 'resolved', 'dismissed']
- reviewedBy: ObjectId → User
- reviewedAt: Date
- resolution: String
```

**Routes:**
```
- POST   /api/reports             — submit a report
- GET    /api/reports             — admin: list all reports with filter
- PATCH  /api/reports/:id         — admin: update status + resolution note
```

**Adaptation required:**
- Extend `reportedItemType` to include `'Campus Post'` for the Campus Post Wall moderation
- This is what powers the "🚩 Report" flag on marketplace listings AND campus post wall posts
- Admin complaint management in Smart Insti App can use this same report system

**Files to create:**
```
backend/models/report.js
backend/resources/moderation/reportResource.js
```

---

## 20. Marketplace — Activity Log

### Source: MARKETPLACE (`models/activityLog.model.js`)

**What to borrow:**

**From `activityLog.model.js`:**
```
- user: ObjectId → User
- activityType: enum ['listing_created', 'listing_sold', 'order_placed', 'order_completed', 'review_given', 'user_registered', 'vendor_created']
- description: String
- entityType: enum ['User', 'Listing', 'Order', 'Vendor', 'Review']
- entityId: ObjectId
- TTL index: auto-delete after 6 months
```

**Static methods:**
```
ActivityLog.logActivity(userId, activityType, description, options)
ActivityLog.getUserActivities(userId, limit)
```

**Adaptation required:**
- Extend `activityType` enum with Smart Insti App events: `'complaint_filed'`, `'achievement_submitted'`, `'skill_claimed'`, `'event_registered'`, `'campus post_posted'`
- Admin audit trail (from FEATURES.md wishlist) is built on top of this model
- TTL of 6 months is appropriate; keep as-is

**Files to create:**
```
backend/models/activityLog.js
```

---

## 21. Role-Based Access Control (RBAC)

### Source: COSA-DB (`middlewares/authorizeRole.js`, `middlewares/isAuthenticated.js`, `utils/roles.js`)

**What to borrow:**

**From `utils/roles.js`:**
```javascript
const ROLES = {
  PRESIDENT: 'PRESIDENT',
  GENSEC_SCITECH: 'GENSEC_SCITECH',
  GENSEC_ACADEMIC: 'GENSEC_ACADEMIC',
  GENSEC_CULTURAL: 'GENSEC_CULTURAL',
  GENSEC_SPORTS: 'GENSEC_SPORTS',
  CLUB_COORDINATOR: 'CLUB_COORDINATOR',
  STUDENT: 'STUDENT',
};

const ROLE_GROUPS = {
  ADMIN: ['PRESIDENT', 'GENSEC_SCITECH', 'GENSEC_ACADEMIC', 'GENSEC_CULTURAL', 'GENSEC_SPORTS'],
  GENSECS: ['GENSEC_SCITECH', 'GENSEC_ACADEMIC', 'GENSEC_CULTURAL', 'GENSEC_SPORTS'],
  ALL: ['PRESIDENT', 'GENSEC_SCITECH', ... , 'STUDENT'],
};
```

**From `middlewares/authorizeRole.js`:**
```javascript
// Usage: router.get('/route', isAuthenticated, authorizeRole(['PRESIDENT', 'GENSEC_*']), handler)
const authorizeRole = (allowedRoles) => (req, res, next) => {
  if (!allowedRoles.includes(req.user.role)) return res.status(403).json({ message: 'Forbidden' });
  next();
};
```

**From `middlewares/isAuthenticated.js`:**
```javascript
// Verifies JWT, attaches req.user, checks onboardingComplete gate
```

**Adaptation required:**
- Map onto MARKETPLACE's array-based roles (`roles: ['student', 'vendor_admin', 'club_admin', 'admin']`)
- Smart Insti App's `tokenRequired.js` should be **replaced** with COSA-DB's `isAuthenticated.js` (more complete: handles both session and Bearer token)
- Add `authorizeRole` middleware to all admin-only routes in Smart Insti App backend

**Files to modify:**
```
backend/middlewares/tokenRequired.js   → Replace with isAuthenticated.js from COSA-DB
backend/utils/roles.js                 → Create new from COSA-DB roles.js
backend/middlewares/authorizeRole.js   → Copy from COSA-DB
```

---

## 22. Room Booking / Room Requests

### Source: COSA-DB (sub-document within `eventSchema → room_requests[]`)

The room booking feature in COSA-DB is embedded in events. Smart Insti App has a standalone Room model. The two approaches should be **merged**.

**What to borrow:**

**From `eventSchema.room_requests[]`:**
```
- date: Date
- time: String
- room: String
- description: String
- status: enum ['Pending', 'Approved', 'Rejected']
- requested_at: Date
- reviewed_by: ObjectId → User (the President/admin who reviewed)
```

**From COSA-DB frontend (`Components/RoomBooking.jsx` + `Components/Events/RoomRequestsList.jsx` + `ManageRoomRequest.jsx`):**
These describe the flow: club coordinator files a room request inside an event → President sees a pending count on dashboard → President approves/rejects.

**Adaptation required:**
- Add `room_requests[]` sub-document to Smart Insti App's `event.js` model
- Create a standalone `GET /api/room-requests` route for the admin panel to see all pending requests across events (aggregation query)
- The President dashboard stat card `pendingRoomRequests` feeds directly from this

**Files to modify:**
```
backend/models/event.js    → Add room_requests sub-document
backend/resources/rooms/roomResource.js → Add room request approval routes
```

---

## 23. Google OAuth / SSO

### Source: COSA-DB (`models/passportConfig.js`), MARKETPLACE (`controllers/googleAuth.controller.js`, `routes/auth.routes.js`)

Both repos implement Google OAuth — COSA-DB via Passport.js, MARKETPLACE via `google-auth-library` (token verification approach, better for mobile).

**Recommend: Use MARKETPLACE's approach** — it verifies the Google ID token sent from the Flutter app via `google_sign_in` package, without requiring server-side OAuth redirect flow (which is awkward in mobile).

**What to borrow from MARKETPLACE `googleAuth.controller.js`:**
```javascript
- googleSignIn(req, res)
  1. Receives { credential } (Google ID token) from Flutter client
  2. Verifies via OAuth2Client.verifyIdToken()
  3. Extracts { name, email, picture } from ticket payload
  4. Finds or creates User in MongoDB (upsert by email)
  5. Returns accessToken + refreshToken
```

**Adaptation required:**
- Add `GOOGLE_CLIENT_ID` to `.env`
- Install `google-auth-library` package
- In Flutter: use `google_sign_in` package → send `googleSignIn.currentUser?.authentication.idToken` to `POST /api/auth/google`
- Domain check: validate that email ends in `@iitbhilai.ac.in` (as MARKETPLACE `registerUser` does)
- Map Google profile photo to `profilePicURI`

**Files to create:**
```
backend/controllers/googleAuthController.js → Copy from MARKETPLACE
backend/resources/auth/googleAuthResource.js → New route
```

**Dependency to add:**
```
npm install google-auth-library
```

---

## 24. Refresh Token System

### Source: MARKETPLACE (`controllers/users.controller.js → generateAccessAndRefreshTokens()`)

Smart Insti App currently issues only a 7-day JWT with no refresh mechanism. MARKETPLACE has a proper dual-token system.

**What to borrow:**
```javascript
- generateAccessAndRefreshTokens(userId)
  → accessToken (1d expiry, contains user payload)
  → refreshToken (7d expiry, ID only)
  → stores refreshTokens[] on user (max 3 sessions)

- refreshAccessToken endpoint:
  POST /api/auth/refresh-token
  → reads refreshToken from HttpOnly cookie or request body
  → verifies against stored array
  → issues new accessToken (+ rotates refreshToken)

- logoutUser endpoint:
  POST /api/auth/logout
  → removes specific refreshToken from user's array
  → clears cookies
```

**Adaptation required:**
- Current Smart Insti App OTP flow issues token once; after verification, call `generateAccessAndRefreshTokens()` instead of a plain `jwt.sign()`
- Flutter: store refreshToken in `flutter_secure_storage`; use Dio interceptor to auto-refresh on 401

**Files to modify:**
```
backend/resources/auth/generalAuthResource.js → Add refresh token generation
backend/resources/auth/otpResource.js         → Issue dual tokens post-OTP verification
```

---

## 25. Cloudinary Image Upload

### Source: MARKETPLACE (`utils/upload.js`, `middlewares/multer.js`), COSA-DB (Cloudinary in env + profile photo upload)

Both repos use Cloudinary. The current Smart Insti App uses local Multer storage (insufficient for production).

**What to borrow from MARKETPLACE `utils/upload.js`:**
```javascript
- uploadToCloudinary(localFilePath, folder)
  → Uses cloudinary.v2.uploader.upload()
  → Returns { url, public_id }
  → Deletes local temp file after upload

- deleteFromCloudinary(publicId)
  → Uses cloudinary.v2.uploader.destroy()
  → Call when listing is deleted or image replaced
```

**What to borrow from MARKETPLACE `middlewares/multer.js`:**
```javascript
- diskStorage to /tmp with random filename
- fileFilter: allow only image/jpeg, image/png, image/webp
- limits: fileSize 5MB
```

**Adaptation required:**
- Replace Smart Insti App's current `multerConfig.js` with this Cloudinary-aware pattern
- Apply to: profile pictures, achievement certificates, event images, complaint images, lost & found item images, marketplace listing images
- Add folders to Cloudinary by feature: `smart-insti/profiles`, `smart-insti/events`, `smart-insti/marketplace`, `smart-insti/achievements`, etc.
- Add to `.env`: `CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`

**Files to modify:**
```
backend/middlewares/multerConfig.js    → Replace with Cloudinary-aware version
backend/utils/cloudinary.js           → New file (upload/delete helpers)
```

**Dependency to add:**
```
npm install cloudinary
```

---

## 26. Email Utilities

### Source: MARKETPLACE (`users.controller.js` — password reset email with `mailgen`), COSA-DB (existing nodemailer for OTP)

**What to borrow from MARKETPLACE:**
```javascript
- Password Reset Email using mailgen for HTML templates
  → mailgen.generate({ body: { name, intro, action: {text, link}, outro } })
  → Creates professional branded HTML emails
  → sendPasswordResetEmail(user, resetURL)

- Email Verification Email (same mailgen pattern)
```

**Adaptation required:**
- Smart Insti App already has nodemailer for OTP; extend with mailgen for better HTML templates
- Add templates for: OTP email (improve current plain text), password reset, achievement verified, complaint resolved, item sold (marketplace)

**Dependency to add:**
```
npm install mailgen
```

---

## 27. Integration Priority Summary Table

| # | Feature | Source Repo | Priority | Effort | Notes |
|---|---------|------------|----------|--------|-------|
| 1 | Refresh Token System | MARKETPLACE | 🔴 Critical | Low | Prevents forced re-login |
| 2 | Cloudinary Image Upload | Both | 🔴 Critical | Low | Replace local Multer |
| 3 | Enhanced User/Student Model | MARKETPLACE + COSA-DB | 🔴 Critical | Medium | Unifies student schema |
| 4 | Marketplace Listings | MARKETPLACE | 🔴 Critical | Medium | Core marketplace feature |
| 5 | Marketplace Orders | MARKETPLACE | 🔴 Critical | Medium | Core marketplace feature |
| 6 | Private Chat / DMs | MARKETPLACE | 🔴 Critical | High | + Socket.io required |
| 7 | RBAC Middleware | COSA-DB | 🔴 Critical | Low | Replaces tokenRequired |
| 8 | Rich Event Schema | COSA-DB | 🟠 High | Medium | Adds RSVP, participants, room requests |
| 9 | Announcements (Targeted) | COSA-DB | 🟠 High | Low | Replaces flat broadcast |
| 10 | Notifications System | MARKETPLACE | 🟠 High | Medium | Powers notification bell |
| 11 | Skills with Endorsement | COSA-DB | 🟠 High | Medium | Replaces simple skill model |
| 12 | Achievements + Verification | COSA-DB | 🟠 High | Medium | Adds certificate + verified badge |
| 13 | Clubs / Org Units | COSA-DB | 🟠 High | Medium | Full clubs directory |
| 14 | Feedback System | COSA-DB | 🟠 High | Medium | Mess ratings, course feedback |
| 15 | Onboarding Flow | COSA-DB | 🟡 Medium | Low | Profile completion wizard |
| 16 | Positions of Responsibility | COSA-DB | 🟡 Medium | Medium | POR badges on profile |
| 17 | Analytics Dashboard | COSA-DB | 🟡 Medium | High | Role-aware stats |
| 18 | Google OAuth | Both (MARKETPLACE preferred) | 🟡 Medium | Low | Institute SSO |
| 19 | Vendor / Club Storefront | MARKETPLACE | 🟡 Medium | Medium | Club merch + food stalls |
| 20 | Wishlist | MARKETPLACE | 🟡 Medium | Low | Save marketplace items |
| 21 | Reviews & Ratings | MARKETPLACE | 🟡 Medium | Low | Seller trust system |
| 22 | Reports / Moderation | MARKETPLACE | 🟡 Medium | Low | Flag listings + campus posts |
| 23 | Activity Log | MARKETPLACE | 🟢 Low | Low | Admin audit trail |
| 24 | Room Booking via Events | COSA-DB | 🟢 Low | Low | Room request workflow |
| 25 | Email Templates (mailgen) | MARKETPLACE | 🟢 Low | Low | Better email UX |

---

## 28. Adaptation Notes & Caveats

### Module System
COSA-DB is CommonJS; Smart Insti App backend and MARKETPLACE are ESM. Every file borrowed from COSA-DB must be converted. Pattern:
- `const X = require('...')` → `import X from '...'`
- `module.exports = X` → `export default X`
- `module.exports = { A, B }` → `export { A, B }`

### Database Naming
COSA-DB uses `cosadatabase`; MARKETPLACE uses `campus-marketplace`; Smart Insti App uses the default. All three can point at the same MongoDB instance with different DB names. For Smart Insti App, use a single unified DB (`smart-insti-db`) with all collections in one namespace.

### Schema Merging — Student Model
The single biggest architectural decision is merging three user schemas:
- Smart Insti App `student.js`: rollNumber, about, profilePicURI, branch, graduationYear, skills[], achievements[], roles[]
- COSA-DB `userSchema`: personal_info subdoc, academic_info subdoc, onboardingComplete, strategy, status
- MARKETPLACE `users.model.js`: username, password, academicInfo subdoc, hostelLocation, phone, whatsapp, trustScore, refreshTokens[], preferences subdoc

The recommendation is to build a new unified `user.js` model that takes the best of all three.

### Institution-Specific Enums
Both external repos are built for IIT Bhilai. Verify the following before adopting:
- Hostel names: `['kanhar', 'Gopad', 'Indravati', 'Shivnath']` — update for your institution
- Department enum: `['CSE', 'ECE', 'ME', 'CE', 'EEE', 'MME', 'DSAI', 'BT', 'CHE']` — verify against your institute's departments
- Email domain: `@iitbhilai.ac.in` — change to your institution's domain throughout

### Don't Borrow
- **React frontends** from either repo — Smart Insti App uses Flutter
- **COSA-DB's Passport.js session-based auth** — prefer MARKETPLACE's token-based Google auth for mobile
- **MARKETPLACE's frontend components** (React/Vite) — Flutter equivalents are in UIUX.md
- **Docker compose files** — Smart Insti App has its own deployment setup
