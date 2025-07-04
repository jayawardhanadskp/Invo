import { Response } from "express";
import { AuthenticatedRequest } from "../middlewares/auth.middleware"; 
import { createBatch } from "../services/batch.service";
import { getBatchList } from "../services/batch.service";

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
      sales: 0,
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

export async function getBatchListController(req: AuthenticatedRequest, res: Response) {
  try {
    if (!req.user) {
      return res.status(401).json({ success: false, message: "Unauthorized" });
    }

    const uid = req.user.uid;

    const batches = await getBatchList(uid);
    return res.status(200).json({
      success: true,
      message: "Batch list retrieved successfully",
      data: batches,
    });

  } catch (error) {
    console.error("Error getting batch list:", error);
    return res.status(500).json({
      success: false,
      message: "Internal Server Error",
      error: error instanceof Error ? error.message : "Unknown error",
    });
  }
}
