// ignore_for_file: avoid_print

import 'package:blankevent/pages/schedform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';
import '../userinfo.dart';
import 'notification.dart';

class ListOfDelegate extends StatefulWidget {
  const ListOfDelegate({super.key});

  @override
  State<ListOfDelegate> createState() => _ListOfDelegateState();
}

class _ListOfDelegateState extends State<ListOfDelegate> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? checkuser;
  final db = FirebaseFirestore.instance;
  Map<String, dynamic> docsMap = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: const DrawerPage(),
        appBar: MyAppBar(
          onMenuPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                currentuserid != ''
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("user")
                            .where(FieldPath.documentId,
                                isNotEqualTo: currentuserid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.white,
                                child: Container());
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Text("No User"),
                            );
                          }
                          return Container(
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.85,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final doc = snapshot.data!.docs[index];
                                    final userid = doc.id;

                                    final userfullnbame =
                                        "${doc['fname'] + " " + doc['lname']}";

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.teal,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(50, 3, 3, 3),
                                            blurRadius: 5,
                                            offset:
                                                Offset(4, 5), // Shadow position
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          //info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${doc['fname'] + " " + doc['lname']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      doc['position'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      doc['company'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),

// list of buttons
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // list of buttons
                                              InviteButton(userid: userid),
                                              //meeting
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ScheduleButton(
                                                  userid: userid,
                                                  username: userfullnbame)
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }));
                        },
                      )
                    : Container()
              ],
            ),
          ),
        )));
  }
}

//add Notification

class InviteButton extends StatefulWidget {
  final String userid;
  const InviteButton({super.key, required this.userid});

  @override
  State<InviteButton> createState() => _InviteButtonState();
}

class _InviteButtonState extends State<InviteButton> {
  bool status = false;
  bool checkstatus = false;

  Future<bool> checkIfValueExists(String currentuserid, String userid) async {
    final reference = FirebaseFirestore.instance.collection('invites');
    final query = reference
        .where('from', isEqualTo: currentuserid.toString())
        .where('to', isEqualTo: userid.toString());
    final result = await query.get();
    if (result.docs.isNotEmpty) {
      bool statusreulst = result.docs[0].get('status');
      if (statusreulst == true) {
        status = true;
      } else {
        status = false;
      }
    }
    return result.docs.isNotEmpty;
  }

  Future<String> checkRequest(String currentuserid, String userid) async {
    final reference = FirebaseFirestore.instance.collection('invites');
    final query = reference
        .where('from', isEqualTo: userid.toString())
        .where('to', isEqualTo: currentuserid.toString());
    final result = await query.get();
    if (result.docs.isNotEmpty) {
      bool statusreulst = result.docs[0].get('status');

      if (statusreulst == true) {
        checkstatus = true;
      } else {
        checkstatus = false;
      }
      return result.docs[0].id.toString();
    }

    return '';
  }

  Future<bool> checkFriends(String currentuserid, String userid) async {
    final reference = FirebaseFirestore.instance.collection('user');
    final query = reference.where('friends', arrayContains: currentuserid);
    final result = await query.get();
    if (result.docs.isNotEmpty) {
      final dataid = result.docs[0].id;
      if (dataid == userid) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return FutureBuilder<String>(
          future: checkRequest(currentuserid.toString(), widget.userid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: Container());
            }
            String? inviteId = snapshot.data;
            if (inviteId != null && inviteId.isNotEmpty) {
              return GestureDetector(
                  onTap: () {
                    acceptuser(inviteId);
                    setState(() {});
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Accept"),
                  ));
            } else {
              return FutureBuilder<bool>(
                  future: checkIfValueExists(
                      currentuserid.toString(), widget.userid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.white,
                          child: Container());
                    }
                    if (snapshot.data == true) {
                      return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text("Sent Request"),
                          ));
                    } else {
                      return FutureBuilder<bool>(
                          future: checkFriends(
                              currentuserid.toString(), widget.userid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.white,
                                  child: Container());
                            }
                            if (snapshot.data == true) {
                              return GestureDetector(
                                  onTap: () {
                                    inviteuser(currentuserid.toString(),
                                        widget.userid, fulname);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text("Chat Now"),
                                  ));
                            } else {
                              return GestureDetector(
                                  onTap: () {
                                    inviteuser(currentuserid.toString(),
                                        widget.userid, fulname);
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text("Chat Invite"),
                                  ));
                            }
                          });
                    }
                  });
            }
          });
    });
  }

  //accept user
  acceptuser(String inviteid) async {
    listOfFriends.add(widget.userid);
    //update noti
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .where('CollId', isEqualTo: inviteid)
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((document) {
              document.reference.update({
                'message': 'You can now message',
                'seen': true,
                'buttonTitle': 'Chat Now',
                'collectionName': 'chat',
                'CollId': '',
                'timestamp': DateTime.now(),
              });
            }));

    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userid)
        .update({
      "friends": FieldValue.arrayUnion([currentuserid])
    }).then((value) => FirebaseFirestore.instance
                .collection('user')
                .doc(currentuserid)
                .update({
              "friends": FieldValue.arrayUnion([widget.userid])
            }));

    await FirebaseFirestore.instance
        .collection('invites')
        .doc(inviteid)
        .delete();
    //add notification in user sender
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userid)
        .collection('notifications')
        .add({
      'sender': fulname,
      'message': 'accept your request',
      'collectionName': 'chat',
      'CollId': '',
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': true,
      'timestamp': DateTime.now(),
      'buttonTitle': 'Chat Now',
      'senderID': currentuserid,
    }).then((value) {
      print('added to notification');
    });
  }

  inviteuser(String currentUserId, String otherUserId,
      String currentuserfullname) async {
    CollectionReference invitesRef =
        FirebaseFirestore.instance.collection('invites');

// Create a new invite document with some data
    Map<String, dynamic> newInviteData = {
      'from': currentUserId,
      'to': otherUserId,
      'status': false,
      'timestamp': FieldValue.serverTimestamp(),
    };

// Add the invite document to the collection and get its ID
    DocumentReference newInviteRef = await invitesRef.add(newInviteData);
    String newInviteId = newInviteRef.id;

    addNotification(otherUserId, 'invites', newInviteId, 'invite you to chat',
        currentuserfullname);
  }

  addNotification(String notifiuserid, String collection, String collId,
      String message, String currentfname) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(notifiuserid)
        .collection('notifications')
        .add({
      'sender': currentfname,
      'message': message,
      'collectionName': collection,
      'CollId': collId,
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': true,
      'timestamp': DateTime.now(),
      'buttonTitle': 'Accept',
      'senderID': currentuserid,
    })
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print('Failed to add notification: $error'));
  }
}
//add data in notificaion

class ScheduleButton extends StatefulWidget {
  final String userid;
  final String username;
  const ScheduleButton(
      {super.key, required this.userid, required this.username});

  @override
  State<ScheduleButton> createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  Future<String> checkIfValueExists(String currentuserid, String userid) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('schedule').get();

    for (final document in querySnapshot.docs) {
      final tablesCollection = document.reference.collection('tables');
      final query = tablesCollection
          .where('receiver', isEqualTo: userid.toString())
          .where('sender', isEqualTo: currentuserid.toString());
      final result = await query.get();

      if (result.docs.isNotEmpty) {
        return result.docs[0].get('status').toString();
      }
    }

    return '';
  }

  Future<List> checkReivedSched(String currentuserid, String userid) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('schedule').get();

    for (final document in querySnapshot.docs) {
      final tablesCollection = document.reference.collection('tables');
      final query = tablesCollection
          .where('receiver', isEqualTo: currentuserid.toString())
          .where('sender', isEqualTo: userid.toString());
      final result = await query.get();

      if (result.docs.isNotEmpty) {
        List dataid = [
          document.id,
          result.docs[0]['status'],
          result.docs[0].id
        ];

        return dataid;
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: checkIfValueExists(currentuserid.toString(), widget.userid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.white,
                child: Container());
          }
          if (snapshot.data != '') {
            if (snapshot.data == 'pending') {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Waiting"),
              );
            } else {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SchedForm(
                                name: widget.username,
                                userID: widget.userid,
                              )),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Schedule Meeting"),
                  ));
            }
          } else {
            return FutureBuilder<List>(
                future:
                    checkReivedSched(currentuserid.toString(), widget.userid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.white,
                        child: Container());
                  }
                  if (snapshot.data!.isNotEmpty) {
                    String status = snapshot.data![1];
                    if (status == 'booked') {
                      return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedForm(
                                        name: widget.username,
                                        userID: widget.userid,
                                      )),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text("Schedule Meeting"),
                          ));
                    } else {
                      return GestureDetector(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const NotifyPage()));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text("accept"),
                          ));
                    }
                  } else {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SchedForm(
                                      name: widget.username,
                                      userID: widget.userid,
                                    )),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("Schedule Meeting"),
                        ));
                  }
                });
          }
        });
  }

  popup(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(title),
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
  }

  Future<bool> checkSchedValue(String collection, String documentId,
      String arrayFieldName, String mapFieldName, dynamic mapFieldValue) async {
    final reference =
        FirebaseFirestore.instance.collection(collection).doc(documentId);
    final document = await reference.get();
    if (document.exists) {
      final array = document[arrayFieldName] as List<dynamic>;
      if (array != null) {
        for (final map in array) {
          if (map[mapFieldName] == mapFieldValue) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
