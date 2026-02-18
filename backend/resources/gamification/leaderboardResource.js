
import express from "express";
import Student from "../../models/student.js";
import Skill from "../../models/skill.js";
import Achievement from "../../models/achievement.js";
import isAuthenticated from "../../middlewares/isAuthenticated.js";

const leaderboardRouter = express.Router();

// Get Leaderboard (Top 20 Students by XP)
// XP Calculation: (Skill Level * 10) + (Achievement Count * 50)
leaderboardRouter.get("/", isAuthenticated, async (req, res) => {
    try {
        // Fetch all students with their skills and achievements
        const students = await Student.find({ roles: { $ne: "Alumni" } }) // Exclude alumni for now
            .select("name profilePicURI branch graduationYear skills achievements")
            .populate("skills")
            .populate("achievements");

        const leaderboard = students.map(student => {
            let xp = 0;

            // Skills XP
            if (student.skills && student.skills.length > 0) {
                student.skills.forEach(skill => {
                    // Assuming skill has a 'level' field (1-10)
                    xp += (skill.level || 1) * 10; 
                });
            }

            // Achievements XP
            if (student.achievements && student.achievements.length > 0) {
                xp += student.achievements.length * 50;
            }

            return {
                _id: student._id,
                name: student.name,
                profilePicURI: student.profilePicURI,
                branch: student.branch,
                xp: xp,
                achievementCount: student.achievements ? student.achievements.length : 0,
                skillCount: student.skills ? student.skills.length : 0
            };
        });

        // Sort by XP descending
        leaderboard.sort((a, b) => b.xp - a.xp);

        // Return top 50
        res.status(200).json({ status: true, data: leaderboard.slice(0, 50) });

    } catch (err) {
        console.error("Error fetching leaderboard:", err);
        res.status(500).json({ status: false, message: "Internal server error" });
    }
});

export default leaderboardRouter;
