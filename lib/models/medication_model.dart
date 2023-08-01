// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MedicationModel {
  String? id;
  String? patientId;
  String? medicationType;
  String? medicationName;
  String? medicationDosage;
  Map<String, dynamic>? duration;

  int? medicationStartDate;
  bool? isMedicationActive;
  String? medicationNote;
  int? createdAt;
  MedicationModel({
    this.id,
    this.patientId,
    this.medicationType = 'Syrup',
    this.medicationName,
    this.medicationDosage,
    this.duration,
    this.medicationStartDate,
    this.isMedicationActive,
    this.medicationNote,
    this.createdAt,
  });

  MedicationModel copyWith({
    String? id,
    String? patientId,
    String? medicationType,
    String? medicationName,
    String? medicationDosage,
    Map<String, dynamic>? duration,
    int? medicationStartDate,
    bool? isMedicationActive,
    String? medicationNote,
    int? createdAt,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      medicationType: medicationType ?? this.medicationType,
      medicationName: medicationName ?? this.medicationName,
      medicationDosage: medicationDosage ?? this.medicationDosage,
      duration: duration ?? this.duration,
      medicationStartDate: medicationStartDate ?? this.medicationStartDate,
      isMedicationActive: isMedicationActive ?? this.isMedicationActive,
      medicationNote: medicationNote ?? this.medicationNote,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientId': patientId,
      'medicationType': medicationType,
      'medicationName': medicationName,
      'medicationDosage': medicationDosage,
      'duration': duration,
      'medicationStartDate': medicationStartDate,
      'isMedicationActive': isMedicationActive,
      'medicationNote': medicationNote,
      'createdAt': createdAt,
    };
  }

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id'] != null ? map['id'] as String : null,
      patientId: map['patientId'] != null ? map['patientId'] as String : null,
      medicationType: map['medicationType'] != null
          ? map['medicationType'] as String
          : null,
      medicationName: map['medicationName'] != null
          ? map['medicationName'] as String
          : null,
      medicationDosage: map['medicationDosage'] != null
          ? map['medicationDosage'] as String
          : null,
      duration: map['duration'] != null
          ? Map<String, dynamic>.from((map['duration'] as Map<String, dynamic>))
          : null,
      medicationStartDate: map['medicationStartDate'] != null
          ? map['medicationStartDate'] as int
          : null,
      isMedicationActive: map['isMedicationActive'] != null
          ? map['isMedicationActive'] as bool
          : null,
      medicationNote: map['medicationNote'] != null
          ? map['medicationNote'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicationModel.fromJson(String source) =>
      MedicationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MedicationModel(id: $id, patientId: $patientId, medicationType: $medicationType, medicationName: $medicationName, medicationDosage: $medicationDosage, duration: $duration, medicationStartDate: $medicationStartDate, isMedicationActive: $isMedicationActive, medicationNote: $medicationNote, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant MedicationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.patientId == patientId &&
        other.medicationType == medicationType &&
        other.medicationName == medicationName &&
        other.medicationDosage == medicationDosage &&
        mapEquals(other.duration, duration) &&
        other.medicationStartDate == medicationStartDate &&
        other.isMedicationActive == isMedicationActive &&
        other.medicationNote == medicationNote &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        patientId.hashCode ^
        medicationType.hashCode ^
        medicationName.hashCode ^
        medicationDosage.hashCode ^
        duration.hashCode ^
        medicationStartDate.hashCode ^
        isMedicationActive.hashCode ^
        medicationNote.hashCode ^
        createdAt.hashCode;
  }
}
