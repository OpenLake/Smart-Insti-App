
import express from "express";
import BusRoute from "../../models/bus_route.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";

const busRouteRouter = express.Router();

// Get all active bus routes
busRouteRouter.get("/", isAuthenticated, async (req, res) => {
    try {
        const routes = await BusRoute.find({ isActive: true });
        res.status(200).json({ status: true, data: routes });
    } catch (err) {
        console.error("Error fetching bus routes:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

// Admin: Create a bus route
busRouteRouter.post("/create", isAuthenticated, async (req, res) => {
    try {
        // Simple role check (assuming user object has role)
        // In a real app, use a proper middleware for admin check
        // if (req.user.role !== 'Admin') return res.status(403).json({ ... });

        const { routeName, busNumber, driverName, driverContact, stops, schedule } = req.body;
        
        const newRoute = new BusRoute({
            routeName, busNumber, driverName, driverContact, stops, schedule
        });

        await newRoute.save();
        res.status(201).json({ status: true, message: "Bus route created", data: newRoute });

    } catch (err) {
        console.error("Error creating bus route:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default busRouteRouter;
