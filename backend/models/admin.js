import mongoose from "mongoose";

const adminSchema = new mongoose.Schema({
    name: {
        type: String,
        default: 'Smart Insti User'
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
});

const Admin = mongoose.model('Admin', adminSchema);

export default Admin;

