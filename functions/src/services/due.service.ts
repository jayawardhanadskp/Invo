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

    if (!ts) {
        console.warn(`Missing purchaseDate for buyerId: ${buyerId}`);
        return null;
    }

    let date: Date;

    if (typeof ts === 'string') {
        date = new Date(ts); 
    } else if (typeof ts.toDate === 'function') {
        date = ts.toDate(); 
    } else {
        console.warn(`Invalid purchaseDate format for buyerId: ${buyerId}`);
        return null;
    }

    return date;

}

export async function applyPayment(uid: string, buyerId: string, paymentAmount: number): Promise<void> {
    const db = admin.firestore();

    const purchaseRef = db
        .collection('users')
        .doc(uid)
        .collection('purchases')
        .where('buyerId', '==', buyerId)
        .where('paymentStatus', '==', 'Due')
        .orderBy('purchaseDate');

    const purchaseSnap = await purchaseRef.get();
    if (purchaseSnap.empty) return;

    let remainingPayment = paymentAmount;
    const batch = db.batch();

    for (const doc of purchaseSnap.docs) {
        if (remainingPayment <= 0) break;

        const purchase = doc.data();
        const docRef = doc.ref;
        const amount = purchase.amount || 0;

        if (remainingPayment >= amount) {

            batch.update(docRef, { paymentStatus: 'Paid' });
            remainingPayment -= amount;
        } else {
            updateBuyerPaymentOnly(db, uid, buyerId, paymentAmount);
            break;
        }
    }

    const paidAmount = paymentAmount - remainingPayment;

    // update buyer doc
    const buyerRef = db
        .collection('users')
        .doc(uid)
        .collection('buyers')
        .doc(buyerId);

    const buyerDoc = await buyerRef.get();
    if (!buyerDoc.exists) throw new Error("Buyer not found");

    const buyer = buyerDoc.data() as BuyerModel;

    const newPaid = (buyer.totalPaid || 0) + paidAmount;
    const newDue = Math.max((buyer.totalDue || 0) - paidAmount, 0);

    batch.update(buyerRef, {
        totalPaid: newPaid,
        totalDue: newDue,
    });

    await batch.commit();
}

async function updateBuyerPaymentOnly(db: FirebaseFirestore.Firestore, uid: string, buyerId: string, paymentAmount: number) {
    const buyerRef = db
        .collection('users')
        .doc(uid)
        .collection('buyers')
        .doc(buyerId);

    const buyerDoc = await buyerRef.get();
    if (!buyerDoc.exists) throw new Error("Buyer not found");

    const buyer = buyerDoc.data() as BuyerModel;

    const newPaid = (buyer.totalPaid || 0) + paymentAmount;
    const newDue = (buyer.totalDue || 0) - paymentAmount;

    await buyerRef.update({
        totalPaid: newPaid,
        totalDue: newDue,
    });
}