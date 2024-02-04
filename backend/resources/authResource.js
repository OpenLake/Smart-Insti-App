import express from 'express';
import bcryptjs from 'bcryptjs';
import jwt from 'jsonwebtoken';
import * as errorMessages from '../constants/errorMessages.js';
import Admin from '../models/admin.js';

const authRouter = express.Router();

// Sign-Up Route
authRouter.post('/signup',async (req,res)=>{
   try {
        const {email, password } = req.body;
        const existingUser = await Admin.findOne({ email });
        if (existingUser){
            return res.status(400).json({ msg: errorMessages.userAlreadyExists });
        }
        const hashedPassword = await bcryptjs.hash(password,8);
        let admin = new Admin({
            email,
            password: hashedPassword,
        });
        admin = await admin.save();
        res.json(admin);
    } catch (e) {
        res.status(500).json({error:e.message});
    }
})

// Sign-In Route
authRouter.post("/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await Admin.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: errorMessages.userNotFound });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    
    if (!isMatch) {
      return res.status(400).json({ msg: errorMessages.incorrectPassword });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: errorMessages.internalServerError });
  }
});


export default authRouter