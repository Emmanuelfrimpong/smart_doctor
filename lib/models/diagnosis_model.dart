// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DiagnosisModel {
  String? id;
  String? senderId;
  List<dynamic>? responses;
  List<dynamic>? symptoms;
  String? metadata;
  Map<String, dynamic>? medicalInfo;
  int? createAt;
  bool? isSaved;
  DiagnosisModel({
    this.id,
    this.senderId,
    this.responses = const [],
    this.symptoms = const [],
    this.metadata,
    this.medicalInfo = const {},
    this.createAt,
    this.isSaved = false,
  });

  DiagnosisModel clear() {
    return DiagnosisModel(
        id: null,
        senderId: null,
        responses: [],
        symptoms: [],
        metadata: null,
        medicalInfo: {},
        createAt: null,
        isSaved: false);
  }

  DiagnosisModel copyWith({
    String? id,
    String? senderId,
    List<dynamic>? responses,
    List<dynamic>? symptoms,
    String? metadata,
    Map<String, dynamic>? medicalInfo,
    int? createAt,
    bool? isSaved,
  }) {
    return DiagnosisModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      responses: responses ?? this.responses,
      symptoms: symptoms ?? this.symptoms,
      metadata: metadata ?? this.metadata,
      medicalInfo: medicalInfo ?? this.medicalInfo,
      createAt: createAt ?? this.createAt,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'responses': responses,
      'symptoms': symptoms,
      'metadata': metadata,
      'medicalInfo': medicalInfo,
      'createAt': createAt,
      'isSaved': isSaved,
    };
  }

  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      id: map['id'] != null ? map['id'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      responses: map['responses'] != null
          ? List<dynamic>.from((map['responses'] as List<dynamic>))
          : null,
      symptoms: map['symptoms'] != null
          ? List<dynamic>.from((map['symptoms'] as List<dynamic>))
          : null,
      metadata: map['metadata'] != null ? map['metadata'] as String : null,
      medicalInfo: map['medicalInfo'] != null
          ? Map<String, dynamic>.from(
              (map['medicalInfo'] as Map<String, dynamic>))
          : null,
      createAt: map['createAt'] != null ? map['createAt'] as int : null,
      isSaved: map['isSaved'] != null ? map['isSaved'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiagnosisModel.fromJson(String source) =>
      DiagnosisModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DiagnosisModel(id: $id, senderId: $senderId, responses: $responses, symptoms: $symptoms, metadata: $metadata, medicalInfo: $medicalInfo, createAt: $createAt, isSaved: $isSaved)';
  }

  @override
  bool operator ==(covariant DiagnosisModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderId == senderId &&
        listEquals(other.responses, responses) &&
        listEquals(other.symptoms, symptoms) &&
        other.metadata == metadata &&
        mapEquals(other.medicalInfo, medicalInfo) &&
        other.createAt == createAt &&
        other.isSaved == isSaved;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        responses.hashCode ^
        symptoms.hashCode ^
        metadata.hashCode ^
        medicalInfo.hashCode ^
        createAt.hashCode ^
        isSaved.hashCode;
  }
}
