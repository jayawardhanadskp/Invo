import * as admin from 'firebase-admin';
import {BatchModel} from '../models/batch.model';

/**
 * Creates or updates a batch document in Firestore.
 */

export async function createBatch(uid: string, batch: Omit<BatchModel, "id"> ) {
    const batchRef = admin.firestore()
    .collection('users')
    .doc(uid)
    .collection('batches')
    .doc();

    const generatedId = batchRef.id;

    await batchRef.set({
        ...batch,
        createdAt: admin.firestore.Timestamp.fromDate(batch.createdAt),
        id: generatedId,
    });

    const savedBatch = await batchRef.get();
    return savedBatch.data() as BatchModel;
}