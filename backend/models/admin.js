import mongoose from 'mongoose';

const adminSchema = new mongoose.Schema({
    email:{
        required: true,
        type:String,
        validate: {
            validator: (value) => {
                const re =
                /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
                return value.match(re);
            },
            message: "Please enter a valid email address",
        },
    },
    password:{
        required: true,
        type:String,
    },
})

const Admin = mongoose.model("Admin", adminSchema);
export default Admin;