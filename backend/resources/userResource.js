import express from 'express';
import jwt from 'jsonwebtoken';
import * as errorMessages from '../constants/errorMessages.js';
import Student from '../models/Student.js';
import Faculty from '../models/faculty.js';
import Admin from '../models/admin.js';
const userRouter = express.Router();

userRouter.post('/login', async (req, res) => {
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
      return res.status(400).send({ error: errorMessages.invalidUserType });
  }
  
  existingUser = await userCollection.findOne({ email });

  if (!existingUser) {
    const newUser = new userCollection({ email });
    await newUser.save();
    res.send({ message: errorMessages.userCreated, user: newUser });
  } else {
    res.send({ message: errorMessages.userAlreadyExists, user: existingUser});
  }
});

export default userRouter;