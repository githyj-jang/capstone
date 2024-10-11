import 'package:flutter/material.dart';
import 'package:planto/screen/main_screen.dart';
import '../model/user_data.dart';
import '../repository/user.dart';
import './register_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController controllerID = TextEditingController();
  TextEditingController controllerPW = TextEditingController();

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
                  const Center(
                    child : SizedBox(
                      height: 190.0,
                      child: Center(
                        child: Text(
                          "Planto",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 50),
                        ),
                      ),
                    ),
                  ),
                  Form(
                      child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.teal,
                              inputDecorationTheme: const InputDecorationTheme(
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
                                  decoration: const InputDecoration(
                                      labelText: 'Enter "ID"'
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                TextField(
                                  controller: controllerPW,
                                  decoration: InputDecoration(
                                      labelText: 'Enter "Password"'
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                ),
                                SizedBox(height: 40.0,),
                                ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () async {

                                        if((await fetchLogIn(controllerID.text,controllerPW.text))){
                                          currentUser = controllerID.text;

                                          Future<User?> userDataFuture = getUserById(controllerID.text);

                                          User? userData = await userDataFuture;
                                          currentNick = userData?.nickName ?? "defaultNick";
                                          currentName = userData?.nickName ?? "defaultName";

                                          userDataFuture.then((userData) {
                                            currentNick = userData?.nickName ?? "defaultNick";
                                            currentName = userData?.nickName ?? "defaultName";
                                          }).catchError((error) {
                                            currentNick = "testNick1";
                                            print('Error: $error');
                                          });
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
                                        }else {
                                          showSnackBar(context);
                                        }
                                      },
                                      child: Text('로그인'),
                                    )
                                ),
                                SizedBox(height: 20.0,),
                                ButtonTheme(
                                    minWidth: 100.0,
                                    height: 50.0,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context)=>Register()));
                                      },
                                      child: Text('회원가입'),
                                    )
                                )
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

void showSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '로그인 정보를 다시 확인해주세요',
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.blue,
    ),
  );
}