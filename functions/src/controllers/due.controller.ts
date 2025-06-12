import { Response } from "express";
import { AuthenticatedRequest } from "../middlewares/auth.middleware";
import {getAllDues} from "../services/due.service";
import {getBuyersWithDue} from "../services/due.service"

export async function getAllDuesController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }

        const uid = req.user.uid;

        const allDues = await getAllDues(uid);
        return res.status(200).json({
            success: true,
            message: "Dues retrieved successfully",
            data: allDues,
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error instanceof Error ? error.message : "Unknown error",
        
        });
    }
}

export async function getBuyersWithDueController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }
        const uid = req.user.uid;

        const buyersWithDue = await getBuyersWithDue(uid);
        return res.status(200).json({
            success: true,
            message: "Dues List retrieved successfully",
            data: buyersWithDue,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal Server Error",
            error: error instanceof Error ? error.message : "Unknown error",
        })
    }
}