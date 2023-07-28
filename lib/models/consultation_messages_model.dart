// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConsultationMessagesModel {
  String? id;
  String? message;
  String? senderId;
  String? receiverId;
  String? senderName;
  String? receiverName;
  String? senderImage;
  String? receiverImage;
  String? consultationId;
  int? createdAt;
  bool? isRead;
  String? type;
  String? mediaFile;
  ConsultationMessagesModel({
    this.id,
    this.message,
    this.senderId,
    this.receiverId,
    this.senderName,
    this.receiverName,
    this.senderImage,
    this.receiverImage,
    this.consultationId,
    this.createdAt,
    this.isRead,
    this.type,
    this.mediaFile,
  });

  ConsultationMessagesModel copyWith({
    String? id,
    String? message,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    String? senderImage,
    String? receiverImage,
    String? consultationId,
    int? createdAt,
    bool? isRead,
    String? type,
    String? mediaFile,
  }) {
    return ConsultationMessagesModel(
      id: id ?? this.id,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      senderImage: senderImage ?? this.senderImage,
      receiverImage: receiverImage ?? this.receiverImage,
      consultationId: consultationId ?? this.consultationId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      mediaFile: mediaFile ?? this.mediaFile,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderImage': senderImage,
      'receiverImage': receiverImage,
      'consultationId': consultationId,
      'createdAt': createdAt,
      'isRead': isRead,
      'type': type,
      'mediaFile': mediaFile,
    };
  }

  factory ConsultationMessagesModel.fromMap(Map<String, dynamic> map) {
    return ConsultationMessagesModel(
      id: map['id'] != null ? map['id'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      senderName:
          map['senderName'] != null ? map['senderName'] as String : null,
      receiverName:
          map['receiverName'] != null ? map['receiverName'] as String : null,
      senderImage:
          map['senderImage'] != null ? map['senderImage'] as String : null,
      receiverImage:
          map['receiverImage'] != null ? map['receiverImage'] as String : null,
      consultationId: map['consultationId'] != null
          ? map['consultationId'] as String
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as int : null,
      isRead: map['isRead'] != null ? map['isRead'] as bool : null,
      type: map['type'] != null ? map['type'] as String : null,
      mediaFile: map['mediaFile'] != null ? map['mediaFile'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationMessagesModel.fromJson(String source) =>
      ConsultationMessagesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConsultationMessagesModel(id: $id, message: $message, senderId: $senderId, receiverId: $receiverId, senderName: $senderName, receiverName: $receiverName, senderImage: $senderImage, receiverImage: $receiverImage, consultationId: $consultationId, createdAt: $createdAt, isRead: $isRead, type: $type, mediaFile: $mediaFile)';
  }

  @override
  bool operator ==(covariant ConsultationMessagesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.senderName == senderName &&
        other.receiverName == receiverName &&
        other.senderImage == senderImage &&
        other.receiverImage == receiverImage &&
        other.consultationId == consultationId &&
        other.createdAt == createdAt &&
        other.isRead == isRead &&
        other.type == type &&
        other.mediaFile == mediaFile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        senderName.hashCode ^
        receiverName.hashCode ^
        senderImage.hashCode ^
        receiverImage.hashCode ^
        consultationId.hashCode ^
        createdAt.hashCode ^
        isRead.hashCode ^
        type.hashCode ^
        mediaFile.hashCode;
  }
}
