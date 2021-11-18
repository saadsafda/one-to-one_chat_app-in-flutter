// ignore_for_file: deprecated_member_use

import 'package:chat_app/Authenticate/Methods.dart';
import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> frendsList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Home Screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.lock_sharp),
            onPressed: () => logOut(context),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SingleChildScrollView(
                  child: Flexible(
                    child: ListView.builder(
                      itemCount: frendsList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://picsum.photos/250?image'),
                          ),
                          title: Text(frendsList[index]['name']),
                          subtitle: Text(frendsList[index]['email']),
                          onTap: () {
                            // implement the chat room here with the user id
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  chatRoomId: chatRoomId(_auth.currentUser!.uid,
                                      frendsList[index]['uid']),
                                  user1: _auth.currentUser!.uid,
                                  user2: frendsList[index]['uid'],
                                  userMap: {},
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        keyboardType: TextInputType.emailAddress,
                        decoration: kMessageTextFieldDecoration.copyWith(
                          hintText: "Search for a user",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.lightBlue,
                      ),
                      onPressed: onSearch,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: onSearch,
                //   child: Text(
                //     "Search",
                //   ),
                // ),
                SizedBox(
                  height: size.height / 30,
                ),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          bool isAlreadyExist = false;

                          for (int i = 0; i < frendsList.length; i++) {
                            if (frendsList[i]['uid'] == userMap!['uid']) {
                              isAlreadyExist = true;
                            }
                          }

                          if (!isAlreadyExist) {
                            setState(() {
                              frendsList.add({
                                "name": userMap!['name'],
                                "email": userMap!['email'],
                                "uid": userMap!['uid'],
                                "isAdmin": false,
                              });

                              userMap = null;
                            });
                          }
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage('https://picsum.photos/250?image'),
                        ),
                        title: Text(
                          userMap!['name'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(userMap!['email']),
                        trailing: Icon(
                          Icons.chat_outlined,
                          color: Colors.lightBlueAccent,
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            "No users found! Please find your friend's email and chat one to one.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.group),
      //   onPressed: () => Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (_) => GroupChatHomeScreen(),
      //     ),
      //   ),
      // ),
    );
  }
}
