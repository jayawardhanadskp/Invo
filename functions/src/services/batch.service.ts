import * as admin from 'firebase-admin';
import { BatchModel } from '../models/batch.model';

/**
 * Creates or updates a batch document in Firestore.
 */

export async function createBatch(uid: string, batch: Omit<BatchModel, "id">) {
    const batchRef = admin.firestore()
        .collection('users')
        .doc(uid)
        .collection('batches')
        .doc();

    const generatedId = batchRef.id;

    await batchRef.set({
        ...batch,
        createdAt: batch.createdAt.toISOString(),
        id: generatedId,
    });

    const savedBatch = await batchRef.get();
    return savedBatch.data() as BatchModel;
}

export async function getBatchList(uid: string): Promise<Array<BatchModel>> {
    const db = admin.firestore();

    const batchRef = db
        .collection('users')
        .doc(uid)
        .collection('batches')
        .orderBy('createdAt', 'desc');


    const batchSnap = await batchRef.get();

    if (batchSnap.empty) {
        return [];
    }

    const batches: BatchModel[] = [];
    batchSnap.forEach(doc => {
        const data = doc.data() as BatchModel;
        batches.push({ ...data });
    });

    return batches;
}
