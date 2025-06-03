export interface BuyerModel {
    id: string;
    name: string;
    phone: number;
    totalDue?: number;
    totalPaid?: number;
    totalPieces?: number;
}