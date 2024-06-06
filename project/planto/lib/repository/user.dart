import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/user_data.dart';

Future<bool> fetchLogIn(String userId, String userPw) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/user/login?userId='+userId+'&pw='+userPw),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
   return true;
    print('log in success!');
  } else {
    // 서버로부터 에러 응답을 받았을 경우
    return false;
    throw Exception('Failed to log in');
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
      'pw': user.pw,
      'name': user.name,
      'nick': user.nickName,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List<User>> searchUsers(String searchTerm) async {
  final response = await http.get(Uri.parse('http://your-server-address/search?searchTerm=$searchTerm'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
    return users;
  } else {
    throw Exception('Failed to load users');
  }
}

Future<User> searchOneUsers(String searchTerm) async {
  final response = await http.get(Uri.parse('http://your-server-address/search?searchTerm=$searchTerm'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<User> users = body.map((dynamic item) => User.fromJson(item)).toList();
    return users.first;
  } else {
    throw Exception('Failed to load users');
  }
}

