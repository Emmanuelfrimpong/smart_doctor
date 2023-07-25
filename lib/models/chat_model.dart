// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  String? id;
  String? sessionId;
  int? sessionDateTimestamp;
  String? status;
  bool? userDeleted;
  bool? counsellorDeleted;
  String? lastMessage;
  int? lastMessageTimestamp;
  String? lastMessageSender;
  int? endedAt;
  ChatModel({
    this.id,
    this.sessionId,
    this.sessionDateTimestamp,
    this.status,
    this.userDeleted,
    this.counsellorDeleted,
    this.lastMessage,
    this.lastMessageTimestamp,
    this.lastMessageSender,
    this.endedAt,
  });

  ChatModel copyWith({
    String? id,
    String? sessionId,
    int? sessionDateTimestamp,
    String? status,
    bool? userDeleted,
    bool? counsellorDeleted,
    String? lastMessage,
    int? lastMessageTimestamp,
    String? lastMessageSender,
    int? endedAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      sessionDateTimestamp: sessionDateTimestamp ?? this.sessionDateTimestamp,
      status: status ?? this.status,
      userDeleted: userDeleted ?? this.userDeleted,
      counsellorDeleted: counsellorDeleted ?? this.counsellorDeleted,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sessionId': sessionId,
      'sessionDateTimestamp': sessionDateTimestamp,
      'status': status,
      'userDeleted': userDeleted,
      'counsellorDeleted': counsellorDeleted,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
      'lastMessageSender': lastMessageSender,
      'endedAt': endedAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] != null ? map['id'] as String : null,
      sessionId: map['sessionId'] != null ? map['sessionId'] as String : null,
      sessionDateTimestamp: map['sessionDateTimestamp'] != null
          ? map['sessionDateTimestamp'] as int
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      userDeleted:
          map['userDeleted'] != null ? map['userDeleted'] as bool : null,
      counsellorDeleted: map['counsellorDeleted'] != null
          ? map['counsellorDeleted'] as bool
          : null,
      lastMessage:
          map['lastMessage'] != null ? map['lastMessage'] as String : null,
      lastMessageTimestamp: map['lastMessageTimestamp'] != null
          ? map['lastMessageTimestamp'] as int
          : null,
      lastMessageSender: map['lastMessageSender'] != null
          ? map['lastMessageSender'] as String
          : null,
      endedAt: map['endedAt'] != null ? map['endedAt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(id: $id, sessionId: $sessionId, sessionDateTimestamp: $sessionDateTimestamp, status: $status, userDeleted: $userDeleted, counsellorDeleted: $counsellorDeleted, lastMessage: $lastMessage, lastMessageTimestamp: $lastMessageTimestamp, lastMessageSender: $lastMessageSender, endedAt: $endedAt)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.sessionId == sessionId &&
        other.sessionDateTimestamp == sessionDateTimestamp &&
        other.status == status &&
        other.userDeleted == userDeleted &&
        other.counsellorDeleted == counsellorDeleted &&
        other.lastMessage == lastMessage &&
        other.lastMessageTimestamp == lastMessageTimestamp &&
        other.lastMessageSender == lastMessageSender &&
        other.endedAt == endedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sessionId.hashCode ^
        sessionDateTimestamp.hashCode ^
        status.hashCode ^
        userDeleted.hashCode ^
        counsellorDeleted.hashCode ^
        lastMessage.hashCode ^
        lastMessageTimestamp.hashCode ^
        lastMessageSender.hashCode ^
        endedAt.hashCode;
  }
}
