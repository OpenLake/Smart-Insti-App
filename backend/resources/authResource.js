import mongoose from 'mongoose';
import express from 'express';
import User from "../models/user.js";
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';
import * as errorMessages from '../constants/errorMessages.js';
import Student from '../models/Student.js';
import Faculty from '../models/faculty.js';
import Admin from '../models/admin.js';

const authRouter = express.Router();

// // Sign-Up Route
// authRouter.post('/signup',async (req,res)=>{
//    try {
//         const { name, email, password } = req.body;
//         const existingUser = await User.findOne({ email });
//         if (existingUser){
//             return res.status(400).json({ msg: errorMessages.userAlreadyExists });
//         }
//         const hashedPassword = await bcryptjs.hash(password,8);
//         let user = new User({
//             email,
//             password: hashedPassword,
//             name,
//         });
//         user = await user.save();
//         res.json(user);
//     } catch (e) {
//         res.status(500).json({error:e.message});
//     }
// })

// // Sign-In Route
// authRouter.post("/signin", async (req, res) => {
//   try {
//     const { email, password } = req.body;

//     const user = await User.findOne({ email });
//     if (!user) {
//       return res
//         .status(400)
//         .json({ msg: errorMessages.userNotFound });
//     }

//     const isMatch = await bcryptjs.compare(password, user.password);
    
//     if (!isMatch) {
//       return res.status(400).json({ msg: errorMessages.incorrectPassword });
//     }

//     const token = jwt.sign({ id: user._id }, "passwordKey");
//     res.json({ token, ...user._doc });
//   } catch (e) {
//     res.status(500).json({ error: errorMessages.internalServerError });
//   }
// });

authRouter.post('/login', async (req, res) => {
  const { email, userType } = req.body;
  const token = jwt.sign({ email,userType }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1h' });
  let userCollection;
  let existingUser;
  
  switch(userType) {
    case 'student':
      userCollection = Student;
      break;
    case 'faculty':
      userCollection = Faculty;
      break;
    case 'admin':
      userCollection = Admin;
      break;
    default:
      return res.status(400).send({ error: 'Invalid user type' });
  }
  
  existingUser = await userCollection.findOne({ email });

  if (!existingUser) {
    const newUser = new userCollection({ email });
    await newUser.save();
    res.send({ message: 'User created successfully', user: newUser });
  } else {
    res.send({ message: 'User already exists' });
  }
});

export default authRouter