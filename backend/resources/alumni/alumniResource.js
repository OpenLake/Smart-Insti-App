
import express from "express";
import Student from "../../models/student.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";

const alumniResource = express.Router();

// Get Alumni Directory (List with Filters)
alumniResource.get("/", isAuthenticated, async (req, res) => {
    try {
        const { branch, graduationYear, search } = req.query;
        
        let query = { roles: "Alumni" };

        if (branch && branch !== "All") {
            query.branch = branch;
        }

        if (graduationYear && graduationYear !== "All") {
            query.graduationYear = parseInt(graduationYear);
        }

        if (search) {
            query.$or = [
                { name: { $regex: search, $options: "i" } },
                { currentOrganization: { $regex: search, $options: "i" } },
                { designation: { $regex: search, $options: "i" } }
            ];
        }

        const alumni = await Student.find(query)
            .select("name email branch graduationYear profilePicURI currentOrganization designation linkedInProfile")
            .sort({ graduationYear: -1, name: 1 });

        res.status(200).json({ status: true, data: alumni });

    } catch (err) {
        console.error("Error fetching alumni:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

// Get Unique Filter Options (Branches and Years)
alumniResource.get("/filters", isAuthenticated, async (req, res) => {
    try {
        const alumni = await Student.find({ roles: "Alumni" }).select("branch graduationYear");
        
        const branches = new Set();
        const years = new Set();

        alumni.forEach(a => {
            if (a.branch) branches.add(a.branch);
            if (a.graduationYear) years.add(a.graduationYear);
        });

        res.status(200).json({
            status: true,
            data: {
                branches: Array.from(branches).sort(),
                years: Array.from(years).sort((a, b) => b - a)
            }
        });

    } catch (err) {
        console.error("Error fetching filters:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default alumniResource;
