-- SQL Script to set up Mess Menu Tables
-- Designed for PostgreSQL / Supabase

-- Step 1: Create the table
CREATE TABLE IF NOT EXISTS mess_menu (
    id SERIAL PRIMARY KEY,
    day_of_week VARCHAR(15) NOT NULL, -- Monday, Tuesday, etc.
    meal_type VARCHAR(20) NOT NULL, -- Breakfast, Lunch, Snacks, Dinner
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    menu_items JSONB NOT NULL, -- JSON structure: { "Category": "Items" }
    week_parity INTEGER DEFAULT 1, -- 1 for odd weeks (1, 3), 2 for even weeks (2, 4)
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Ensure we don't have duplicate meal entries for the same day/week/meal
    CONSTRAINT unique_meal_per_day UNIQUE (day_of_week, meal_type, week_parity)
);

-- Step 2: Seed data from menu_jan.tsv (1st and 3rd Week)
-- Times:
-- Breakfast: 08:00:00 - 10:00:00
-- Lunch: 12:30:00 - 14:30:00
-- Snacks: 17:00:00 - 18:00:00
-- Dinner: 20:00:00 - 22:00:00

-- MONDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Monday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Poori + Potato Onion Masala",
    "Bread Items": "Coleslaw sandwich + Green Chutney",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Chocos",
    "Fruits": "Banana"
}', 1),
('Monday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Soya keema",
    "Dal": "Arhar dal + Jeera Tadka",
    "Rice": "Steam Rice",
    "Fryms": "Aplam",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "Curd ( 150gm)",
    "Fruits": "orange"
}', 1),
('Monday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Monday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Palak Paneer",
    "Dal": "Moong dal + Tadka",
    "Rice": "Peas Rice",
    "Breads": "Chapati( Ghee Roti )",
    "Salad": "Mixed-Salad",
    "Fryms": "Mix Papad",
    "Sweet": "Fruit Custard"
}', 1);

-- TUESDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Tuesday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Onion Uttapam+ Sambhar + Peanut Chutney",
    "Bread Items": "Bread (4 pcs) + Butter + Jam",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Cornflex",
    "Fruits": "sweet corn"
}', 1),
('Tuesday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Kadi Onion Pakoda + Onion Aloo Choka",
    "Dal": "Gongura Dal",
    "Rice": "Steam Rice",
    "Fryms": "Aplam",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "Buttermilk",
    "Fruits": "pear",
    "Chutney": "Pudina Chutney"
}', 1),
('Tuesday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Tuesday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Kathal Sabji",
    "Dal": "Arhar Dal + Jeera Tadka",
    "Rice": "Jeera Rice",
    "Breads": "Chapati(Ghee Roti )",
    "Salad": "Mixed-Salad",
    "Fryms": "Aplam",
    "Chutney": "Pudina Chutney",
    "Sweet": "Moong Dal Halwa"
}', 1);

-- WEDNESDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Wednesday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Aloo onion Paratha ( 2 + 1 ) + Pudina Chutney & Sauce + curd",
    "Bread Items": "Bread(4 pcs)+ Butter +Jam",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Muesli",
    "Fruits": "Banana"
}', 1),
('Wednesday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Lassoni corn palak curry",
    "Dal": "Arhar dal + jeera tadka",
    "Rice": "Jeera Rice",
    "Fryms": "Fryums",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "curd ( 150g )",
    "Fruits": "chiku"
}', 1),
('Wednesday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Wednesday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Panner Jalfrezzi",
    "Dal": "Moong Dal",
    "Rice": "Steam Rice",
    "Breads": "Chapati(Phulka )",
    "Salad": "Mixed-Salad",
    "Fryms": "Papad",
    "Rasam": "tomato soup",
    "Sweet": "Gulab Jamun (2 pcs)"
}', 1);

-- THURSDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Thursday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Idli+Vada+Coconut Chutney+Sambhar",
    "Bread Items": "Bread(4 pcs)+ Butter +Jam",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Chocos",
    "Fruits": "Banana"
}', 1),
('Thursday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Brocolli",
    "Dal": "Masoor dal",
    "Rice": "Steam Rice",
    "Fryms": "Aplam",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "Curd ( 150gm)",
    "Fruits": "gauava",
    "Rasam": "Sambhar"
}', 1),
('Thursday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Thursday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Aloo Methi + Palak",
    "Dal": "Rajma",
    "Rice": "Jeera Rice",
    "Breads": "Chapati (Ghee Roti )",
    "Salad": "Mixed-Salad",
    "Fryms": "Fryums",
    "Chutney": "Lasun Chutney",
    "Sweet": "sewai"
}', 1);

-- FRIDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Friday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Poha+ White Matar Curry + Onion cut + Tomato cut",
    "Bread Items": "Veg Corn Sandwich + Green Chutney",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Cornflex",
    "Fruits": "Banana"
}', 1),
('Friday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Sarso Saag",
    "Dal": "Chana Dal",
    "Rice": "Steam Rice",
    "Fryms": "Fryums",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "Curd ( 150gm)",
    "Fruits": "papaya",
    "Chutney": "Tomato+lasson Chutney"
}', 1),
('Friday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Friday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Shahi Paneer",
    "Dal": "Arhar Dal + Jeera Tadka",
    "Rice": "Steam Rice",
    "Breads": "Chapati(Phulka )",
    "Salad": "Mixed-Salad",
    "Fryms": "Aplam",
    "Rasam": "hot and sour soup",
    "Sweet": "Jalebi"
}', 1);

-- SATURDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Saturday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Ragi Dosa + Peanut Chutney + Sambhar",
    "Bread Items": "Bread(4 pcs)+ Butter +Jam",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Muesli",
    "Fruits": "Sprouts (germinated)"
}', 1),
('Saturday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Chole",
    "Dal": "NA",
    "Rice": "Veg Pulao",
    "Fryms": "Aplam",
    "Salad": "Mix-Salad",
    "Chapati": "Bhature",
    "Curd": "Mix - veg raita",
    "Fruits": "apples"
}', 1),
('Saturday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Saturday', 'Dinner', '20:00:00', '22:00:00', '{
    "Vegetable": "Mixed Veg Jalfrezi",
    "Dal": "Dal Makhni",
    "Rice": "Peas Rice",
    "Breads": "Chapati(Ghee Roti )",
    "Salad": "Mixed-Salad",
    "Fryms": "Fryums",
    "Sweet": "Kheer"
}', 1);

-- SUNDAY
INSERT INTO mess_menu (day_of_week, meal_type, start_time, end_time, menu_items, week_parity) VALUES
('Sunday', 'Breakfast', '08:00:00', '10:00:00', '{
    "Basic Meal Items": "Vegetable Pasta + Tomato Ketchup",
    "Bread Items": "Aaloo Sandwich + Green Chutney",
    "Beverages": "Tea + Milk + Coffee powder + Sugar",
    "Cereals": "Oats",
    "Fruits": "Sprouts (germinated)"
}', 1),
('Sunday', 'Lunch', '12:30:00', '14:30:00', '{
    "Vegetable": "Mixed veg",
    "Dal": "Musoor Dal",
    "Rice": "Steam Rice",
    "Fryms": "Fryums",
    "Salad": "Mix-Salad",
    "Chapati": "Chapati( Ghee Roti )",
    "Curd": "Curd ( 150gm)",
    "Fruits": "seasonal fruits",
    "Rasam": "Sambhar"
}', 1),
('Sunday', 'Snacks', '17:00:00', '18:00:00', '{
    "Beverages": "Tea + Milk (Coffee Powder + Bournvita)"
}', 1),
('Sunday', 'Dinner', '20:00:00', '22:00:00', '{
    "Special": "Paneer Dum Biryani + 1 additional scoop rice+ Onion Raita (150ml) + Gravy",
    "Salad": "Mixed-salad",
    "Sweet": "Sahi Tukda"
}', 1);
