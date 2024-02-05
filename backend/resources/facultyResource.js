import Faculty from '../models/faculty.js';
import express from 'express';
import * as errorMessages from '../constants/errorMessages.js';
const facultyRouter = express.Router();

facultyRouter.get('/faculties', async (req, res) => {
    try {
        const faculties = await Faculty.find({});
        res.json(faculties);
    } catch (err) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

facultyRouter.get('/faculties/:id', async (req, res) => {
    const facultyId = req.params.id;
    
    try {
        const facultyDetails = await Faculty.findById(facultyId);

        if (!facultyDetails) {
            return res.status(404).json({ message: errorMessages.facultyNotFound });
        }

        res.json(facultyDetails);
    } catch (err) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

facultyRouter.put('/faculties/:id', async (req, res) => {
    const facultyId = req.params.id;
    const facultyData = req.body;
    
    try {
        const updatedFaculty = await Faculty.findByIdAndUpdate(facultyId,facultyData,{new:true});
        res.json(updatedFaculty);
    } catch (error) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
    
});

facultyRouter.delete('/faculties/:id', async (req, res) => {
    const facultyId = req.params.id;
    
    try {
        const deletedFaculty = await Faculty.findByIdAndDelete(facultyId);
        res.json(deletedFaculty);
    } catch (error) {
        res.status(500).json({ message: errorMessages.internalServerError });
    }
});

export default facultyRouter;