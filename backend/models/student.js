import mongoose from 'mongoose';

const studentSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    token: {
        type: String,
        required: true
    },
    rollNumber: {
        type: String,
    },
    about: {
        type: String,
    },
    profilePicURI: {
        type: String,
    },
    branch: {
        type: String,
    },
    graduationYear: {
        type: Number,
    },
    skills: {
        type: [skillSchema],
    },
    achievements: {
        type: [achievementSchema],
    },
    roles: {
        type: [String],
    }
});

const Student = mongoose.model('Student', studentSchema);

export default Student;
