import mongoose from 'mongoose';

const courseSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    courseCode: {
        type: String,
        required: true,
        unique: true
    },
    primary_room: {
        type: String,
        required: true,
    },
    credits: {
        type: Number,
        required: true,
    },
    branches: [{
        type: String,
        required: true
    }]
});

const Course = mongoose.model('Course', courseSchema);

export default Course;