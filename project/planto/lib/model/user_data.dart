import 'package:flutter/material.dart';
String currentName = '';
String currentUser = '';
String currentNick = '';
class User{
  final String userId;
  final String pw;
  final String name;
  final String nickName;

  User({required this.userId, required this.pw, required this.name, required this.nickName});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'pw': pw,
    'name': name,
    'nick': nickName,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      pw: json['pw'],
      name: json['name'],
      nickName: json['nick'],
    );
  }
}