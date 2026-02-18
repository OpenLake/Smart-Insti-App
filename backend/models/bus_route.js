
import mongoose from "mongoose";

const busRouteSchema = new mongoose.Schema({
    routeName: { type: String, required: true },
    busNumber: { type: String },
    driverName: { type: String },
    driverContact: { type: String },
    stops: [{
        stopName: { type: String, required: true },
        time: { type: String, required: true }, // e.g., "08:30 AM"
        location: { // Optional: Lat/Lng for map
            lat: Number,
            lng: Number
        }
    }],
    schedule: { // Days of operation
        type: [String], 
        default: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    },
    isActive: { type: Boolean, default: true }
}, {
    timestamps: true
});

const BusRoute = mongoose.model("BusRoute", busRouteSchema);
export default BusRoute;
