import 'package:flutter/material.dart';

import '../model/user_data.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController controllerPW = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User 정보'),
      ),
      body: Builder(
        builder:(context){
          return GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child : SizedBox(
                      height: 190.0,
                      child: Center(
                        child: Text(
                          "회원 정보 수정",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  Form(
                      child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.teal,
                              inputDecorationTheme: InputDecorationTheme(
                                  labelStyle: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 15.0
                                  )
                              )
                          ),
                          child: Container(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                        'ID:',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15),
                                    ),
                                    Text(currentUser),
                                  ],
                                ),
                                TextField(
                                  controller: controllerPW,
                                  decoration: InputDecoration(
                                      labelText: 'Password'
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '이름:',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15),
                                    ),
                                    Text(currentNick),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '닉네임:',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 15),
                                    ),
                                    Text('testNick'),
                                  ],
                                ),
                                SizedBox(height: 40.0,),
                                ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if(controllerPW.text.isEmpty){
                                          showSnackBarE(context);
                                        }
                                        else if(controllerPW.text.length <3){
                                          showSnackBarPW(context);
                                        }else {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('확인'),
                                    )
                                ),

                              ],
                            ),
                          )
                      )
                  )
                ],
              ),
            ),
          );
        },
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
void showSnackBarPW(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '비밀번호가 너무 짧습니다.',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue,
    ),
  );
}

void showSnackBarE(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '빈칸이 존재합니다!',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue,
    ),
  );
}