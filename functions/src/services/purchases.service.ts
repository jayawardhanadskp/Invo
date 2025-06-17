import * as admin from 'firebase-admin';
import { PurchaseModel } from '../models/purchase.model';
import { BuyerModel } from '../models/buyer.model';
import { BatchModel } from '../models/batch.model';
import { getBuyer } from './buyer.service';

export async function createPurchase(
  uid: string,
  purchase: Omit<PurchaseModel, 'id'>
): Promise<PurchaseModel> {
  const db = admin.firestore();

  const purchaseRef = db
    .collection('users')
    .doc(uid)
    .collection('purchases')
    .doc();

  const generatedId = purchaseRef.id;

  const buyerRef = db
    .collection('users')
    .doc(uid)
    .collection('buyers')
    .doc(purchase.buyerId);

  const batchQuery = db
    .collection('users')
    .doc(uid)
    .collection('batches')
    .orderBy('createdAt', 'desc')
    .limit(1);

  // 1. Get Buyer
  const buyerSnap = await getBuyer(uid, purchase.buyerId);
  if (buyerSnap.id == null) {
    throw new Error('Buyer not found');
  }

  const buyerData = buyerSnap as BuyerModel;
  const buyerId = buyerData.id || buyerRef.id;

  const updatedTotalPieces = (buyerData.totalPieces || 0) + purchase.pieces;
  const updatedTotalPaid =
    (buyerData.totalPaid || 0) + (purchase.paymentStatus.toLowerCase() === 'paid' ? purchase.amount : 0);
  const updatedTotalDue =
    (buyerData.totalDue || 0) + (purchase.paymentStatus.toLowerCase() === 'due' ? purchase.amount : 0);

  // 2. Save purchase
  await purchaseRef.set({
    ...purchase,
    id: generatedId,
    buyerId: buyerId,
    purchaseDate: purchase.purchaseDate.toISOString(),
  });

  // 3. Update buyer
  await buyerRef.update({
    totalPieces: updatedTotalPieces,
    totalPaid: updatedTotalPaid,
    totalDue: updatedTotalDue,
  });

  // 4. Get and update the latest batch
  const batchSnap = await batchQuery.get();

  if (batchSnap.empty) {
    throw new Error('No batches found');
  }

  const batchDoc = batchSnap.docs[0];
  const batchData = batchDoc.data() as BatchModel;
  const currentPieces = batchData.pieces || 0;
  const updatedBatchPieces = Math.max(0, currentPieces - purchase.pieces);

  const currentSales = batchData.sales || 0;
  const updatedBatchSales = Math.max(0, currentSales + purchase.amount);

  await batchDoc.ref.update({
    pieces: updatedBatchPieces,
    sales: updatedBatchSales,
  });

  // 5. Return saved purchase
  const savedPurchase = await purchaseRef.get();
  return savedPurchase.data() as PurchaseModel;
}


export async function getPurchaseList(uid: string): Promise<Array<PurchaseModel>> {
  const db = admin.firestore();
  
  const purchaseRef = db
    .collection('users')
    .doc(uid)
    .collection('purchases')
    .orderBy('purchaseDate', 'desc');

  const purchaseSnap = await purchaseRef.get();

  if (purchaseSnap.empty) {
    return [];
  }

  const purchases: PurchaseModel[] = [];

  purchaseSnap.forEach(doc => {
    const data = doc.data() as PurchaseModel;
    purchases.push({...data});
  });

  return purchases;
}
