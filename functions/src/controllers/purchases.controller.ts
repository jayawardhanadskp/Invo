import { Response } from "express";
import { createPurchase } from "../services/purchases.service";
import { AuthenticatedRequest } from "../middlewares/auth.middleware";

export async function createPurchaseController(req: AuthenticatedRequest, res: Response) {
    try {
        if (!req.user) {
            return res.status(401).json({ error: "Unauthorized" });
        }
        const uid = req.user.uid;

        const { buyerId, amount, pieces, paymentType, paymentStatus, purchaseDate } = req.body;

        const finalPaymentStatus = paymentStatus === "Credit" ? "Due" : paymentStatus;

        const purchaseData = {
            buyerId,
            amount,
            pieces,
            paymentType,
            paymentStatus: finalPaymentStatus,
            purchaseDate: purchaseDate ? new Date(purchaseDate) : new Date(),
        };

        const purchase = await createPurchase(uid, purchaseData);
        return res.status(201).json({
            success: true,
            message: "Purchase created successfully",
            data: purchase,
        });
    } catch (error) {
        return res.status(500).json({ 
            success: false,
            message: "Error creating purchase",
            error: error instanceof Error ? error.message : "Unknown error"
        });
    }


}