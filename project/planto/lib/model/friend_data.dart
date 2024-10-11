import 'package:flutter/material.dart';

class Friend{
  final String userId;
  final String friendNick;
  final String friendName;
  final String friendId;

  Friend({required this.userId,required this.friendNick,required this.friendName,required this.friendId});


  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userId: json['userId'],
      friendNick: json['friendNick'],
      friendName: json['friendName'],
      friendId: json['friendId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    
    'friendName': friendName,
    'friendNick': friendNick,
    'friendId': friendId,
    
  };

}