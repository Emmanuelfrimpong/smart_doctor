// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AppointmentModel {
  String? id;
  String? userId;
  List<dynamic>? ids;
  String? doctorId;
  int? date;
  int? time;
  String? status;
  String? doctorName;
  String? doctorImage;
  String? userImage;
  String? userName;
  bool? doctorState;
  bool? userState;
  int? createdAt;
  AppointmentModel({
    this.id,
    this.userId,
    this.ids,
    this.doctorId,
    this.date,
    this.time,
    this.status,
    this.doctorName,
    this.doctorImage,
    this.userImage,
    this.userName,
    this.userState,
    this.createdAt,
  });

  Map<String, dynamic> rescheduleMap() {
    return <String, dynamic>{
      'date': date,
      'time': time,
      'status': 'Pending',
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? userId,
    List<dynamic>? ids,
    String? doctorId,
    int? date,
    int? time,
    String? status,
    String? doctorName,
    String? doctorImage,
    String? userImage,
    String? userName,
    bool? userState,
    int? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ids: ids ?? this.ids,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      doctorName: doctorName ?? this.doctorName,
      doctorImage: doctorImage ?? this.doctorImage,
      userImage: userImage ?? this.userImage,
      userName: userName ?? this.userName,
      userState: userState ?? this.userState,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'ids': ids,
      'doctorId': doctorId,
      'date': date,
      'time': time,
      'status': status,
      'doctorName': doctorName,
      'doctorImage': doctorImage,
      'userImage': userImage,
      'userName': userName,
      'userState': userState,
      'createdAt': createdAt,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      ids: map['ids'] != null
          ? List<dynamic>.from((map['ids'] as List<dynamic>))
          : null,
      doctorId: map['doctorId'] != null ? map['doctorId'] as String : null,
      date: map['date'] != null ? map['date'] as int : null,
      time: map['time'] != null ? map['time'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      doctorName:
          map['doctorName'] != null ? map['doctorName'] as String : null,
      doctorImage:
          map['doctorImage'] != null ? map['doctorImage'] as String : null,
      userImage: map['userImage'] != null ? map['userImage'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      userState: map['userState'] != null ? map['userState'] as bool : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppointmentModel(id: $id, userId: $userId, ids: $ids, doctorId: $doctorId, date: $date, time: $time, status: $status, doctorName: $doctorName, doctorImage: $doctorImage, userImage: $userImage, userName: $userName, userState: $userState, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant AppointmentModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        listEquals(other.ids, ids) &&
        other.doctorId == doctorId &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.doctorName == doctorName &&
        other.doctorImage == doctorImage &&
        other.userImage == userImage &&
        other.userName == userName &&
        other.userState == userState &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        ids.hashCode ^
        doctorId.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        doctorName.hashCode ^
        doctorImage.hashCode ^
        userImage.hashCode ^
        userName.hashCode ^
        userState.hashCode ^
        createdAt.hashCode;
  }
}
