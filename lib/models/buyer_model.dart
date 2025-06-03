// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BuyerModel {
  final String? id;
  final String name;
  final int phone;
  final int totalDue;
  final int totalPaid;
  final int totalPieces;

  BuyerModel({
    this.id,
    required this.name,
    required this.phone,
    this.totalDue = 0,
    this.totalPaid = 0,
    this.totalPieces = 0,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'totalDue': totalDue,
      'totalPaid': totalPaid,
      'totalPieces': totalPieces,
    };
  }

  factory BuyerModel.fromMap(Map<String, dynamic> map) {
    return BuyerModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] as String,
      phone: map['phone'] as int,
      totalDue: map['totalDue'] as int,
      totalPaid: map['totalPaid'] as int,
      totalPieces: map['totalPieces'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuyerModel.fromJson(String source) => BuyerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
