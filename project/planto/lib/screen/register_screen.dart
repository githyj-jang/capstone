import 'package:flutter/material.dart';
import '../model/user_data.dart';
import '../repository/user.dart';
import './calendar_screen.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController controllerID = TextEditingController();
  TextEditingController controllerPW = TextEditingController();
  TextEditingController controllerN = TextEditingController();
  TextEditingController controllerNN = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          "회원가입",
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
                                TextField(
                                  controller: controllerID,
                                  decoration: InputDecoration(
                                      labelText: 'ID'
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                TextField(
                                  controller: controllerPW,
                                  decoration: InputDecoration(
                                      labelText: 'Password'
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                TextField(
                                  controller: controllerN,
                                  decoration: InputDecoration(
                                      labelText: '이름'
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                TextField(
                                  controller: controllerNN,
                                  decoration: InputDecoration(
                                      labelText: '별명'
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                                SizedBox(height: 40.0,),
                                ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        User user = User(
                                            userId:controllerID.text,
                                            pw: controllerPW.text,
                                            name: controllerN.text,
                                            nickName: controllerNN.text

                                        );
                                        if(controllerID.text.isEmpty || controllerPW.text.isEmpty || controllerN.text.isEmpty || controllerNN.text.isEmpty){
                                          showSnackBarE(context);
                                        }
                                        else if(controllerPW.text.length <3){
                                          showSnackBarPW(context);
                                        }else if(!(await registerUser(user))){
                                          showSnackBarNN(context);
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
void showSnackBarNN(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '중복된 유저가 이미 존재합니다.',
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