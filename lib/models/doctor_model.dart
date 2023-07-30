// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

class DoctorModel {
  String? id;
  String? name;
  String? gender;
  String? email;
  String? password;
  String? phone;
  String? hospital;
  String? specialty;
  String? profile;
  double? rating;
  String? address;
  Map<String, dynamic>? availableTime;
  bool? isOnline;
  bool? isApproved;
  String? about;
  List<dynamic>? images;
  String? idImage;
  String? certificateImage;
  int? createdAt;
  DoctorModel({
    this.id,
    this.name,
    this.gender,
    this.email,
    this.password,
    this.phone,
    this.hospital,
    this.specialty,
    this.profile,
    this.rating = 1.5,
    this.address,
    this.availableTime = const {},
    this.isOnline,
    this.isApproved = true,
    this.about,
    this.images = const [],
    this.idImage,
    this.certificateImage,
    this.createdAt,
  });

  DoctorModel copyWith({
    String? id,
    String? name,
    String? gender,
    String? email,
    String? password,
    String? phone,
    String? hospital,
    String? specialty,
    String? profile,
    double? rating,
    String? address,
    Map<String, dynamic>? availableTime,
    bool? isOnline,
    bool? isApproved,
    String? about,
    List<String>? images,
    String? idImage,
    String? certificateImage,
    int? createdAt,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      hospital: hospital ?? this.hospital,
      specialty: specialty ?? this.specialty,
      profile: profile ?? this.profile,
      rating: rating ?? this.rating,
      address: address ?? this.address,
      availableTime: availableTime ?? this.availableTime,
      isOnline: isOnline ?? this.isOnline,
      isApproved: isApproved ?? this.isApproved,
      about: about ?? this.about,
      images: images ?? this.images,
      idImage: idImage ?? this.idImage,
      certificateImage: certificateImage ?? this.certificateImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'gender': gender,
      'email': email,
      'password': password,
      'phone': phone,
      'hospital': hospital,
      'specialty': specialty,
      'profile': profile,
      'rating': rating,
      'address': address,
      'availableTime': availableTime,
      'isOnline': isOnline,
      'isApproved': isApproved,
      'about': about,
      'images': images,
      'idImage': idImage,
      'certificateImage': certificateImage,
      'createdAt': createdAt,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      hospital: map['hospital'] != null ? map['hospital'] as String : null,
      specialty: map['specialty'] != null ? map['specialty'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      address: map['address'] != null ? map['address'] as String : null,
      availableTime: map['availableTime'] != null
          ? Map<String, dynamic>.from(
              (map['availableTime'] as Map<String, dynamic>))
          : null,
      isOnline: map['isOnline'] != null ? map['isOnline'] as bool : null,
      isApproved: map['isApproved'] != null ? map['isApproved'] as bool : null,
      about: map['about'] != null ? map['about'] as String : null,
      images: map['images'] != null
          ? List<dynamic>.from((map['images'] as List<dynamic>))
          : null,
      idImage: map['idImage'] != null ? map['idImage'] as String : null,
      certificateImage: map['certificateImage'] != null
          ? map['certificateImage'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorModel.fromJson(String source) =>
      DoctorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DoctorModel(id: $id, name: $name, gender: $gender, email: $email, password: $password, phone: $phone, hospital: $hospital, specialty: $specialty, profile: $profile, rating: $rating, address: $address, availableTime: $availableTime, isOnline: $isOnline, isApproved: $isApproved, about: $about, images: $images, idImage: $idImage, certificateImage: $certificateImage, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant DoctorModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.gender == gender &&
        other.email == email &&
        other.password == password &&
        other.phone == phone &&
        other.hospital == hospital &&
        other.specialty == specialty &&
        other.profile == profile &&
        other.rating == rating &&
        other.address == address &&
        mapEquals(other.availableTime, availableTime) &&
        other.isOnline == isOnline &&
        other.isApproved == isApproved &&
        other.about == about &&
        listEquals(other.images, images) &&
        other.idImage == idImage &&
        other.certificateImage == certificateImage &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        email.hashCode ^
        password.hashCode ^
        phone.hashCode ^
        hospital.hashCode ^
        specialty.hashCode ^
        profile.hashCode ^
        rating.hashCode ^
        address.hashCode ^
        availableTime.hashCode ^
        isOnline.hashCode ^
        isApproved.hashCode ^
        about.hashCode ^
        images.hashCode ^
        idImage.hashCode ^
        certificateImage.hashCode ^
        createdAt.hashCode;
  }

  Map<Object, Object?> updateMap() {
    //update only name, address,phone picture and about
    return <Object, Object?>{
      'name': name,
      'address': address,
      'phone': phone,
      'profile': profile,
      'about': about,
    };
  }
}

class DummyDoctors {
  static final Random _random = Random();
  static List<String> doctorsNames = [
    'Dr. Kofi Mensah',
    'Mrs. Akosua Mensah',
    'Mr. Kwame Owusu',
    'Miss Ama Mensah',
    'Dr. Nana Osei',
    'Mrs. Abena Appiah',
    'Mr. Kwesi Agyemang',
    'Miss Adwoa Boateng',
    'Dr. Kofi Ansah',
    'Mrs. Afua Mensah',
    'Mr. Kojo Boateng',
    'Miss Yaa Adjei',
    'Dr. Kwabena Darko',
    'Mrs. Akua Asante',
    'Mr. Kweku Addo',
    'Miss Efua Amoah',
    'Dr. Kwame Mensah',
    'Mrs. Abena Ofori',
    'Mr. Kofi Adu',
    'Miss Akosua Frimpong',
    'Dr. Nana Kwame',
    'Mrs. Adwoa Boateng',
    'Mr. Kwabena Osei',
    'Miss Ama Asare',
    'Dr. Kofi Antwi',
    'Mrs. Afia Owusu',
    'Mr. Kojo Gyasi',
    'Miss Yaa Ansah',
    'Dr. Kwesi Amponsah',
    'Mrs. Akosua Asamoah'
  ];
  static List<String> doctorsImages = [
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1530785602389-07594beb8b73?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1616805765352-beedbad46b2a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1563132337-f159f484226c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1617244147030-8bd6f9e21d1e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1606416041875-c020fd6cd16c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=391&q=80",
    "https://images.unsplash.com/photo-1578758803946-2c4f6738df87?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1573166953836-06864dc70a21?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
    "https://images.unsplash.com/photo-1514222709107-a180c68d72b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=449&q=80",
    "https://images.unsplash.com/photo-1571442463800-1337d7af9d2f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1173&q=80",
    "https://images.unsplash.com/photo-1617244146826-ce9182d9388b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1614533836100-dd83a8c04e29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1610473068514-276d33c606dd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1614533836096-fc5a112c07a4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1627595359082-cc2b3487a40b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80",
    "https://images.unsplash.com/photo-1508243771214-6e95d137426b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1571442463716-e3e186378445?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1173&q=80",
    "https://images.unsplash.com/photo-1621701582507-4e580f0c84f9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80",
    "https://images.unsplash.com/photo-1535469618671-e58a8c365cbd?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1524538198441-241ff79d153b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1489667897015-bf7a9e45c284?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=587&q=80",
    "https://images.unsplash.com/photo-1578758837674-93ed0ab5fbab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1575880918403-f578c9078302?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=580&q=80",
    "https://images.unsplash.com/photo-1621331938577-42f137e5d5f1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1655720357872-ce227e4164ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1589114207353-1fc98a11070b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1331&q=80",
    "https://images.unsplash.com/photo-1521510186458-bbbda7aef46b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=581&q=80",
    "https://images.unsplash.com/photo-1581368135153-a506cf13b1e1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1573496358961-3c82861ab8f4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=388&q=80",
    "https://images.unsplash.com/photo-1517598024396-46c53fb391a1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=435&q=80",
    "https://images.unsplash.com/photo-1618333453525-81f8582b1a3d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
    "https://images.unsplash.com/photo-1529688530647-93a6e1916f5f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=436&q=80",
  ];

  static List<String> doctorsEmails = [
    'kofimensah@gmail.com',
    'akomansah@gmail.com',
    'owusukwame@example.com',
    'amamensah@example.com',
    'nanaosei@example.com',
    'abenaappiah@example.com',
    'kwesiagyemang@example.com',
    'adwoaboateng@example.com',
    'kofiansah@example.com',
    'afuamensah@example.com',
    'koboateng@example.com',
    'yaadjei@example.com',
    'kwabenadarko@example.com',
    'akuaasante@example.com',
    'kwekuaddo@example.com',
    'efuaamoah@example.com',
    'kwamemensah@example.com',
    'abenaofori@example.com',
    'kofiadu@example.com',
    'akosuafrimpong@example.com',
    'nanakwame@example.com',
    'adwoaboateng@example.com',
    'kwabenaosei@example.com',
    'amaasare@example.com',
    'kofiantwi@example.com',
    'afiaowusu@example.com',
    'kojogyasi@example.com',
    'yaaansah@example.com',
    'kwesiamponsah@example.com',
    'akosuaasamoah@example.com',
  ];
  static List<String> doctorsAddresses = [
    'Block 5, Office 3, Accra',
    'Lapas, P.O. Box 234-4567, Accra',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
    'Kumasi, AK-234-4567',
    'Lapas, P.O. Box 234-4567, Accra',
    'Sunyani, BA-345-6789',
    'Tema, TP-789-0123',
  ];
  static List<String> doctorsPhoneNumbers = [
    '0248235689',
    '02458965656',
    '0557823456',
    '0245678921',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
    '0556789012',
    '0245678901',
    '0557823456',
    '02458965656',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
    '0556789012',
    '0245678901',
    '0557823456',
    '02458965656',
    '0509876543',
    '0278765432',
    '0263456789',
    '0234567890',
    '0541234567',
    '0209876543',
  ];

  static bool _getRandomBool() {
    return _random.nextBool();
  }

  static String _getRandomGender(bool isMan) {
    return isMan ? 'Male' : 'Female';
  }

  static String _getDoctorSpecialty() {
    //return random doctor specialty
    final doctorSpecialty = ['Dentist', 'Psychiatrist', 'Surgeon', 'Physician'];
    return doctorSpecialty[_random.nextInt(doctorSpecialty.length)];
  }

  static List<DoctorModel> doctorsList() {
    List<DoctorModel> counsellors = [];

    for (int i = 0; i < doctorsNames.length; i++) {
      bool isMan =
          doctorsNames[i].startsWith('Dr') || doctorsNames[i].startsWith('Mr');
      counsellors.add(
        DoctorModel(
          name: doctorsNames[i],
          email: doctorsEmails[i],
          address: doctorsAddresses[i],
          password: '',
          gender: _getRandomGender(isMan),
          phone: doctorsPhoneNumbers[i],
          hospital: _getHospitalName(),
          specialty: _getDoctorSpecialty(),
          profile: doctorsImages[i],
          //return random double between 1.5 and 5.0
          rating: 1.5 + _random.nextDouble() * (5.0 - 1.5),
          isOnline: _getRandomBool(),
        ),
      );
    }
    return counsellors;
  }

  static _getHospitalName() {
    //return 'AAMUSTED Clinic'or 'Kwadaso SDA Hospital'
    final hospitals = ['AAMUSTED Clinic', 'Kwadaso SDA Hospital'];
    return hospitals[_random.nextInt(hospitals.length)];
  }
}
