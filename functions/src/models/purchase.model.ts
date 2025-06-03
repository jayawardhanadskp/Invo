export interface PurchaseModel {
    id: string;
    buyerId: string;
    pieces: number;
    amount: number;
    paymentType: string; // "cash" | "bank" | "credit"
    paymentStatus: string; // "paid" | "due"
    purchaseDate: Date;
}
