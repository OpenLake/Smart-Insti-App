import mongoose from "mongoose";

const adminSchema = new mongoose.Schema({
    name: {
        type: String,
    },
    email: {
        type: String,
        required: true,
        unique: true
    },
    token: {
        type: String,
        required: true
    }
});

const Admin = mongoose.model('Admin', adminSchema);

export default Admin;

