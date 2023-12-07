// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatModel {
  final String chatId;
  final String lastMessage;
  final DateTime lastMessageTime;
  final String collectorName;
  final String userName;
  final String collectorId;
  final String userId;
  final List<String> users;
  final List<String> messages;

  ChatModel(
      {required this.chatId,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.collectorName,
      required this.userName,
      required this.collectorId,
      required this.userId,
      required this.users,
      this.messages = const []});

  ChatModel copyWith({
    String? chatId,
    String? lastMessage,
    Timestamp? lastMessageTime,
    String? collectorName,
    String? userName,
    String? collectorId,
    String? userId,
    String? messages,
    List<String>? users,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: DateTime.fromMillisecondsSinceEpoch(lastMessageTime!.millisecondsSinceEpoch),
      collectorName: collectorName ?? this.collectorName,
      userName: userName ?? this.userName,
      collectorId: collectorId ?? this.collectorId,
      userId: userId ?? this.userId,
      users: users ?? this.users,
      messages:[]
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatId': chatId,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'collectorName': collectorName,
      'userName': userName,
      'collectorId': collectorId,
      'userId': userId,
      'users': users,
      'messages': messages,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        chatId: map['chatId'] as String,
        lastMessage: map['lastMessage'] as String,
        lastMessageTime: DateTime.fromMillisecondsSinceEpoch(map['lastMessageTime'].millisecondsSinceEpoch),
        collectorName: map['collectorName'] as String,
        userName: map['userName'] as String,
        collectorId: map['collectorId'] as String,
        userId: map['userId'] as String,
        
        users: List<String>.from(
          (map['users'] as List<dynamic>).map((e) => e.toString()),
        ));
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatModel(chatId: $chatId, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, collectorName: $collectorName, userName: $userName, collectorId: $collectorId, userId: $userId, users: $users)';
  }

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.chatId == chatId &&
        other.lastMessage == lastMessage &&
        other.lastMessageTime == lastMessageTime &&
        other.collectorName == collectorName &&
        other.userName == userName &&
        other.collectorId == collectorId &&
        other.userId == userId &&
        listEquals(other.users, users);
  }

  @override
  int get hashCode {
    return chatId.hashCode ^
        lastMessage.hashCode ^
        lastMessageTime.hashCode ^
        collectorName.hashCode ^
        userName.hashCode ^
        collectorId.hashCode ^
        userId.hashCode ^
        users.hashCode;
  }
}
