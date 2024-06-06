import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/friend_data.dart';

Future<List<Friend>> getFriendsByUserId(String userId) async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/user-friends/getFriends?userId=$userId'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<Friend> friends = body.map((dynamic item) => Friend.fromJson(item)).toList();
    return friends;
  } else {
    throw Exception('Failed to load friends');
  }
}

Future<String> addUserFriend(Friend userFriend) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/user-friends/userFriends'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': userFriend.userId,
      'friendName': userFriend.friendName,
      'friendNick': userFriend.friendNick,
      'friendId': userFriend.friendId,
    }),
  );

  if (response.statusCode == 200) {
    return "User friend added successfully";
  } else {
    return "User friend already exists"; // 실제 응답에 따라 메시지를 조정할 필요가 있을 수 있습니다.
  }
}