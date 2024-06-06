import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/friend_data.dart';

class FriendService {
  final String baseUrl = "http://10.0.2.2:8080/friend"; // 서버 주소를 적절히 수정하세요.

  Future<String> addFriend(Friend friend) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(friend.toJson()),
    );

    if (response.statusCode == 200) {
      return "Friend added successfully";
    } else {
      return "Failed to add friend";
    }
  }

  Future<String> deleteFriend(String userId, String friendId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete?userId=$userId&friendId=$friendId'),
    );

    if (response.statusCode == 200) {
      return "Friend deleted successfully";
    } else {
      return "Failed to delete friend";
    }
  }

  Future<List<Friend>> listFriends(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/list?userId=$userId'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Friend.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }
}