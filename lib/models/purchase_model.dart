// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PurchaseModel {
  final String? id;
  final String? buyerId;
  final int pieces;
  final int amount;
  final String paymentType;    // "cash" | "bank" | "credit"
  final String paymentStatus;  // "paid" | "due"
  final DateTime purchaseDate;

  PurchaseModel({
    this.id,
    this.buyerId,
    required this.pieces,
    required this.amount,
    required this.paymentType,
    required this.paymentStatus,
    required this.purchaseDate,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'buyerId': buyerId,
      'pieces': pieces,
      'amount': amount,
      'paymentType': paymentType,
      'paymentStatus': paymentStatus,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) {
    return PurchaseModel(
      id: map['id'] != null ? map['id'] as String : null,
      buyerId: map['buyerId'] != null ? map['buyerId'] as String : null,
      pieces: map['pieces'] as int,
      amount: map['amount'] as int,
      paymentType: map['paymentType'] as String,
      paymentStatus: map['paymentStatus'] as String,
      purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseModel.fromJson(String source) => PurchaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
