import { Response } from "express";
import { createBatch } from "../services/batch.service";
import { AuthenticatedRequest } from "../middlewares/auth.middleware"; 

/**
 * Controller to handle batch creation requests.
 */
export async function handleCreateBatch(req: AuthenticatedRequest, res: Response) {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    const uid = req.user.uid;

    const { grams, pieces, note, createdAt } = req.body;

    const batchData = {
      grams,
      pieces,
      note,
      createdAt: new Date(createdAt),
    };

    const batch = await createBatch(uid, batchData);

    return res.status(200).json({
      success: true,
      message: "Batch created successfully",
      data: batch,
    });

  } catch (error) {
    console.error("Error creating batch:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
}
