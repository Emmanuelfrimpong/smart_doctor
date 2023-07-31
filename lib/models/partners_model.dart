// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PartnerModel {
  String? id;
  String? patientName;
  String? patientId;
  String? doctorName;
  String? doctorId;
  String? doctorPhoto;
  String? patientPhoto;
  String? doctorSpeciality;
  String? status;
  Map<String, dynamic>? patientData;
  Map<String, dynamic>? doctorData;
  int? createdAt;
  PartnerModel({
    this.id,
    this.patientName,
    this.patientId,
    this.doctorName,
    this.doctorId,
    this.doctorPhoto,
    this.patientPhoto,
    this.doctorSpeciality,
    this.status,
    this.patientData,
    this.doctorData,
    this.createdAt,
  });

  PartnerModel copyWith({
    String? id,
    String? patientName,
    String? patientId,
    String? doctorName,
    String? doctorId,
    String? doctorPhoto,
    String? patientPhoto,
    String? doctorSpeciality,
    String? status,
    Map<String, dynamic>? patientData,
    Map<String, dynamic>? doctorData,
    int? createdAt,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      patientId: patientId ?? this.patientId,
      doctorName: doctorName ?? this.doctorName,
      doctorId: doctorId ?? this.doctorId,
      doctorPhoto: doctorPhoto ?? this.doctorPhoto,
      patientPhoto: patientPhoto ?? this.patientPhoto,
      doctorSpeciality: doctorSpeciality ?? this.doctorSpeciality,
      status: status ?? this.status,
      patientData: patientData ?? this.patientData,
      doctorData: doctorData ?? this.doctorData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientName': patientName,
      'patientId': patientId,
      'doctorName': doctorName,
      'doctorId': doctorId,
      'doctorPhoto': doctorPhoto,
      'patientPhoto': patientPhoto,
      'doctorSpeciality': doctorSpeciality,
      'status': status,
      'patientData': patientData,
      'doctorData': doctorData,
      'createdAt': createdAt,
    };
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    return PartnerModel(
      id: map['id'] != null ? map['id'] as String : null,
      patientName:
          map['patientName'] != null ? map['patientName'] as String : null,
      patientId: map['patientId'] != null ? map['patientId'] as String : null,
      doctorName:
          map['doctorName'] != null ? map['doctorName'] as String : null,
      doctorId: map['doctorId'] != null ? map['doctorId'] as String : null,
      doctorPhoto:
          map['doctorPhoto'] != null ? map['doctorPhoto'] as String : null,
      patientPhoto:
          map['patientPhoto'] != null ? map['patientPhoto'] as String : null,
      doctorSpeciality: map['doctorSpeciality'] != null
          ? map['doctorSpeciality'] as String
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      patientData: map['patientData'] != null
          ? Map<String, dynamic>.from(
              (map['patientData'] as Map<String, dynamic>))
          : null,
      doctorData: map['doctorData'] != null
          ? Map<String, dynamic>.from(
              (map['doctorData'] as Map<String, dynamic>))
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PartnerModel.fromJson(String source) =>
      PartnerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PartnerModel(id: $id, patientName: $patientName, patientId: $patientId, doctorName: $doctorName, doctorId: $doctorId, doctorPhoto: $doctorPhoto, patientPhoto: $patientPhoto, doctorSpeciality: $doctorSpeciality, status: $status, patientData: $patientData, doctorData: $doctorData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant PartnerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.patientName == patientName &&
        other.patientId == patientId &&
        other.doctorName == doctorName &&
        other.doctorId == doctorId &&
        other.doctorPhoto == doctorPhoto &&
        other.patientPhoto == patientPhoto &&
        other.doctorSpeciality == doctorSpeciality &&
        other.status == status &&
        mapEquals(other.patientData, patientData) &&
        mapEquals(other.doctorData, doctorData) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        patientName.hashCode ^
        patientId.hashCode ^
        doctorName.hashCode ^
        doctorId.hashCode ^
        doctorPhoto.hashCode ^
        patientPhoto.hashCode ^
        doctorSpeciality.hashCode ^
        status.hashCode ^
        patientData.hashCode ^
        doctorData.hashCode ^
        createdAt.hashCode;
  }
}
