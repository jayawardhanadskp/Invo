import * as admin from 'firebase-admin';
import { BuyerModel } from '../models/buyer.model';

export async function getAllDues(uid: string): Promise<number> {
    const db = admin.firestore();

    const buyerRef = db
        .collection('users')
        .doc(uid)
        .collection('buyers');

    const snapshot = await buyerRef
        .where('totalDue', '>', 0)
        .orderBy('totalDue', 'desc')
        .get();

    if (snapshot.empty) {
        return 0;
    }

    let totalDue = 0;

    snapshot.forEach(doc => {
        const data = doc.data();
        if (data.totalDue) {
            totalDue += data.totalDue;
        }
    });


    return totalDue;
}


export async function getBuyersWithDue(
    uid: string
): Promise<Array<BuyerModel & { firstDueDate?: string }>> {
    const db = admin.firestore();
    const buyerRef = db.collection('users').doc(uid).collection('buyers');

    const snapshot = await buyerRef.where('totalDue', '>', 0).get();

    const results: Array<BuyerModel & { firstDueDate?: string }> = [];

    for (const doc of snapshot.docs) {
        const buyer = doc.data() as BuyerModel;

        if (!buyer.id) {
            console.warn(`Missing buyer ID for document ${doc.id}`);
            continue;
        }

        try {
            const firstDueDate = await getBuyerFirstDueDate(uid, buyer.id);
            results.push({
                ...buyer,
                firstDueDate: firstDueDate ? firstDueDate.toISOString() : undefined,
            });
        } catch (error) {
            console.error(`Error fetching due date for buyer ${buyer.id}`, error);
        }
    }

    console.log("Buyers with due:", results);
    return results;
}



export async function getBuyerFirstDueDate(
    uid: string,
    buyerId: string
): Promise<Date | null> {
    const db = admin.firestore();

    const purchaseRef = db
        .collection('users')
        .doc(uid)
        .collection('purchases');

    const snapshot = await purchaseRef
        .where('buyerId', '==', buyerId)
        .where('paymentStatus', '==', 'Due')
        .orderBy('purchaseDate', 'asc')
        .limit(1)
        .get();

    if (snapshot.empty) {
        return null;
    }

    const firstDuePurchase = snapshot.docs[0].data();

    const ts = firstDuePurchase?.purchaseDate;

    if (!ts || typeof ts.toDate !== 'function') {
        console.warn(`Invalid or missing purchaseDate for buyerId: ${buyerId}`);
        return null;
    }

    return ts.toDate();
}
