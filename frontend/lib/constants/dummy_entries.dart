import '../models/course.dart';
import '../models/faculty.dart';
import '../models/mess_menu.dart';
import '../models/room.dart';
import '../models/student.dart';

class DummyStudents {
  static List<Student> students = [
    Student(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      rollNumber: 'R001',
      about: 'I am a computer science student.',
      profilePicURI: 'https://example.com/john.jpg',
      branch: 'Computer Science',
      graduationYear: 2023,
      skills: [],
      achievements: [],
      roles: ['role1', 'role2'],
    ),
    Student(
      id: '2',
      name: 'John Doe',
      email: 'john.doe@example.com',
      rollNumber: 'R001',
      about: 'I am a computer science student.',
      profilePicURI: 'https://example.com/john.jpg',
      branch: 'Computer Science',
      graduationYear: 2023,
      skills: [],
      achievements: [],
      roles: ['role1', 'role2'],
    ),
    Student(
      id: '3',
      name: 'John Doe',
      email: 'john.doe@example.com',
      rollNumber: 'R001',
      about: 'I am a computer science student.',
      profilePicURI: 'https://example.com/john.jpg',
      branch: 'Computer Science',
      graduationYear: 2023,
      skills: [],
      achievements: [],
      roles: ['role1', 'role2'],
    ),
    Student(
      id: '4',
      name: 'John Doe',
      email: 'john.doe@example.com',
      rollNumber: 'R001',
      about: 'I am a computer science student.',
      profilePicURI: 'https://example.com/john.jpg',
      branch: 'Computer Science',
      graduationYear: 2023,
      skills: [],
      achievements: [],
      roles: ['role1', 'role2'],
    ),
    Student(
      id: '5',
      name: 'John Doe',
      email: 'john.doe@example.com',
      rollNumber: 'R001',
      about: 'I am a computer science student.',
      profilePicURI: 'https://example.com/john.jpg',
      branch: 'Computer Science',
      graduationYear: 2023,
      skills: [],
      achievements: [],
      roles: ['role1', 'role2'],
    ),
  ];
}

class DummyCourses {
  static List<Course> courses = [
    Course(
        id: '1',
        courseCode: 'CS101',
        courseName: 'Introduction to Computer Science',
        branches: ['Computer Science']),
    Course(
        id: '2',
        courseCode: 'ME102',
        courseName: 'Mechanical Engineering Basics',
        branches: ['Mechanical Engineering']),
    Course(
        id: '3',
        courseCode: 'EE103',
        courseName: 'Electrical Engineering Fundamentals',
        branches: ['Electrical Engineering']),
    Course(
        id: '4',
        courseCode: 'EE104',
        courseName: 'Civil Engineering Principles',
        branches: ['Civil Engineering']),
    Course(
        id: '5',
        courseCode: 'CHE105',
        courseName: 'Chemical Engineering Basics',
        branches: ['Chemical Engineering']),
    Course(
        id: '6',
        courseCode: 'BT106',
        courseName: 'Biotechnology Fundamentals',
        branches: ['Biotechnology']),
    Course(
        id: '7',
        courseCode: 'AE107',
        courseName: 'Aerospace Engineering Introduction',
        branches: ['Aerospace Engineering']),
    Course(
        id: '8',
        courseCode: 'IT108',
        courseName: 'Information Technology Essentials',
        branches: ['Information Technology']),
    Course(
        id: '9',
        courseCode: 'MT109',
        courseName: 'Mechatronics Basics',
        branches: ['Mechatronics']),
    Course(
        id: '10',
        courseCode: 'RE110',
        courseName: 'Robotics Engineering Fundamentals',
        branches: ['Robotics Engineering']),
    Course(
        id: '11',
        courseCode: 'IE111',
        courseName: 'Industrial Engineering Principles',
        branches: ['Industrial Engineering']),
    Course(
        id: '12',
        courseCode: 'CE112',
        courseName: 'Computer Engineering Basics',
        branches: ['Computer Engineering']),
    Course(
        id: '13',
        courseCode: 'SE113',
        courseName: 'Software Engineering Fundamentals',
        branches: ['Software Engineering']),
    Course(
        id: '14',
        courseCode: 'EN114',
        courseName: 'Environmental Engineering Basics',
        branches: ['Environmental Engineering']),
    Course(
        id: '15',
        courseCode: 'PE115',
        courseName: 'Petroleum Engineering Introduction',
        branches: ['Petroleum Engineering']),
    Course(
        id: '16',
        courseCode: 'NE116',
        courseName: 'Nuclear Engineering Basics',
        branches: ['Nuclear Engineering']),
    Course(
        id: '17',
        courseCode: 'BE117',
        courseName: 'Biomedical Engineering Fundamentals',
        branches: ['Biomedical Engineering']),
    Course(
        id: '18',
        courseCode: 'CE118',
        courseName: 'Chemical Engineering Principles',
        branches: ['Chemical Engineering']),
    Course(
        id: '19',
        courseCode: 'EE119',
        courseName: 'Electronics Engineering Basics',
        branches: ['Electronics Engineering']),
    Course(
        id: '20',
        courseCode: 'CS120',
        courseName: 'Advanced Computer Science Topics',
        branches: ['Computer Science']),
  ];
}

class DummyFaculties {
  static List<Faculty> faculties = [
    Faculty(id: '1', name: 'Dr. Smith', email: 'smith@example.com', courses: [
      DummyCourses.courses[0],
      DummyCourses.courses[5],
      DummyCourses.courses[10],
    ]),
    Faculty(
        id: '2',
        name: 'Prof. Johnson',
        email: 'johnson@example.com',
        courses: [
          DummyCourses.courses[1],
          DummyCourses.courses[6],
          DummyCourses.courses[11]
        ]),
    Faculty(id: '3', name: 'Dr. Brown', email: 'brown@example.com', courses: [
      DummyCourses.courses[2],
      DummyCourses.courses[7],
      DummyCourses.courses[12]
    ]),
    Faculty(id: '4', name: 'Prof. Davis', email: 'davis@example.com', courses: [
      DummyCourses.courses[3],
      DummyCourses.courses[8],
      DummyCourses.courses[13]
    ]),
    Faculty(id: '5', name: 'Dr. Wilson', email: 'wilson@example.com', courses: [
      DummyCourses.courses[4],
      DummyCourses.courses[9],
      DummyCourses.courses[14]
    ]),
    Faculty(
        id: '6',
        name: 'Prof. Miller',
        email: 'miller@example.com',
        courses: [
          DummyCourses.courses[0],
          DummyCourses.courses[5],
          DummyCourses.courses[10]
        ]),
    Faculty(id: '7', name: 'Dr. Turner', email: 'turner@example.com', courses: [
      DummyCourses.courses[1],
      DummyCourses.courses[6],
      DummyCourses.courses[11]
    ]),
    Faculty(id: '8', name: 'Prof. Clark', email: 'clark@example.com', courses: [
      DummyCourses.courses[2],
      DummyCourses.courses[7],
      DummyCourses.courses[12]
    ]),
    Faculty(id: '9', name: 'Dr. Harris', email: 'harris@example.com', courses: [
      DummyCourses.courses[3],
      DummyCourses.courses[8],
      DummyCourses.courses[13]
    ]),
    Faculty(
        id: '10',
        name: 'Prof. Turner',
        email: 'turner@example.com',
        courses: [
          DummyCourses.courses[4],
          DummyCourses.courses[9],
          DummyCourses.courses[14]
        ]),
    Faculty(id: '11', name: 'Dr. White', email: 'white@example.com', courses: [
      DummyCourses.courses[0],
      DummyCourses.courses[5],
      DummyCourses.courses[10]
    ]),
    Faculty(
        id: '12',
        name: 'Prof. Allen',
        email: 'allen@example.com',
        courses: [
          DummyCourses.courses[1],
          DummyCourses.courses[6],
          DummyCourses.courses[11]
        ]),
    Faculty(id: '13', name: 'Dr. Young', email: 'young@example.com', courses: [
      DummyCourses.courses[2],
      DummyCourses.courses[7],
      DummyCourses.courses[12]
    ]),
    Faculty(
        id: '14',
        name: 'Prof. Walker',
        email: 'walker@example.com',
        courses: [
          DummyCourses.courses[3],
          DummyCourses.courses[8],
          DummyCourses.courses[13]
        ]),
    Faculty(id: '15', name: 'Dr. Lee', email: 'lee@example.com', courses: [
      DummyCourses.courses[4],
      DummyCourses.courses[9],
      DummyCourses.courses[14]
    ]),
    Faculty(id: '16', name: 'Prof. Hall', email: 'hall@example.com', courses: [
      DummyCourses.courses[0],
      DummyCourses.courses[5],
      DummyCourses.courses[10]
    ]),
    Faculty(
        id: '17',
        name: 'Dr. Miller',
        email: 'miller@example.com',
        courses: [
          DummyCourses.courses[1],
          DummyCourses.courses[6],
          DummyCourses.courses[11]
        ]),
    Faculty(
        id: '18',
        name: 'Prof. Baker',
        email: 'baker@example.com',
        courses: [
          DummyCourses.courses[2],
          DummyCourses.courses[7],
          DummyCourses.courses[12]
        ]),
    Faculty(
        id: '19',
        name: 'Dr. Turner',
        email: 'turner@example.com',
        courses: [
          DummyCourses.courses[3],
          DummyCourses.courses[8],
          DummyCourses.courses[13]
        ]),
    Faculty(
        id: '20',
        name: 'Prof. Smith',
        email: 'smith@example.com',
        courses: [
          DummyCourses.courses[4],
          DummyCourses.courses[9],
          DummyCourses.courses[14]
        ]),
  ];
}

class DummyMenus {
  static Map<String, MessMenu> messMenus = {
    'GrandKitchen': MessMenu(
      id: '1',
      kitchenName: 'GrandKitchen',
      messMenu: {
        'Sunday': {
          'Breakfast': ['Blueberry Pancakes', 'Eggs Benedict'],
          'Lunch': ['Roast Chicken', 'Mashed Potatoes'],
          'Dinner': ['Salmon Piccata', 'Caprese Salad'],
          'Snacks': ['Chef\'s Gourmet Delight'],
        },
        'Monday': {
          'Breakfast': ['Belgian Waffles', 'Fruit Parfait'],
          'Lunch': ['Spicy Beef Tacos', 'Cilantro Lime Rice'],
          'Dinner': ['Grilled Swordfish', 'Quinoa Salad'],
          'Snacks': ['Decadent Chocolate Desserts'],
        },
        'Tuesday': {
          'Breakfast': ['Bagels and Lox', 'Greek Yogurt'],
          'Lunch': ['Pesto Pasta', 'Garlic Bread'],
          'Dinner': ['Lemon Herb Chicken', 'Roasted Vegetables'],
          'Snacks': ['Mediterranean Night'],
        },
        'Wednesday': {
          'Breakfast': ['Cinnamon Rolls', 'Fresh Fruit Smoothies'],
          'Lunch': ['Shrimp Pad Thai', 'Spring Rolls'],
          'Dinner': ['Prime Rib', 'Loaded Baked Potatoes'],
          'Snacks': ['International Buffet'],
        },
        'Thursday': {
          'Breakfast': ['Omelette Bar', 'Hash Browns'],
          'Lunch': ['Chicken Caesar Salad', 'Grilled Asparagus'],
          'Dinner': ['Sushi Platter', 'Edamame'],
          'Snacks': ['Sushi Extravaganza'],
        },
        'Friday': {
          'Breakfast': ['Pancetta Frittata', 'Fresh Squeezed Juice'],
          'Lunch': ['Margherita Pizza', 'Caesar Salad'],
          'Dinner': ['Lobster Tail', 'Vegetable Stir-Fry'],
          'Snacks': ['Seafood Feast'],
        },
        'Saturday': {
          'Breakfast': ['French Toast', 'Mixed Berry Compote'],
          'Lunch': ['Caprese Panini', 'Sweet Potato Fries'],
          'Dinner': ['Filet Mignon', 'Brussels Sprouts'],
          'Snacks': ['Steakhouse Night'],
        },
      },
    ),
    'RoyalCuisine': MessMenu(
      id: '2',
      kitchenName: 'RoyalCuisine',
      messMenu: {
        'Sunday': {
          'Breakfast': ['Croissants', 'Fresh Berries'],
          'Lunch': ['Chicken Marsala', 'Truffle Risotto'],
          'Dinner': ['Seared Scallops', 'Greek Salad'],
          'Snacks': ['Royal Feast'],
        },
        'Monday': {
          'Breakfast': ['Scones', 'Clotted Cream'],
          'Lunch': ['Beef Wellington', 'Creamed Spinach'],
          'Dinner': ['Lobster Risotto', 'Caesar Salad'],
          'Snacks': ['Luxurious Dessert Selection'],
        },
        'Tuesday': {
          'Breakfast': ['Peach Danish', 'Yogurt Parfait'],
          'Lunch': ['Lemon Herb Roast Chicken', 'Wild Rice Pilaf'],
          'Dinner': ['Pan-Seared Duck Breast', 'Cranberry Walnut Salad'],
          'Snacks': ['Fine Dining Experience'],
        },
        'Wednesday': {
          'Breakfast': ['Danish Pastries', 'Fresh Fruit Platter'],
          'Lunch': ['Grilled Lamb Chops', 'Mint Pesto Pasta'],
          'Dinner': ['Baked Halibut', 'Roasted Vegetables'],
          'Snacks': ['Seafood Delicacies'],
        },
        'Thursday': {
          'Breakfast': ['Almond Croissants', 'Mixed Berry Smoothies'],
          'Lunch': ['Vegetarian Lasagna', 'Garlic Breadsticks'],
          'Dinner': ['Shrimp Scampi', 'Caprese Salad'],
          'Snacks': ['Italian Night'],
        },
        'Friday': {
          'Breakfast': ['Caramelized Onion Quiche', 'Mango Lassi'],
          'Lunch': ['Teriyaki Salmon', 'Vegetable Tempura'],
          'Dinner': ['Ribeye Steak', 'Loaded Baked Potatoes'],
          'Snacks': ['Asian Fusion'],
        },
        'Saturday': {
          'Breakfast': ['Chocolate Croissants', 'Vanilla Latte'],
          'Lunch': ['Eggplant Parmesan', 'Garlic Knots'],
          'Dinner': ['Grilled Lobster Tail', 'Caesar Salad'],
          'Snacks': ['Gourmet Delights'],
        },
      },
    ),
    'ExquisiteEats': MessMenu(
      id: '3',
      kitchenName: 'ExquisiteEats',
      messMenu: {
        'Sunday': {
          'Breakfast': ['Avocado Toast', 'Smoothie Bowl'],
          'Lunch': ['Quinoa Salad', 'Stuffed Bell Peppers'],
          'Dinner': ['Vegan Curry', 'Cauliflower Rice'],
          'Snacks': ['Plant-Based Delicacies'],
        },
        'Monday': {
          'Breakfast': ['Chia Seed Pudding', 'Mixed Fruit Smoothie'],
          'Lunch': ['Sweet Potato Buddha Bowl', 'Kale Salad'],
          'Dinner': ['Mushroom Risotto', 'Grilled Asparagus'],
          'Snacks': ['Vegan Dessert Paradise'],
        },
        'Tuesday': {
          'Breakfast': ['Acai Bowl', 'Nut Butter Toast'],
          'Lunch': ['Lentil Soup', 'Quinoa Stuffed Acorn Squash'],
          'Dinner': ['Zucchini Noodles', 'Vegan Alfredo Sauce'],
          'Snacks': ['Healthy Indulgence Night'],
        },
        'Wednesday': {
          'Breakfast': ['Green Smoothie', 'Protein Pancakes'],
          'Lunch': ['Chickpea Salad Wrap', 'Sweet Potato Fries'],
          'Dinner': ['Cauliflower Steak', 'Wild Rice Pilaf'],
          'Snacks': ['Vegan Delights'],
        },
        'Thursday': {
          'Breakfast': ['Vegan Pancakes', 'Mixed Berry Compote'],
          'Lunch': ['Spaghetti Squash Primavera', 'Garlic Bread'],
          'Dinner': ['Veggie Stir-Fry', 'Tofu Satay'],
          'Snacks': ['International Vegan Cuisine'],
        },
        'Friday': {
          'Breakfast': ['Almond Butter Toast', 'Fruit Smoothie Bowl'],
          'Lunch': ['Vegan Tacos', 'Guacamole'],
          'Dinner': ['Eggplant Parmesan', 'Zesty Quinoa Salad'],
          'Snacks': ['Vegan Fiesta'],
        },
        'Saturday': {
          'Breakfast': ['Pumpkin Spice Smoothie', 'Granola Parfait'],
          'Lunch': ['Vegan Sushi Rolls', 'Edamame'],
          'Dinner': ['Portobello Mushroom Steak', 'Roasted Brussels Sprouts'],
          'Snacks': ['Gourmet Vegan Experience'],
        },
      },
    ),
    'SavorySpices': MessMenu(
      id: '4',
      kitchenName: 'SavorySpices',
      messMenu: {
        'Sunday': {
          'Breakfast': ['Cinnamon Roll Pancakes', 'Spiced Chai Latte'],
          'Lunch': ['Indian Butter Chicken', 'Naan Bread'],
          'Dinner': ['Lamb Rogan Josh', 'Saffron Rice'],
          'Snacks': ['Indian Spice Festival'],
        },
        'Monday': {
          'Breakfast': ['Masala Chai Oatmeal', 'Cardamom Muffins'],
          'Lunch': ['Vegetable Biryani', 'Cucumber Raita'],
          'Dinner': ['Chicken Tikka Masala', 'Garlic Naan'],
          'Snacks': ['Flavors of India Night'],
        },
        'Tuesday': {
          'Breakfast': ['Turmeric Smoothie Bowl', 'Mango Lassi'],
          'Lunch': ['Palak Paneer', 'Jeera Rice'],
          'Dinner': ['Tandoori Salmon', 'Aloo Gobi'],
          'Snacks': ['Spice Infusion Dinner'],
        },
        'Wednesday': {
          'Breakfast': ['Samosa Stuffed Omelette', 'Minty Yogurt Dip'],
          'Lunch': ['Chicken Korma', 'Pulao Rice'],
          'Dinner': ['Vegetable Jalfrezi', 'Roti'],
          'Snacks': ['Indian Delicacies Night'],
        },
        'Thursday': {
          'Breakfast': ['Chai Spiced Granola', 'Mango Chutney'],
          'Lunch': ['Dal Makhani', 'Garlic Butter Naan'],
          'Dinner': ['Fish Curry', 'Coconut Rice'],
          'Snacks': ['South Asian Feast'],
        },
        'Friday': {
          'Breakfast': ['Curry Leaf Scrambled Eggs', 'Spiced Fruit Salad'],
          'Lunch': ['Aloo Paratha', 'Raita'],
          'Dinner': ['Mutton Biryani', 'Cucumber Mint Chutney'],
          'Snacks': ['Exotic Indian Flavors Night'],
        },
        'Saturday': {
          'Breakfast': ['Spicy Mango Smoothie', 'Papaya Chaat'],
          'Lunch': ['Paneer Tikka', 'Masoor Dal'],
          'Dinner': ['Chicken Curry', 'Basmati Pilaf'],
          'Snacks': ['Indian Culinary Journey'],
        },
      },
    ),
    'SeafoodSensation': MessMenu(
      id: '5',
      kitchenName: 'SeafoodSensation',
      messMenu: {
        'Sunday': {
          'Breakfast': ['Smoked Salmon Bagels', 'Cream Cheese'],
          'Lunch': ['Garlic Butter Shrimp', 'Lemon Herb Couscous'],
          'Dinner': ['Grilled Lobster Tail', 'Asparagus Risotto'],
          'Snacks': ['Seafood Extravaganza'],
        },
        'Monday': {
          'Breakfast': ['Crab Benedict', 'Avocado Toast'],
          'Lunch': ['Spicy Tuna Sushi', 'Edamame'],
          'Dinner': ['Scallop Scampi', 'Wild Rice Pilaf'],
          'Snacks': ['Sushi Night'],
        },
        'Tuesday': {
          'Breakfast': ['Shrimp and Grits', 'Cajun Omelette'],
          'Lunch': ['Lobster Mac and Cheese', 'Garlic Bread'],
          'Dinner': ['Blackened Salmon', 'Quinoa Salad'],
          'Snacks': ['Seafood Delicacies Night'],
        },
        'Wednesday': {
          'Breakfast': ['Smoked Mackerel Hash', 'Dill Hollandaise'],
          'Lunch': ['Clam Linguine', 'Garlic Knots'],
          'Dinner': ['Grilled Swordfish', 'Mango Salsa'],
          'Snacks': ['Fresh Catch Night'],
        },
        'Thursday': {
          'Breakfast': ['Tuna Nicoise Salad', 'Citrus Vinaigrette'],
          'Lunch': ['Cajun Shrimp Po\' Boy', 'Sweet Potato Fries'],
          'Dinner': ['Crab Cakes', 'Remoulade Sauce'],
          'Snacks': ['Seafood Fusion Night'],
        },
        'Friday': {
          'Breakfast': ['Smoked Salmon Omelette', 'Caprese Salad'],
          'Lunch': ['Shrimp and Crab Bisque', 'Garlic Bread'],
          'Dinner': ['Grilled Mahi Mahi', 'Quinoa Pilaf'],
          'Snacks': ['Mediterranean Seafood Night'],
        },
        'Saturday': {
          'Breakfast': ['Shrimp Avocado Toast', 'Citrus Zest Smoothie'],
          'Lunch': ['Seafood Paella', 'Green Bean Almondine'],
          'Dinner': ['Crab Stuffed Mushrooms', 'Roasted Tomato Bruschetta'],
          'Snacks': ['Seafood Extravaganza'],
        },
      },
    ),
  };
}

class DummyRooms {
  static List<Room> rooms = [
    Room(id: '1', name: 'Auditorium', vacant: true),
    Room(id: '2', name: 'Classroom 101', vacant: false, occupantId: 'T001'),
    Room(id: '3', name: 'Robotics Club', vacant: true),
    Room(id: '4', name: 'Library Study Room A', vacant: true),
    Room(id: '5', name: 'Conference Room', vacant: false, occupantId: 'T002'),
    Room(id: '6', name: 'Physics Lab', vacant: true),
    Room(id: '7', name: 'Student Lounge', vacant: false, occupantId: 'S001'),
    Room(id: '8', name: 'Chemistry Lab', vacant: true),
    Room(id: '9', name: 'Art Studio', vacant: false, occupantId: 'T003'),
    Room(id: '10', name: 'Cafeteria', vacant: false, occupantId: 'S002'),
    Room(id: '11', name: 'Computer Lab 201', vacant: true),
    Room(id: '12', name: 'Math Club Room', vacant: true),
    Room(id: '13', name: 'Gymnasium', vacant: false, occupantId: 'S003'),
    Room(id: '14', name: 'Drama Club Rehearsal Room', vacant: true),
    Room(id: '15', name: 'Language Lab', vacant: false, occupantId: 'T004'),
    Room(id: '16', name: 'Outdoor Sports Arena', vacant: true),
    Room(id: '17', name: 'Medical Clinic', vacant: false, occupantId: 'S004'),
    Room(id: '18', name: 'Music Room', vacant: true),
    Room(
        id: '19',
        name: 'Student Council Office',
        vacant: false,
        occupantId: 'T005'),
    Room(id: '20', name: 'Virtual Reality Lab', vacant: true),
  ];
}
