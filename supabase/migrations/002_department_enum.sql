-- Create the department enum type
CREATE TYPE public.department_type AS ENUM (
  'Computer Science and Engineering',
  'Data Science and Artificial Intelligence',
  'Electronics and Communication Engineering',
  'Electrical Engineering',
  'Electric Vehicle Technology',
  'Mechanical Engineering',
  'Mechatronics Engineering',
  'Materials Science and Metallurgical Engineering',
  'Physics',
  'Mathematics',
  'Chemistry',
  'Bioscience and Biomedical Engineering',
  'Liberal Arts'
);

-- Convert the department column from TEXT to the enum
ALTER TABLE public.profiles
  ALTER COLUMN department TYPE public.department_type
  USING department::public.department_type;
