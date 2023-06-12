// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class DoctorModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? hospital;
  String? specialty;
  String? profile;
  double? rating;
  Map<String, dynamic>? location;
  Map<String, dynamic>? availableTime;
  bool? isOnline;
  bool? isApproved;
  String? about;
  List<String>? images;
  DoctorModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.hospital,
    this.specialty,
    this.profile,
    this.rating,
    this.location,
    this.availableTime,
    this.isOnline,
    this.isApproved,
    this.about,
    this.images,
  });

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? hospital,
    String? specialty,
    String? profile,
    double? rating,
    Map<String, dynamic>? location,
    Map<String, dynamic>? availableTime,
    bool? isOnline,
    bool? isApproved,
    String? about,
    List<String>? images,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      hospital: hospital ?? this.hospital,
      specialty: specialty ?? this.specialty,
      profile: profile ?? this.profile,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      availableTime: availableTime ?? this.availableTime,
      isOnline: isOnline ?? this.isOnline,
      isApproved: isApproved ?? this.isApproved,
      about: about ?? this.about,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'hospital': hospital,
      'specialty': specialty,
      'profile': profile,
      'rating': rating,
      'location': location,
      'availableTime': availableTime,
      'isOnline': isOnline,
      'isApproved': isApproved,
      'about': about,
      'images': images,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      hospital: map['hospital'] != null ? map['hospital'] as String : null,
      specialty: map['specialty'] != null ? map['specialty'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      location: map['location'] != null
          ? Map<String, dynamic>.from((map['location'] as Map<String, dynamic>))
          : null,
      availableTime: map['availableTime'] != null
          ? Map<String, dynamic>.from(
              (map['availableTime'] as Map<String, dynamic>))
          : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : null,
      about: map['about'] != null ? map['about'] as String : null,
      images: map['images'] != null
          ? List<String>.from((map['images'] as List<String>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorModel.fromJson(String source) =>
      DoctorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DoctorModel(id: $id, name: $name, email: $email, password: $password, phone: $phone, hospital: $hospital, specialty: $specialty, profile: $profile, rating: $rating, location: $location, availableTime: $availableTime, isOnline: $isOnline, isApproved: $isApproved, about: $about, images: $images)';
  }

  @override
  bool operator ==(covariant DoctorModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.phone == phone &&
        other.hospital == hospital &&
        other.specialty == specialty &&
        other.profile == profile &&
        other.rating == rating &&
        mapEquals(other.location, location) &&
        mapEquals(other.availableTime, availableTime) &&
        other.isOnline == isOnline &&
        other.isApproved == isApproved &&
        other.about == about &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        hospital.hashCode ^
        specialty.hashCode ^
        profile.hashCode ^
        rating.hashCode ^
        location.hashCode ^
        availableTime.hashCode ^
        isOnline.hashCode ^
        isApproved.hashCode ^
        about.hashCode ^
        images.hashCode;
  }
}
