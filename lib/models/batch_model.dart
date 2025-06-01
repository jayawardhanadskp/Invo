import 'dart:convert';

class BatchModel {
  final String? id;
  final String grams;
  final String pieces;
  final String? note;
  final DateTime createdAt;
  BatchModel({
    this.id,
    required this.grams,
    required this.pieces,
    this.note,
    required this.createdAt,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'grams': grams,
      'pieces': pieces,
      'note': note,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BatchModel.fromMap(Map<String, dynamic> map) {
    return BatchModel(
      id: map['id'] as String,
      grams: map['grams'] as String,
      pieces: map['pieces'] as String,
      note: map['note'] != null ? map['note'] as String : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory BatchModel.fromJson(String source) => BatchModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
