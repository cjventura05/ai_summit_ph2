import 'package:blankevent/pages/scanqr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../userinfo.dart';
import 'home.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  final _txtcode = TextEditingController();
  late bool _qrfound = false;
  late String qrcode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 25,
                      weight: 400,
                    ),
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Container(
                alignment: Alignment.center,

                //height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 2,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Image.asset(
                    'asset/images/AI Summit_KV_Final_With Partner Logos.jpg')),
            SizedBox(
              height: 30,
            ),
            Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //username
                    TextFormField(
                      controller: _txtcode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide.none),
                          fillColor: const Color.fromARGB(255, 233, 233, 233),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 187, 187, 187))),
                          filled: true,
                          hintText: 'Enter your code',
                          errorText: _qrfound ? 'Your code not found' : null,
                          suffixIcon: IconButton(
                            splashColor: Colors.transparent,
                            onPressed: _txtcode.clear,
                            icon: const Icon(
                              Icons.clear,
                              color: Color.fromARGB(255, 187, 187, 187),
                            ),
                          )),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your code';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        qrcode = value;
                        //Do something with the user input.
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    //Login
                    ElevatedButton(
                      onPressed: () async {
                        _qrfound = false;

                        if (_formKey.currentState!.validate()) {
                          checkQRcode(qrcode);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //or continue
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                            width: 60,
                            child: Divider(
                                thickness: 1,
                                color: Color.fromARGB(87, 0, 0, 0),
                                height: 10)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Or continue with",
                          style:
                              TextStyle(color: Color.fromARGB(255, 83, 83, 83)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: 60,
                            child: Divider(
                                thickness: 1,
                                color: Color.fromARGB(87, 0, 0, 0),
                                height: 10)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //connect to facebook
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QRViewExample()),
                        );
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ))),
                      icon: const Icon(
                        // <-- Icon
                        CupertinoIcons.qrcode_viewfinder,
                        size: 27.0,
                      ),
                      label: const Padding(
                        padding: EdgeInsets.only(left: 5, top: 15, bottom: 15),
                        child: Text('Login with QR Code',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                      ), // <-- Text
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                )),
          ],
        ),
      ),
    )));
  }

  checkQRcode(String qrcoderesult) {
    FirebaseFirestore.instance
        .collection('user')
        .where('qrcode', isEqualTo: qrcoderesult)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final field1 = snapshot.docs[0].get('fname') ?? '';
        final field2 = snapshot.docs[0].get('lname') ?? '';
        final field3 = snapshot.docs[0].get('position') ?? '';
        final field4 = snapshot.docs[0].get('company') ?? '';
        List<dynamic> friends = snapshot.docs[0].get('friends') ?? '';
        listOfFriends.addAll(friends);

        List<String> fields = [field1, field2, field3, field4];
        userinfo = fields;
        currentuserid = snapshot.docs[0].id;
        print(userinfo);
        setState(() {
          notifier.value = true;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Welcome, $field1!'),
              content: const Text('You have successfully logged in.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _qrfound = true;
        });
      }
    }).catchError((error) => null);
  }
}
