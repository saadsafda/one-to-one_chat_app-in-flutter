import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/widget/rounded_button.dart';
import 'package:flutter/material.dart';

import '../Screens/HomeScreen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
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
                        controller: _name,
                        // onChanged: (value) {
                        //   //Do something with the user input.
                        // },
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your name',
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
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
                        title: "Sign Up",
                        onPressed: () async {
                          if (_name.text.isNotEmpty &&
                              _email.text.isNotEmpty &&
                              _password.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });

                            createAccount(
                                    _name.text, _email.text, _password.text)
                                .then((user) {
                              if (user != null) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()));
                                print("Account Created Sucessfull");
                              } else {
                                print("Login Failed");
                                setState(() {
                                  AlertDialog(
                                    title: Text("Error"),
                                    content: Text("Account not created"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                  isLoading = false;
                                });
                              }
                            });
                          } else {
                            setState(() {
                              AlertDialog(
                                title: Text("Warnig"),
                                content: Text("Please enter Fields"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                              isLoading = false;
                            });
                            print("Please enter Fields");
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
  //       if (_name.text.isNotEmpty &&
  //           _email.text.isNotEmpty &&
  //           _password.text.isNotEmpty) {
  //         setState(() {
  //           isLoading = true;
  //         });

  //         createAccount(_name.text, _email.text, _password.text).then((user) {
  //           if (user != null) {
  //             setState(() {
  //               isLoading = false;
  //             });
  //             Navigator.push(
  //                 context, MaterialPageRoute(builder: (_) => HomeScreen()));
  //             print("Account Created Sucessfull");
  //           } else {
  //             print("Login Failed");
  //             setState(() {
  //               isLoading = false;
  //             });
  //           }
  //         });
  //       } else {
  //         print("Please enter Fields");
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
  //           "Create Account",
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
