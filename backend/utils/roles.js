export const ROLES = {
  PRESIDENT: 'president',
  GENSEC_SCITECH: 'gensec_scitech',
  GENSEC_ACADEMIC: 'gensec_academic',
  GENSEC_CULTURAL: 'gensec_cultural',
  GENSEC_SPORTS: 'gensec_sports',
  CLUB_COORDINATOR: 'club_coordinator',
  STUDENT: 'student',
  FACULTY: 'faculty',
  ALUMNI: 'alumni',
  ADMIN: 'admin'
};

export const ROLE_GROUPS = {
  ADMIN: ['president', 'gensec_scitech', 'gensec_academic', 'gensec_cultural', 'gensec_sports', 'admin'],
  GENSECS: ['gensec_scitech', 'gensec_academic', 'gensec_cultural', 'gensec_sports'],
  ALL: ['president', 'gensec_scitech', 'gensec_academic', 'gensec_cultural', 'gensec_sports', 'club_coordinator', 'student', 'faculty', 'alumni', 'admin']
};
