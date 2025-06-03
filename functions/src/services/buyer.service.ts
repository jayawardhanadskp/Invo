import * as admin from 'firebase-admin';
import { BuyerModel } from '../models/buyer.model';

/**
 * Creates or updates a buyer document in Firestore.
 */

export async function createBuyer(uid: string, buyer: Omit<BuyerModel, "id">) {
    const buyerRef = admin.firestore()
        .collection('users')
        .doc(uid)
        .collection('buyers')
        .doc();

    const generatedId = buyerRef.id;

    await buyerRef.set({
        ...buyer,
        totalDue: buyer.totalDue || 0,
        totalPaid: buyer.totalPaid || 0,
        totalPieces: buyer.totalPieces || 0,
        id: generatedId,
    });

    const savedBuyer = await buyerRef.get();
    return savedBuyer.data() as BuyerModel;
}

export async function getBuyer(uid: string, buyerId: string) {
    const buyerRef = admin.firestore()
        .collection('users')
        .doc(uid)
        .collection('buyers')
        .doc(buyerId);

    const buyerDoc = await buyerRef.get();

    if (!buyerDoc.exists) {
        throw new Error("Buyer not found");
    }

    return buyerDoc.data() as BuyerModel;
}

export async function getBuyers(uid: string) {
    const buyersRef = admin.firestore()
        .collection('users')
        .doc(uid)
        .collection('buyers');

    const snapshot = await buyersRef.get();

    if (snapshot.empty) {
        return [];
    }

    const buyers: BuyerModel[] = [];
    snapshot.forEach(doc => {
        const data = doc.data() as BuyerModel;
        buyers.push({ ...data, id: doc.id });
    });

    return buyers;
    
}
