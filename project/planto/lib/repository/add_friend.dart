import 'package:http/http.dart' as http;
import 'package:planto/model/add_friend.dart';
import 'dart:convert';

import '../model/friend_data.dart';

class AddFriendRepository {
  final String baseUrl = "http://10.0.2.2:8080"; 

  // final String baseUrl;

  // AddFriendRepository({required this.baseUrl});

  Future<bool> addFriend(Friend addFriend) async {
    final response = await http.post(
      Uri.parse('$baseUrl/friend/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(addFriend.toJson()),
    );

    return response.body == 'Friend added successfully';
  }

  Future<bool> deleteFriendFromMe(String userId, String friendId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/friend/fromme/delete?userId=$userId&friendId=$friendId'),
    );

    return response.body == 'Friend deleted successfully';
  }

  Future<bool> deleteFriendToMe(String userId, String friendId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/friend/tome/delete?userId=$userId&friendId=$friendId'),
    );

    return response.body == 'Friend deleted successfully';
  }

  Future<List<AddFriend>> listFriendsToMe(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/friend/tome/list?userId=$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> friendsJson = jsonDecode(response.body);
      return friendsJson.map((json) => AddFriend.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }

  Future<List<AddFriend>> listFriendsFromMe(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/friend/fromme/list?userId=$userId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> friendsJson = jsonDecode(response.body);
      return friendsJson.map((json) => AddFriend.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }
}