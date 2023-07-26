// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DiseaseModel {
  String name;
  String note;
  String? treatments;
  List<dynamic> symptom;
  DiseaseModel({
    required this.name,
    required this.note,
    this.treatments,
    required this.symptom,
  });

  DiseaseModel copyWith({
    String? name,
    String? note,
    String? treatments,
    List<dynamic>? symptom,
  }) {
    return DiseaseModel(
      name: name ?? this.name,
      note: note ?? this.note,
      treatments: treatments ?? this.treatments,
      symptom: symptom ?? this.symptom,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'note': note,
      'treatments': treatments,
      'symptom': symptom,
    };
  }

  factory DiseaseModel.fromMap(Map<String, dynamic> map) {
    return DiseaseModel(
      name: map['name'] as String,
      note: map['note'] as String,
      treatments:
          map['treatments'] != null ? map['treatments'] as String : null,
      symptom: List<dynamic>.from((map['symptom'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseModel.fromJson(String source) =>
      DiseaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiseaseModel(name: $name, note: $note, treatments: $treatments, symptom: $symptom)';
  }

  @override
  bool operator ==(covariant DiseaseModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.note == note &&
        other.treatments == treatments &&
        listEquals(other.symptom, symptom);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        note.hashCode ^
        treatments.hashCode ^
        symptom.hashCode;
  }
}
