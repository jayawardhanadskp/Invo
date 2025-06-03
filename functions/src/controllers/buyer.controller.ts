import { Response } from "express";
import { createBuyer } from "../services/buyer.service";
import { AuthenticatedRequest } from "../middlewares/auth.middleware";
import { getBuyer } from "../services/buyer.service";
import { getBuyers } from "../services/buyer.service";

export async function createBuyerController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }
        const uid = req.user.uid;

        const { name, phone, totalDue, totalPaid, totalPieces } = req.body;

        const buyerData = {
            name,
            phone,
            totalDue: totalDue || 0,
            totalPaid: totalPaid || 0,
            totalPieces: totalPieces || 0,
            
        }

        const buyer = await createBuyer(uid, buyerData);
        return res.status(201).json({
            success: true,
            message: "Buyer created successfully",
            data: buyer,
        });
    } catch (error) {
        console.error("Error creating buyer:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error instanceof Error ? error.message : "Unknown error",
        });
    }
}

export async function getBuyerController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }
        const uid = req.user.uid;
        const buyerId = req.params.buyerId;

        const buyer = await getBuyer(uid, buyerId);
        return res.status(200).json({
            success: true,
            data: buyer,
        });
    } catch (error) {
        console.error("Error fetching buyer:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error instanceof Error ? error.message : "Unknown error",
        });
    }
}

export async function getBuyersController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }
        const uid = req.user.uid;

        const buyers = await getBuyers(uid);
        return res.status(200).json({
            success: true,
            data: buyers,
        });
    } catch (error) {
        console.error("Error fetching buyers:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error instanceof Error ? error.message : "Unknown error",
        });
    }
}
