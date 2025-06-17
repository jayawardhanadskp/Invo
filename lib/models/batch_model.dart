// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BatchModel {
  final String? id;
  final String grams;
  final int pieces;
  final String? note;
  final DateTime createdAt;
  final int? sales;
  BatchModel({
    this.id,
    required this.grams,
    required this.pieces,
    this.note,
    required this.createdAt,
    this.sales,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'grams': grams,
      'pieces': pieces,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'sales': sales,
    };
  }

  factory BatchModel.fromMap(Map<String, dynamic> map) {
    return BatchModel(
      id: map['id'] != null ? map['id'] as String : null,
      grams: map['grams'] as String,
      pieces: map['pieces'] as int,
      note: map['note'] != null ? map['note'] as String : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      sales: map['sales'] != null ? map['sales'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchModel.fromJson(String source) =>
      BatchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
