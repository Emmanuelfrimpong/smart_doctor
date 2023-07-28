// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ConsultationModel {
  String? id;
  String? userId;
  List<dynamic>? ids;
  String? doctorId;
  String? doctorName;
  String? doctorImage;
  String? userName;
  String? userImage;
  String? status;
  int? endedAt;
  int? createdAt;
  String? doctorSpecialty;
  ConsultationModel({
    this.id,
    this.userId,
    this.ids,
    this.doctorId,
    this.doctorName,
    this.doctorImage,
    this.userName,
    this.userImage,
    this.status,
    this.endedAt,
    this.createdAt,
    this.doctorSpecialty,
  });

  ConsultationModel copyWith({
    String? id,
    String? userId,
    List<dynamic>? ids,
    String? doctorId,
    String? doctorName,
    String? doctorImage,
    String? userName,
    String? userImage,
    String? status,
    int? endedAt,
    int? createdAt,
    String? doctorSpecialty,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorImage: doctorImage ?? this.doctorImage,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      status: status ?? this.status,
      endedAt: endedAt ?? this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'ids': ids,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'userName': userName,
      'userImage': userImage,
      'status': status,
      'endedAt': endedAt,
      'createdAt': createdAt,
      'doctorSpecialty': doctorSpecialty,
    };
  }

  factory ConsultationModel.fromMap(Map<String, dynamic> map) {
    return ConsultationModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      ids: map['ids'] != null
          ? List<dynamic>.from((map['ids'] as List<dynamic>))
          : null,
      doctorId: map['doctorId'] != null ? map['doctorId'] as String : null,
      doctorName:
          map['doctorName'] != null ? map['doctorName'] as String : null,
      doctorImage:
          map['doctorImage'] != null ? map['doctorImage'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      endedAt: map['endedAt'] != null ? map['endedAt'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      doctorSpecialty: map['doctorSpecialty'] != null
          ? map['doctorSpecialty'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationModel.fromJson(String source) =>
      ConsultationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConsultationModel(id: $id, userId: $userId, ids: $ids, doctorId: $doctorId, doctorName: $doctorName, doctorImage: $doctorImage, userName: $userName, userImage: $userImage, status: $status, endedAt: $endedAt, createdAt: $createdAt, doctorSpecialty: $doctorSpecialty)';
  }

  @override
  bool operator ==(covariant ConsultationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.ids, ids) &&
        other.doctorId == doctorId &&
        other.doctorName == doctorName &&
        other.doctorImage == doctorImage &&
        other.userName == userName &&
        other.userImage == userImage &&
        other.status == status &&
        other.endedAt == endedAt &&
        other.createdAt == createdAt &&
        other.doctorSpecialty == doctorSpecialty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        doctorId.hashCode ^
        doctorName.hashCode ^
        doctorImage.hashCode ^
        userName.hashCode ^
        userImage.hashCode ^
        status.hashCode ^
        endedAt.hashCode ^
        createdAt.hashCode ^
        doctorSpecialty.hashCode;
  }
}
