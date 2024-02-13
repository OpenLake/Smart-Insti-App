import Skill from '../models/Skill.js';
import express from 'express';
import * as errorMessages from '../constants/errorMessages.js';
const skillRouter = express.Router();

skillRouter.get('/skills', async (req, res) => {
    try {
        const skills = await Skill.find({});
        res.json(skills)
    } catch (err) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

skillRouter.get('/skills/:id', async (req, res) => {
    const skillId = req.params.id;
    
    try {
        const skillDetails = await Skill.findById(skillId);

        if (!skillDetails) {
            return res.status(404).json({ message: errorMessages.skillNotFound });
        }

        res.json(skillDetails);
    } catch (err) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

skillRouter.post('/skills', async (req, res) => {
    const skillData = req.body;

    try {
        const newSkill = new Skill(skillData);
        await newSkill.save();

        res.status(201).json(newSkill);
    } catch (err) {
        res.status(500).json({ message: errorMessages.internalServerError});
    }
});

skillRouter.put('/skills/:id', async (req, res) => {
    const skillId = req.params.id;
    const skillData = req.body;
    
    try {
        const updatedSkill = await Skill.findByIdAndUpdate(skillId,skillData,{new:true});
        res.json(updatedSkill);
    } catch (error) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
    
});

skillRouter.delete('/skills/:id', async (req, res) => {
    const skillId = req.params.id;
    
    try {
        const deletedSkill = await Skill.findByIdAndDelete(skillId);
        res.json(deletedSkill);
    } catch (error) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

export default skillRouter;

        
        