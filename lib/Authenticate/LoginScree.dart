// import 'package:chat_app/Authenticate/CreateAccount.dart';
// ignore_for_file: deprecated_member_use

import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/widget/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Container(
                          height: 200.0,
                          child: Image.asset('images/logo.png'),
                        ),
                      ),
                      SizedBox(
                        height: 48.0,
                      ),
                      TextField(
                        // onChanged: (value) {
                        //   //Do something with the user input.
                        // },
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your email',
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        // onChanged: (value) {
                        //   //Do something with the user input.
                        // },
                        controller: _password,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your password',
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                        title: 'Log In',
                        onPressed: () async {
                          if (_email.text.isNotEmpty &&
                              _password.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });

                            logIn(_email.text, _password.text).then((user) {
                              if (user != null) {
                                print("Login Sucessfull");

                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                              } else {
                                print("Login Failed");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            });
                          } else {
                            print("Please fill form correctly");
                          }
                        },
                      ),
                      // customButton(size),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Widget customButton(Size size) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
  //         setState(() {
  //           isLoading = true;
  //         });

  //         logIn(_email.text, _password.text).then((user) {
  //           if (user != null) {
  //             print("Login Sucessfull");

  //             setState(() {
  //               isLoading = false;
  //             });
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (_) => HomeScreen()));
  //           } else {
  //             print("Login Failed");
  //             setState(() {
  //               isLoading = false;
  //             });
  //           }
  //         });
  //       } else {
  //         print("Please fill form correctly");
  //       }
  //     },
  //     child: Container(
  //         height: size.height / 14,
  //         width: size.width / 1.2,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5),
  //           color: Colors.blue,
  //         ),
  //         alignment: Alignment.center,
  //         child: Text(
  //           "Login",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 18,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         )),
  //   );
  // }

  // Widget field(
  //     Size size, String hintText, IconData icon, TextEditingController cont) {
  //   return Container(
  //     height: size.height / 14,
  //     width: size.width / 1.1,
  //     child: TextField(
  //       controller: cont,
  //       decoration: InputDecoration(
  //         prefixIcon: Icon(icon),
  //         hintText: hintText,
  //         hintStyle: TextStyle(color: Colors.grey),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
