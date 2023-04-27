import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../userinfo.dart';
import 'home.dart';
import 'loginpage.dart';

class checklogin extends StatefulWidget {
  const checklogin({super.key});

  @override
  State<checklogin> createState() => _checkloginState();
}

class _checkloginState extends State<checklogin> {
  late Stream<List<String>> userinfoStream;
  void initState() {
    super.initState();
    userinfoStream = StreamController<List<String>>.broadcast()
        .stream; // initialize the stream
  }

  void updateUserInfo(List<String> newUserInfo) {
    setState(() {
      userinfo = newUserInfo;
    });
    (userinfoStream as StreamController)
        .add(userinfo); // add the updated userinfo list to the stream
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: userinfoStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // the userinfo list has data
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Welcome ${snapshot.data![0]}!'),
                ElevatedButton(
                  onPressed: () {
                    updateUserInfo([]); // clear the userinfo list
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            const HomePage())); // navigate to the home page
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        } else {
          // the userinfo list is empty
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You are not logged in.'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogIn()),
                    ); // navigate to the login page
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
