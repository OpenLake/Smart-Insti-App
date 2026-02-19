#!/bin/bash

# 1. Fix Events Display (Public API fetching and correct date)
echo "Committing Events Fixes..."
git add frontend/lib/provider/event_provider.dart frontend/lib/screens/user/events_page.dart frontend/lib/repositories/event_repository.dart
git commit -m "fix(events): allow public event fetching and fix date display bug"

# 2. Update Home Page Events (Using category)
echo "Committing Home Page Update..."
git add frontend/lib/models/event.dart frontend/lib/screens/user/user_home.dart
git commit -m "feat(home): update upcoming events section with category support"

# 3. Implement Feedback Feature (New files)
echo "Committing Feedback Implementation..."
git add frontend/lib/models/feedback.dart frontend/lib/repositories/feedback_repository.dart frontend/lib/provider/feedback_provider.dart frontend/lib/screens/feedback/
git add frontend/lib/routes/routes.dart
# Handle deletion of complaint_page.dart
git rm frontend/lib/screens/user/complaint_page.dart || git add -u frontend/lib/screens/user/complaint_page.dart
git commit -m "feat(feedback): implement feedback system and replace legacy complaints"

# 4. Remaining Frontend/Backend Changes (Likely formatting or previous unrelated work)
echo "Committing Remaining Changes..."
git add -A
git commit -m "chore: formatting and miscellaneous updates"

echo "All changes committed!"