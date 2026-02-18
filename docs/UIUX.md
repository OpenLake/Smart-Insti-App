# Smart Insti App — UI/UX Design Specification

> **Framework:** Flutter (Material Design 3 baseline with custom theme)
> **Design Philosophy:** Clean, campus-native, approachable for students of all backgrounds. Prioritize speed of information access over decoration. Use card-based layouts, generous whitespace, and a consistent color system.

---

## Table of Contents

1. [Design System](#1-design-system)
2. [Navigation Architecture](#2-navigation-architecture)
3. [Splash & Onboarding Screens](#3-splash--onboarding-screens)
4. [Authentication Screens](#4-authentication-screens)
5. [Home Dashboard](#5-home-dashboard)
6. [Student Profile Screens](#6-student-profile-screens)
7. [Faculty Directory & Profile](#7-faculty-directory--profile)
8. [Courses Screen](#8-courses-screen)
9. [Timetable Screens](#9-timetable-screens)
10. [Academic Calendar & Events](#10-academic-calendar--events)
11. [Mess Menu Screens](#11-mess-menu-screens)
12. [Lost & Found Screens](#12-lost--found-screens)
13. [Room Vacancy Screens](#13-room-vacancy-screens)
14. [Chat Room Screens](#14-chat-room-screens)
15. [Complaints Screen](#15-complaints-screen)
16. [Broadcast & Notifications](#16-broadcast--notifications)
17. [News & Announcements](#17-news--announcements)
18. [Quick Links Screen](#18-quick-links-screen)
19. [Confession Wall (New)](#19-confession-wall-new)
20. [Marketplace (New)](#20-marketplace-new)
21. [Study Resources (New)](#21-study-resources-new)
22. [Clubs & Societies (New)](#22-clubs--societies-new)
23. [Polls & Surveys (New)](#23-polls--surveys-new)
24. [Attendance Tracker (New)](#24-attendance-tracker-new)
25. [Alumni Network Screens](#25-alumni-network-screens)
26. [Admin Panel Screens](#26-admin-panel-screens)
27. [Settings Screen](#27-settings-screen)
28. [Component Library](#28-component-library)
29. [Motion & Animation Guidelines](#29-motion--animation-guidelines)
30. [Accessibility Guidelines](#30-accessibility-guidelines)

---

## 1. Design System

### 1.1 Color Palette

**Primary Brand Colors**
```
Primary:        #5B3482   (IIT Bhilai Purple — brand identity)
Primary Light:  #7C3AED   (Interactive elements, accents)
Primary Dark:   #4A2B69   (Headers, AppBar)
Secondary:      #1FA6E0   (OpenLake Blue — highlights, CTAs)
Secondary Light:#64B5F6
Secondary Dark: #0D2137   (Navy — text, backgrounds)
```

**Neutral System**
```
Background:     #F5F7FA   (Off-white — soft on eyes)
Surface:        #FFFFFF   (Cards, modals)
Surface Variant:#EEF2F8   (Alternate card backgrounds)
Divider:        #E0E6ED
On Background:  #1A1A2E   (Primary text)
On Surface Muted:#6B7A99  (Secondary text, labels)
```

**Semantic Colors**
```
Success:   #2E7D32   (Resolved complaints, available rooms)
Warning:   #F57F17   (Upcoming deadlines, low attendance)
Error:     #C62828   (Failed actions, urgent alerts)
Info:      #0277BD   (Informational banners)
```

**Section Accent Colors** (each major section gets a unique hue for instant visual recognition)
```
Timetable:      #7B1FA2   (Purple)
Mess Menu:      #E65100   (Deep Orange)
Lost & Found:   #00838F   (Teal)
Marketplace:    #2E7D32   (Green)
Confession:     #AD1457   (Pink)
Events:         #1565C0   (Blue)
Complaints:     #BF360C   (Red-Orange)
Chat:           #00695C   (Dark Teal)
```

### 1.2 Typography

**Font Family:** `Space Grotesk` (Headings) + `Inter` (Body) + `JetBrains Mono` (Code)

```
Display Large:   Space Grotesk 32sp / Bold — Section hero titles
Display Medium:  Space Grotesk 28sp / Bold — Screen titles
Headline Large:  Space Grotesk 24sp / SemiBold — Card headings
Headline Medium: Space Grotesk 20sp / SemiBold — Sub-section titles
Title Large:     Space Grotesk 18sp / Medium — List item titles
Title Medium:    Inter 16sp / Medium     — Button labels, labels
Body Large:      Inter 16sp / Regular    — Primary body text
Body Medium:     Inter 14sp / Regular    — Secondary body, descriptions
Body Small:      Inter 12sp / Regular    — Captions, timestamps, chips
Label:           Inter 11sp / Medium     — Tags, badges
Mono:            JetBrains Mono 13sp     — Roll numbers, codes
```

### 1.3 Spacing & Layout

```
xs:    4dp
sm:    8dp
md:    16dp
lg:    24dp
xl:    32dp
xxl:   48dp

Content padding:    16dp horizontal
Card inner padding: 16dp
List item height:   64–72dp (single line), 88–96dp (two-line)
AppBar height:      56dp
Bottom nav height:  64dp (+ system nav)
FAB margin:         16dp from bottom & right
Border radius:      8dp (cards), 12dp (bottom sheets), 24dp (FABs, chips)
```

### 1.4 Elevation & Shadows

```
Level 0: Flat (background)
Level 1: 2dp shadow (cards, list items)
Level 2: 4dp shadow (elevated cards, inline dialogs)
Level 3: 8dp shadow (modals, bottom sheets)
Level 4: 16dp shadow (full-screen dialogs, snack bars)
```

### 1.5 Iconography

Use **Material Symbols** (outlined style by default, filled on active/selected state). Each section has a dedicated icon:

```
Home            → home_outlined / home (active)
Timetable       → calendar_today_outlined
Mess            → restaurant_outlined
Lost & Found    → search_outlined
Events          → event_outlined
Chat            → chat_bubble_outline
Profile         → person_outline
Marketplace     → storefront_outlined
Confession      → lock_outline
Complaints      → report_problem_outlined
Clubs           → groups_outlined
Resources       → folder_open_outlined
Alumni          → school_outlined
Settings        → settings_outlined
```

---

## 2. Navigation Architecture

### 2.1 Primary Navigation: Persistent Bottom Navigation Bar

The bottom bar is always visible and contains 5 slots for quick access. The selection uses the section accent color fill + bold icon.

**Student Bottom Navigation:**
```
Tab 1: Home        (home icon)
Tab 2: Schedule    (calendar icon)
Tab 3: Community   (groups icon) — Chat, Confession, Marketplace
Tab 4: Campus      (location_city icon) — Mess, Lost & Found, Rooms
Tab 5: Profile     (person icon)
```

**Admin Bottom Navigation:**
```
Tab 1: Dashboard
Tab 2: Students
Tab 3: Faculty
Tab 4: Academics
Tab 5: Settings
```

### 2.2 Drawer Navigation (Additional Sections)

A left-side navigation drawer accessible via hamburger icon or swipe-right gesture contains secondary sections:
- Events & Calendar
- News & Announcements
- Complaints
- Quick Links
- Study Resources
- Clubs & Societies
- Alumni Network
- Polls & Surveys
- Attendance
- Broadcast
- Notifications
- Settings
- Logout

### 2.3 Route Transitions

- **Push (forward):** Slide from right (standard)
- **Pop (back):** Slide to right
- **Modal / Bottom Sheet:** Slide up
- **Tab Switch:** Fade (no slide, to avoid disorientation)
- **Hero animations:** Profile picture zooms into full view

---

## 3. Splash & Onboarding Screens

### 3.1 Splash Screen
**Layout:** Full-screen, Primary Dark background (#003C8F).

Center of screen: App logo (shield + graduation cap monogram, white) animates with a subtle scale-up from 0.8 → 1.0 over 600ms, then fades out. Below the logo: `Smart Insti` in Display Large white, `Your Campus. Simplified.` in Body Large, white at 70% opacity. At the bottom: animated loading indicator (three dots pulsing).

**Behavior:** Auto-transitions to role selection if no saved token. Navigates directly to the appropriate home screen if a valid JWT is found in secure storage.

---

### 3.2 Role Selection Screen
**Layout:** White background. Top 40%: illustrated banner image showing a campus building silhouette in the primary color family. Below: `Who are you?` in Headline Large centered. Four large role cards arranged in a 2×2 grid:

Each card is 150dp wide × 120dp tall, with rounded corners (12dp), a surface color background with a 1dp border in the role's accent color. The card contains a large 48dp icon (centered), the role name in Title Large below, and subtle press ripple.

```
[🎓 Student]    [👩‍🏫 Faculty]
[🏛️ Alumni]     [🔑 Admin]
```

**Behavior:** Tapping a card navigates to the corresponding login screen.

---

## 4. Authentication Screens

### 4.1 Student / Faculty / Alumni Login Screen

**Layout:**
- **AppBar:** Back arrow, title `Sign In` in Title Large
- **Background:** Gradient from Surface (#FFFFFF) to Surface Variant (#EEF2F8) from top to bottom

**Content (centered, max-width 360dp):**
1. Role badge chip at top (`Student`, `Faculty`, or `Alumni` with the respective icon in a rounded chip using the primary color)
2. `Welcome Back!` in Headline Large
3. `Enter your institute email to receive an OTP.` in Body Medium, muted color
4. Email text field (outlined, full-width):
   - Label: `Institute Email`
   - Keyboard type: email
   - Suffix: animated email icon → checkmark when valid
5. `Send OTP` button (Primary filled button, full width, 48dp height)
6. `New here? Register` text link below button

**Error states:**
- Invalid email: red border + `Please enter a valid email` helper text
- Email not found: snackbar `No account found with this email`

---

### 4.2 OTP Verification Screen

**Layout:**
- AppBar: Back arrow, title `Verify OTP`
- Centered content:
  1. Email confirmation text: `OTP sent to user@iit.ac.in` with a lock icon
  2. 4 large OTP input boxes (each 56×64dp) arranged horizontally, auto-advance on input, outlined style with primary color focus border
  3. `Verify` button (Primary filled, full width)
  4. Countdown timer: `Resend OTP in 0:45` — counts down; `Resend OTP` tap link appears when timer expires
  5. Back to email link

**Animation:** OTP boxes shake horizontally on incorrect OTP entry.

---

### 4.3 Admin Login Screen

**Layout:**
- Dark primary background (#003C8F) in the top 35% (decorative header)
- White card panel slides up from bottom (rounded top corners 24dp)
- Inside card:
  1. `Admin Portal` in Headline Large, centered
  2. `Secure Access Only` subtitle in Body Medium with a lock icon, muted
  3. Email field (outlined)
  4. Password field (outlined, with show/hide toggle)
  5. `Login` button (Primary filled, full width)
  6. Rate limit warning appears after 3 failed attempts: `2 attempts remaining`

---

### 4.4 Registration Screen (Student)

**Layout:** Scrollable form with sticky AppBar. Sections separated by `TextDivider` components.

**Section 1 — Account Info:**
- Email field (required)
- Roll Number field (mono font)

**Section 2 — Personal Info:**
- Full Name field
- Branch dropdown (CS, ECE, ME, CE, EE, etc.)
- Graduation Year picker (custom `YearPicker` component, scroll wheel, current year −4 to current year +1 range)

**Section 3 — Optional:**
- About / Bio (multiline, 4 lines, 200 char limit with counter)
- Profile picture URL field (with preview thumbnail)

**Bottom:** `Create Account` primary button.

---

## 5. Home Dashboard

### 5.1 Student Home Screen

**AppBar:**
- Left: Hamburger menu icon
- Center: `Smart Insti` logo + text
- Right: Notification bell (with badge count dot in Error red)

**Body (scrollable, `CustomScrollView` with `SliverAppBar` collapsing behavior):**

**A. Welcome Banner (top, collapsible):**
Height 120dp. Gradient background using Primary to Primary Light. Left-aligned greeting `Good Morning, [FirstName] 👋` in Headline Medium white. Below: small chips showing today's date and day.

**B. Today at a Glance (horizontal scroll strip):**
Row of 3 compact info cards (each ~160×80dp):

- **Next Class card:** Purple accent. Icon: school. Title: next subject name. Subtitle: time + room. Shows "No more classes" when schedule is done.
- **Today's Mess card:** Orange accent. Breakfast / Lunch / Dinner items in 1-line preview.
- **Room Status card:** Teal accent. Shows if room is occupied/vacant (relevant to user's room).

**C. Quick Actions Grid (2×4 grid of icon buttons):**
Each action is a small card (80×80dp) with a colored icon background (48×48dp), icon, and label below. Actions:
```
[Timetable]   [Mess Menu]
[Events]      [Lost & Found]
[Chatroom]    [Marketplace]
[Confession]  [Complaints]
```

**D. Upcoming Events (horizontal scroll card strip):**
Title: `📅 Upcoming Events` in Title Large with a "See All" link.
Cards (each 240×140dp): event image background (blurred overlay at bottom), event title in white Title Medium, date chip top-right.

**E. Latest News:**
Title: `📰 News & Announcements` with "See All".
2–3 news items as list tiles: leading image thumbnail (64×64dp), title, 1-line preview, timestamp chip.

**F. Broadcast Banner (if active broadcast):**
Dismissible info banner at the very top with Info blue background, megaphone icon, and broadcast message. Tap to expand full message.

---

### 5.2 Admin Home Dashboard

**AppBar:** `Admin Panel` title, profile avatar in the right.

**Content:**

**Stat Cards (2-column grid, each with gradient background):**
```
[Total Students: 842]    [Total Faculty: 67]
[Active Complaints: 12]  [Vacant Rooms: 34]
```
Each card: icon top-left, large number in Display Medium white, label in Body Small white at 80% opacity.

**Recent Activity Feed:** Chronological list of recent admin actions (student added, menu updated, complaint resolved) with timestamp.

**Quick Admin Actions (horizontal scroll strip):** Icon buttons for most-used admin tasks (Add Student, Update Menu, Manage Rooms, Create Event).

---

## 6. Student Profile Screens

### 6.1 Student Profile View

**Layout: Collapsing App Bar (`CollapsingAppBar` component)**

**Expanded header (height 260dp):**
- Gradient background using Primary Dark
- Centered: Circular profile picture (96dp diameter) with white 2dp border
- Name in Headline Large, white
- Roll Number in Mono Body Medium, white at 80% opacity
- Branch + Year chips (rounded, white at 20% alpha background)
- Edit button (outlined white button) top-right

**Body (scrollable below header):**

**About Section:** Card with `person_outline` icon, `About` title, and the student's bio text.

**Academics Section:** Card showing Branch, Year, Graduation Year in a 3-column info row.

**Skills Section:** Card with `stars_outline` icon. Skills displayed as a wrap of `RoundedChip` components, each showing the skill name and level as `SkillName · Lv.7`. Color: gradient from primary light to secondary light.

**Achievements Section:** Card with `emoji_events_outline` icon. Achievements as vertical list tiles: achievement icon/emoji, name in Title Medium, description in Body Small muted.

**Enrolled Courses (future):** Card showing course chips.

**Contact:** Card with email (tap to copy), LinkedIn link.

---

### 6.2 Edit Profile Screen

**Layout:** Scrollable form with sticky bottom `Save Changes` button.

**Profile Picture Section (top, centered):**
- Avatar (96dp) with an edit overlay (camera icon badge, bottom-right)
- Tap: bottom sheet with options `Take Photo`, `Choose from Gallery`, `Enter URL`

**Form Fields:**
- Display Name (pre-filled)
- About / Bio (multiline, 200 char limit)
- Branch (dropdown)
- Graduation Year (year picker)
- LinkedIn URL
- GitHub URL

**Skills Subsection:**
- Current skills shown as deletable chips
- `+ Add Skill` button opens bottom sheet with:
  - Skill name text field
  - Level slider (1–10) with numeric label
  - `Add` button

**Achievements Subsection:**
- List with delete (swipe left) and edit (tap)
- `+ Add Achievement` FAB opens a modal with title + description fields

---

### 6.3 Student Directory Screen

**AppBar:** `Students` title, search icon.

**Search Bar (collapsible from search icon):**
Full-width animated text field with department/year filter chips below.

**Filter Row:** Horizontally scrollable chips:
`All · CS · ECE · ME · CE · EE · 2025 · 2026`

**List:** Vertical list of student tiles:
- Leading: circular avatar (40dp)
- Title: Student name
- Subtitle: Roll number + Branch
- Trailing: `>` chevron

**Tap:** Navigates to the student's profile view.

---

## 7. Faculty Directory & Profile

### 7.1 Faculty Directory Screen

**AppBar:** `Faculty` title + search icon.

**Department Filter:** Horizontally scrollable filter chips (All, CSE, ECE, Maths, Physics, etc.)

**List:** Cards (one per department section, grouped). Each faculty tile:
- Leading: circular avatar (48dp) with department color ring
- Title: Prof. Name (Title Medium)
- Subtitle: Department + cabin number
- Trailing: email icon (tap to send email)

---

### 7.2 Faculty Profile Screen

**Header (same collapsing pattern as student profile):**
- Profile picture
- Full name + designation
- Department badge chip
- Cabin Number

**Courses Taught Section:** Card with course chips (each chip: course code + name).

**Contact Section:** Email row (tap to copy or launch mail app), cabin number.

**Office Hours (future):** Weekly availability grid in compact card.

---

## 8. Courses Screen

**AppBar:** `Courses` title + filter icon.

**Filter Bar:** Chips for branches (CS, ECE, ME…) + credits filter.

**List:** Course cards (each card):
- **Left accent bar:** uses the branch's color
- **Content:**
  - Course Code in Mono style, Body Small, muted top-left
  - Course Name in Title Large
  - Credits chip (right-aligned): `3 Credits` with a star icon
  - Professor name with a person icon, Body Medium
  - Primary Room (building icon, Body Medium)
  - Branch badges: wrap of small chips

**Tap:** Expands or navigates to Course Detail screen showing enrolled students, timetable slot, and materials (future).

---

## 9. Timetable Screens

### 9.1 Timetable List Screen

**AppBar:** `Timetables` title + `+` create button.

**Body:** Vertical list of user's saved timetables as cards:
- Title (timetable name) in Title Large
- Subtitle: number of slots, semester label
- Trailing: edit icon + delete icon
- Tap: opens Timetable View

**Empty State:** Illustration of an empty calendar + `No timetables yet` text + `Create your first timetable` button.

---

### 9.2 Timetable View Screen

**AppBar:** Timetable name, share icon, edit icon.

**Tab Bar (Monday → Saturday):** Today's tab is highlighted with the primary color.

**Grid Layout:**
- Left column (fixed, 80dp): time slots (e.g., `08:00 – 09:00`)
- Main columns: each day's subjects
- Current slot highlighted with a soft primary color fill + left border
- Empty slots shown as faint dashed outlines
- Subjects: card with subject name in Title Medium, room in Body Small, color-coded by subject (persistent hash-based color per subject name)

**Floating "What's Next" chip (bottom center):**
Appears only during class hours: `Next: Data Structures in 12 mins · Room B201`. Tapping dismisses.

---

### 9.3 Timetable Editor Screen

**AppBar:** `Edit Timetable`, save icon, done button.

**Configuration Panel (top, collapsible):**
- Timetable name field
- Days selector (toggle chips: M T W Th F Sa Su)
- Time range configurator: start/end time pickers per slot (add/remove slots with `+` / `−`)

**Grid Editor:**
Same grid layout as view, but each cell is tappable:
- Tap empty cell → bottom sheet to enter Subject + Room + optional notes
- Tap filled cell → sheet to edit or clear

---

## 10. Academic Calendar & Events

### 10.1 Events List Screen

**AppBar:** `Events` + filter icon.

**Banner (top, full-width):** Next upcoming event featured as a large hero card (200dp height) with blurred image background, gradient overlay, event title in Headline Large white, and date + location chips.

**Filter Row:** `All · Tech · Cultural · Sports · Academic · Workshop`

**Event Cards (below banner):**
Each card (full-width):
- Left: date column (70dp) — day number in Display Medium primary, month abbreviation in Label muted
- Right: event image (80dp square, rounded corners), title in Title Large, organizer, location chip, time chip

**FAB (admin only):** `+` to create a new event.

---

### 10.2 Event Detail Screen

**Hero:** Full-width image (240dp height) with parallax scroll effect. Title overlaid at bottom with a gradient-to-dark overlay.

**Content (scrollable below hero):**
- Event title in Headline Large
- Organizer name with verified badge
- Date + Time row (calendar icon + clock icon)
- Location row with map icon (tap to open maps)
- Description in Body Large
- `RSVP / Interested` button (secondary color, large, full-width)
- Attendee count: `47 people interested`
- Share button

---

### 10.3 Calendar Screen (New)

**AppBar:** `Calendar` + today button.

**Calendar Widget (top 40% of screen):**
Month view with colored dots below dates indicating events. Today's date: primary color circle. Selected date: filled circle. Event dots use section accent colors by category.

**Agenda List (bottom 60%, dynamic):**
Shows events for the selected date as cards. If no events: `No events today. Enjoy your day!` with a sun illustration.

**Month navigation:** Swipe left/right to change months.

---

## 11. Mess Menu Screens

### 11.1 Mess Menu Main Screen

**AppBar:** `Mess Menu` + kitchen selector dropdown (if multiple kitchens).

**Today Highlight Banner (top):**
Orange-accented card, date on left, day name right. Three meal sections in a horizontal 3-column layout (icons: 🌅 Breakfast, ☀️ Lunch, 🌙 Dinner). Each column: meal time chip + scrollable list of item names.

**Weekly View (below):**
`TabBar` with days (Mon → Sun). Today's tab has orange fill. Each tab shows the same 3-meal column layout for that day.

**Meal items rendered as:**
Simple text list within each column. Vegetarian items: green leaf icon prefix. Non-veg: red dot prefix (future).

**Rate Today's Meal button (bottom sticky):**
Opens a bottom sheet with star rating for each meal + optional comment.

---

## 12. Lost & Found Screens

### 12.1 Lost & Found Main Screen

**AppBar:** `Lost & Found` + post button (`+`).

**Toggle Tabs:** `Lost Items` | `Found Items` (segmented control, teal accent).

**List (grid, 2 columns):**
Each item card:
- Image (full card top, 140dp height, object-fit cover, placeholder if no image)
- Category chip overlay (top-left corner)
- Item name in Title Medium
- Location with pin icon in Body Small muted
- Date in Label
- Contact button (phone icon, tap to reveal or call)

**Search bar (collapsible from search icon).**

**Tap card:** Opens item detail screen.

---

### 12.2 Item Detail Screen

**Header:** Full-width image (250dp) with back button overlay.

**Content:**
- Status chip: `LOST` (red) or `FOUND` (green), prominent at top
- Item name in Headline Large
- Description in Body Large
- Last seen location with map pin icon
- Date posted
- `Contact [Name]` button — primary filled, full width

---

### 12.3 Post Lost / Found Item Screen

**AppBar:** `Report Item`.

**Toggle (top):** `I Lost Something` | `I Found Something` (segment).

**Form:**
- Item name field
- Description multiline field
- Last seen location field with location picker (map icon button)
- Date picker (calendar bottom sheet)
- Image upload: large dashed-border area (`+` icon, `Add Photo`) with preview once chosen
- Contact number field (phone keyboard)
- Category chips (select one): Electronics, Clothing, ID/Card, Keys, Books, Other

**Submit button (full-width, primary).**

---

## 13. Room Vacancy Screens

### 13.1 Room List Screen

**AppBar:** `Room Vacancy` + filter icon.

**Filter Row:** `All · Vacant · Occupied` (segment control).

**Stats Banner:** `34 Vacant / 210 Total` in a surface card with a simple bar progress indicator.

**List:** Room tiles:
- Room name/number in Title Medium
- Vacancy status chip: `Vacant` (success green) or `Occupied` (muted gray)
- If occupied: occupant name in Body Small, muted
- Trailing: `Apply` button (outlined, primary, only on vacant rooms) — currently placeholder

**Admin view:** Trailing has edit icon to manage occupant.

---

## 14. Chat Room Screens

### 14.1 Global Chat Room Screen

**AppBar:** `Campus Chat` + 🟢 online count chip (`142 online`).

**Message List (scrollable, reverse):**
- Own messages: right-aligned, primary color bubble, white text, rounded top-left/bottom corner
- Others' messages: left-aligned, surface variant bubble, avatar left (32dp), name label above in Label muted, Body Medium text
- Timestamp: small label below bubble, muted

**Typing Indicator:** `[Name] is typing...` with animated dots, shown above input bar.

**Input Bar (sticky bottom):**
- Row: avatar of sender (28dp, left) → text field (expandable, max 4 lines) → send button (primary FAB-style, 40dp circle)
- Image attach icon left of text field

**Date separator chips:** Center-aligned, `Today`, `Yesterday`, `18 Feb 2026` chips between messages.

---

### 14.2 Private Message Screen (New)

**AppBar:** Recipient avatar + name, online status dot, video/phone call icons (future).

**Same message bubble layout as global chat.**

**Input bar same as above.**

---

### 14.3 Chat List Screen (New)

**AppBar:** `Messages` + compose icon.

**Search bar (below AppBar).**

**Tab Row:** `Direct` | `Groups` | `Rooms`

**List:** Conversation tiles:
- Leading: avatar (48dp) with online dot (green, bottom-right)
- Title: contact/group name, Bold if unread
- Subtitle: last message preview (truncated to 1 line)
- Trailing: timestamp + unread badge count (red circle)

---

## 15. Complaints Screen

### 15.1 Complaints List Screen

**AppBar:** `Complaints` + `+` FAB.

**Tab Row:** `My Complaints` | `All Complaints`

**Filter chips:** `All · Pending · In Progress · Resolved · Rejected`

**Cards (each complaint):**
- Category chip (color-coded: Mess = orange, Hostel = teal, Academic = purple, Other = gray)
- Title in Title Large
- 2-line description preview
- Status chip (right): `Pending` (warning), `In Progress` (info), `Resolved` (success), `Rejected` (error)
- Upvote row: thumbs-up icon + count + `Upvote` text
- Timestamp and author name bottom-right
- Tap: opens complaint detail

---

### 15.2 Complaint Detail Screen

**Header:** Full-width complaint image (if attached, 200dp) or category-color banner.

**Content:**
- Category + Status chips (side by side)
- Title in Headline Large
- Full description
- Upvote button (large, full-width outlined)
- Filed by + date
- Activity Timeline (future): status change history with timestamps

---

### 15.3 File Complaint Screen

**AppBar:** `New Complaint`

**Form:**
- Title field
- Category chips (tap to select): Mess, Hostel Infrastructure, Academic, Other
- Description multiline (400 char limit with counter)
- Anonymous toggle switch: `Submit anonymously` with info icon → tooltip explaining anonymity
- Attach Image: same large dashed area as Lost & Found
- Submit button (full-width primary)

---

## 16. Broadcast & Notifications

### 16.1 Broadcast Screen

**AppBar:** `Announcements` (student view) | `Broadcasts` (admin view).

**Student View:** Chronological list of past broadcasts. Each item:
- Megaphone icon in a circle (primary background)
- Title and body text
- Timestamp
- Category chip (Academic, Hostel, Emergency)

**Emergency broadcasts:** Red background card, shake animation on arrival.

**Admin View (send broadcast):**
- Button `Send New Broadcast` at top opens bottom sheet
- Sheet contains: Title field, Message body (multiline), Category selector, `Send Now` button

---

### 16.2 Notification Center (New)

**AppBar:** `Notifications` + `Mark All Read` text button.

**Section Headers:** `Today`, `This Week`, `Earlier`

**Notification tiles:** Icon (section-specific), title Bold if unread, subtitle preview, timestamp, unread blue dot on left edge.

**Swipe Left:** Delete notification.
**Tap:** Navigate to relevant screen.

---

## 17. News & Announcements

### 17.1 News Feed Screen

**AppBar:** `News` + filter icon.

**Featured Post (top):** Large hero card (200dp height) with image background, gradient overlay, post type chip (News/Announcement/Achievement), title in Headline Large white.

**Filter chips:** `All · News · Announcements · Achievements`

**Post Cards (standard):**
- Thumbnail left (80dp square, rounded)
- Type chip (color-coded)
- Title in Title Large
- Author + date
- 2-line description
- Like button (heart icon + count)

---

### 17.2 Post Detail Screen

**Hero image (full-width, 260dp).**

**Content:**
- Type chip
- Title in Headline Large
- Author byline + timestamp
- Full body text (Body Large)
- Like + Share action row (horizontal divider above and below)
- Comments section (future)

---

## 18. Quick Links Screen

**AppBar:** `Quick Links`

**Category Sections (grouped):**
Section header: `🎓 Academic`, `🏠 Hostel`, `🎭 Club`, `🔗 Other`

**Grid (2 columns) within each section:**
Each link tile (card, 80dp height):
- Leading icon (48dp colored circle background with the link's icon)
- Link title (Title Medium)
- Tap: opens URL in in-app WebView or external browser (with option sheet)

---

## 19. Confession Wall (New)

**AppBar:** `Confession Wall` + info icon (taps to show community guidelines).

**Header Banner:** Soft pink/purple gradient with a lock icon. Text: `Anonymous. Safe. Yours.`

**Sort/Filter Row:** `Latest · Trending · My Posts`

**Category chips (horizontal scroll):** `All · Academic Stress · Crush · Funny · Rant · Advice · General`

**Confession Feed (vertical cards):**
Each confession card:
- **No name / avatar shown** — replaced by random anonymous avatar (auto-generated geometric pattern avatar using post ID as seed)
- Category chip (top-right)
- Confession text (Body Large, max 5 lines with `Read more` expand)
- Time ago label (e.g., `2 hours ago`)
- Reaction row: 👍 Like count · 😂 Haha · 😢 Sad · 🔥 Relatable
- Reply count chip (tap to expand inline replies)
- Report flag icon (far right, small)

**FAB (bottom-right):** Quill pen icon `Confess`

**New Confession Bottom Sheet (opens from FAB):**
- Category selector (chip grid, must choose one)
- Text area (max 500 chars with counter)
- Switches: `Show replies` / `Sensitive content warning`
- Disclaimer text: `Your identity is never revealed.`
- `Post Anonymously` primary button

**Tap on confession:** Opens thread view (same card at top + replies below in a nested list).

---

## 20. Marketplace (New)

### 20.1 Marketplace Main Screen

**AppBar:** `Marketplace` + search icon + cart/wishlist icon.

**Header:** Soft green gradient banner. Tagline: `Buy · Sell · Give away on campus`.

**Category Icon Row (horizontal scroll):**
Large icon chips (48dp icon + label below): `📚 Books · 💻 Electronics · 👕 Clothing · 🪑 Furniture · 🎮 Games · 🎁 Free · 📦 Other`

**Featured Listings (horizontal scroll strip):** 3–4 featured item cards (180×220dp each):
- Image (top 120dp, cover)
- Item name
- Price in Title Large (green for free items)
- Condition chip (bottom-right)

**Recent Listings (grid, 2 columns):**
Same card format (compact). Pagination via infinite scroll.

**FAB:** `+ List an Item`

---

### 20.2 Item Detail Screen

**Image Gallery:** Swipeable full-width image carousel with page dots (max 5 images).

**Content:**
- Price in Display Medium (green = free)
- Item title in Headline Large
- Condition chip + Category chip
- Description (expandable Body Large text)
- Seller info row: avatar, name, `Member since [year]`, rating stars
- Location pickup point (map pin icon)
- Posted date
- Action Row: `💬 Chat with Seller` (primary button) · `❤️ Wishlist` (outlined button)

**Safety notice banner (amber):** `Always meet in public areas on campus.`

---

### 20.3 Post Listing Screen

**AppBar:** `List an Item`

**Form:**
- Image upload area (3-image grid, each tap-to-upload)
- Title field
- Category selector (icon chips grid)
- Condition selector (chip row): New · Like New · Good · Fair · Poor
- Price field (number keyboard) + `Free` toggle switch
- Description multiline
- Pickup location field
- Post button (full-width primary)

---

## 21. Study Resources (New)

### 21.1 Resources Main Screen

**AppBar:** `Study Resources` + search + upload icon.

**Tab Row:** `All · Notes · PYQs · Books · Syllabus`

**Course Filter:** Dropdown `Filter by Course` shows all course codes.

**Resource Cards (list):**
- File type icon (PDF = red, DOC = blue, PPT = orange, large 40dp)
- Resource name in Title Medium
- Course name + semester in Body Small muted
- Uploader name (anonymous option) + upload date
- Download count badge + Upvote count
- Download button (icon button, right)

**FAB:** `+` Upload Resource

**Tap card:** Opens resource detail / viewer (PDF preview in-app).

---

## 22. Clubs & Societies (New)

### 22.1 Clubs Directory

**AppBar:** `Clubs & Societies`

**Domain Filter chips:** Tech · Cultural · Sports · Arts · Social · Academic

**Club Cards (full-width):**
- Cover banner image (top 80dp, colored gradient fallback)
- Club logo circle (overlapping bottom of banner)
- Club name in Title Large
- Domain badge chip
- 1-line tagline in Body Small muted
- Member count (`142 members`)
- `Join` button (outlined primary) / `Member ✓` (filled, muted, if already joined)

**Tap:** Opens Club Profile Screen.

---

### 22.2 Club Profile Screen

**Hero:** Club banner image (200dp) + club logo circle (overlapping hero bottom).

**Content:**
- Club name in Headline Large
- Tagline
- Domain chip
- About section
- Members count + core team section (3–4 member avatars with names)
- Events tab (shows club's past and upcoming events)
- Gallery tab (grid of photos)
- Announcements tab (club-specific news)
- Join / Leave button (sticky bottom)

---

## 23. Polls & Surveys (New)

### 23.1 Polls List Screen

**AppBar:** `Polls & Surveys`

**Filter:** `Active · Closed · My Votes`

**Poll Cards:**
- Poll question in Title Large
- Created by (faculty/admin name + avatar)
- Progress bar for days remaining (or `Closed` chip)
- Options with vote bars (revealed after voting or when closed)
- `Vote` CTA if not yet voted (primary outlined button)

**Closed poll:** Bars shown with percentages. Winning option has a filled bar in primary color.

---

## 24. Attendance Tracker (New)

### 24.1 Attendance Dashboard

**AppBar:** `Attendance`

**Attendance Summary Card (top):**
Large circular gauge showing overall attendance percentage. Color: green > 75%, amber 60–75%, red < 60%.

**Course-wise List:**
Each course row:
- Course name
- Mini horizontal bar: present / total
- Percentage (right-aligned)
- Color indicator (green/amber/red based on threshold)
- `At Risk ⚠️` tag if below 75%

**Calendar Heatmap (bottom):** Small month grid with dots showing attended (green) and missed (red) days per course.

---

## 25. Alumni Network Screens

### 25.1 Alumni Directory

**AppBar:** `Alumni Network`

**Filter:** Batch year picker, department dropdown.

**Alumni Cards:**
- Avatar
- Name + designation
- Current organization
- Graduation year chip
- LinkedIn icon (tap to open)
- `Connect` button (future)

---

## 26. Admin Panel Screens

### 26.1 Admin Home

*(Described in Section 5.2)*

---

### 26.2 Manage Students Screen

**AppBar:** `Students` + `+` add button + search icon.

**Stats row:** `Total: 842 · CS: 312 · ECE: 198 · ME: 156 · Other: 176`

**Search bar (always visible at top).**

**Filter:** Branch filter chips.

**List:** Student rows (same as directory). Swipe left: delete. Tap: edit student details.

**Add Student Screen:**
Full form (same as registration form) with admin-specific fields (roll number forced, branch dropdown). `Add Student` button at bottom. Bulk import: `Upload CSV` button above form opens file picker.

---

### 26.3 Manage Faculty Screen

Same layout pattern as students. `Add Faculty` form: name, email, department, cabin number, assign courses (multi-select chip picker).

---

### 26.4 Manage Courses Screen

**Courses list** with course code, name, professor, credits. Swipe delete, tap edit.

**Add Course Form:** Name, code (auto uppercase), credits (number field), primary room, professor dropdown, branches multi-select.

---

### 26.5 Manage Mess Menu Screen

**AppBar:** `Mess Menu` + `Add Week` button.

**Kitchen selector at top** (if multiple kitchens).

**Week grid editor:** 7-day × 4-meal grid (Breakfast, Lunch, Snacks, Dinner). Each cell is a tappable chip list. Tap cell → bottom sheet with multiline text area for that meal's items (one item per line).

---

### 26.6 Manage Rooms Screen

**AppBar:** `Rooms` + `+` add room.

**Stats:** `Vacant: 34 / 210 total` progress bar.

**List:** Room tiles with quick toggle switch for vacancy status. Tap to assign/unassign occupant (student search picker).

---

### 26.7 Admin Complaint Management (New)

**AppBar:** `Complaints` + filter icon.

**Kanban-style tabs or list:** `Pending (12) · In Progress (5) · Resolved (34) · Rejected (3)`

**Each complaint tile:** Title, category, student name, date filed, upvote count. Trailing: status dropdown picker.

**Tap complaint:** Full detail + status change button + admin note field (private).

---

## 27. Settings Screen

**AppBar:** `Settings`

**User Profile Mini-Card (top):** Avatar, name, email, `Edit Profile` button.

**Sections (grouped List Tiles with dividers):**

**Appearance:**
- Dark Mode toggle switch
- Font size slider (Small / Medium / Large)
- Theme color picker (primary accent selector)

**Notifications:**
- Push notifications master toggle
- Per-category toggles: Events, Broadcasts, Chat, News, Complaints

**Account:**
- Change Email (navigates to form)
- Privacy Settings
- Delete Account (destructive, confirmation dialog)

**App:**
- App Version (`v2.0.1 (build 42)`)
- Privacy Policy (external link)
- Terms of Service (external link)
- Rate the App (opens store)
- Send Feedback

**Support:**
- Help Center
- Report a Bug

**Logout button (full-width, outlined error-color button, bottom).**

---

## 28. Component Library

### 28.1 RoundedChip
Small pill-shaped container. Variants: outlined (border + colored text), filled (colored background + white text), tonal (light color background + dark text). Props: label, color, icon (optional), onTap.

### 28.2 SectionCard
Standardized card container with:
- Left-side colored accent bar (4dp wide, section color)
- Title row with icon and section heading
- Content slot
- Optional "See All" trailing link

### 28.3 SkillBar
Horizontal bar visualization for a skill (level 1–10). Background: light gray bar, foreground: gradient fill width = (level/10)*100%.

### 28.4 AvatarGroup
Row of overlapping circular avatars (used in events "interested" count, club members). Shows up to 5 then `+N more`.

### 28.5 StatusBadge
Small rounded rectangle. Color + text by status type: Pending (amber), In Progress (blue), Resolved (green), Rejected (red).

### 28.6 EmptyState
Centered illustration (SVG/Lottie animation) + heading + subtitle + optional CTA button. Used on all empty list screens.

### 28.7 SkeletonLoader
Shimmer-effect placeholder for list items during loading. Matches exact shape of real content cards to minimize layout shift.

### 28.8 ConfirmDialog
Standard Material-style confirmation dialog for destructive actions (delete, logout). Two buttons: `Cancel` (text button) + `Confirm` (filled button in error color).

### 28.9 BottomSheetForm
Draggable bottom sheet template. Has a handle bar at top, title row, scrollable form content area, and sticky action button at bottom. Drag down to dismiss.

### 28.10 ImageTile
Aspect-ratio-locked image container (default 16:9) with rounded corners, loading shimmer, and fallback icon on error.

---

## 29. Motion & Animation Guidelines

### Principles
1. **Purposeful** — animation must convey meaning (transition, state change), not decoration
2. **Fast** — most micro-interactions complete in 150–250ms; page transitions in 300ms max
3. **Natural** — use spring curves for physics-based motion; ease-in-out for controlled transitions

### Timing Tokens
```
Instant:    0ms    (toggle states with no animation needed)
Quick:      150ms  (hover effects, ripples, chip selection)
Standard:   250ms  (list item appear/disappear, snackbar)
Deliberate: 350ms  (screen transitions, sheet open/close)
Complex:    500ms  (hero animations, onboarding reveals)
```

### Animation Patterns
- **List item entry:** Slide + fade in from bottom (staggered, 50ms offset per item)
- **Card tap:** Slight scale-down (0.97) then spring back on release
- **FAB transition:** Expand from circle to full-width button on scroll stop
- **Screen forward:** Slide right + fade in new screen; old screen scales to 0.95 and fades
- **Modal open:** Sheet slides up with spring curve (stiffness 300, damping 30)
- **Dismissal:** Swipe gesture with momentum-based velocity tracking
- **Error shake:** Horizontal oscillation (3 cycles, decreasing amplitude, 400ms total)
- **Success:** Checkmark draws itself with a stroke animation, then bounces

---

## 30. Accessibility Guidelines

### Color & Contrast
- All text must meet WCAG AA contrast ratio: 4.5:1 for normal text, 3:1 for large text
- Never use color alone to convey meaning (always pair with icon or text label)
- Status badges: always include text label, not just color

### Touch Targets
- Minimum interactive element size: 48×48dp
- Minimum spacing between touch targets: 8dp
- Avoid placing interactive elements within 16dp of screen edges (except standard nav elements)

### Typography
- Support system font size scaling (Flutter's `textScaleFactor` must be respected)
- Test UI at 1.5× and 2.0× text scale — no content clipping

### Screen Reader Support
- All images must have `Semantics` labels (Flutter `Semantics` widget)
- Custom widgets must provide meaningful accessibility descriptions
- Navigation actions must be announced (screen + purpose)
- Loading states must announce: `Loading [section name]...` and `[Section name] loaded.`

### Motor Accessibility
- All swipe-to-delete actions must have alternative long-press menu
- All floating actions must have keyboard-accessible alternatives
- Minimum tap target padding applied universally to custom components

### Cognitive Accessibility
- Limit choices in a single view (max 7±2 items in filter lists; group beyond that)
- Progress indicators for all multi-step flows (onboarding, complaint filing, item posting)
- Destructive actions always require explicit confirmation
- Form field errors appear inline, not in a distant snackbar
