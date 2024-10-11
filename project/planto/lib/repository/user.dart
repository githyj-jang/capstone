import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_data.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> fetchLogIn(String userId, String userPw) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/user/login?userId='+userId+'&pw='+userPw),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    String responseBody = response.body;

    if (responseBody == 'Login successful') {
      print('Log in success!');
      return true;
    } else if (responseBody == 'Invalid Id or password') {
      print('Invalid Id or password');
      return false;
    } else {
      // 다른 메시지가 있을 경우
      print('Unknown response: $responseBody');
      return false;
    }
  } else {
    // 서버로부터 에러 응답을 받았을 경우
    print('Failed to log in');
    return false;
  }
}


Future<bool> registerUser(User user) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/user/register'), // 서버 주소를 적절히 수정해주세요.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'userId': user.userId,
      'name': user.name,
      'nick': user.nickName,
      'pw': user.pw,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> changePassword(String userId, String pw) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/user/changePassword?userId=$userId&pw=$pw'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response.body == 'Password changed successfully';
}

Future<List<User>> searchUsers(String searchTerm) async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/user/search?searchTerm=$searchTerm'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> usersJson = jsonDecode(response.body);
    return usersJson.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
Future<User?> getUserById(String userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/user/get?userId=$userId'),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }



