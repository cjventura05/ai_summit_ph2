// ignore_for_file: avoid_print

import 'package:blankevent/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'chatingpage.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              size: 25,
              weight: 400,
            ),
          ),
          title: const Text('Notification'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('user')
                        .doc(currentuserid)
                        .collection('notifications')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container());
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("No Data ",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17,
                                  color: Colors.black87)),
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
                            final docs = snapshot.data!.docs[index];
                            String sender = docs['sender'];
                            String message = docs['message'];
                            String collid = docs['CollId'];
                            String subCollId = docs['subCollId'] ?? '';
                            String subCollName = docs['subCollName'] ?? '';
                            String collectionName = docs['collectionName'];
                            bool seen = docs['seen'];
                            bool button = docs['button'];
                            String buttonTitle = docs['buttonTitle'];
                            String senderId = docs['senderID'];
                            String notifID = docs.id;

                            if (seen == true) {
                              return GestureDetector(
                                onTap: () {
                                  if (collectionName == 'chat') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                                names: sender,
                                                roomID: collid.toString(),
                                                userid: senderId,
                                              )),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromARGB(50, 3, 3, 3),
                                        blurRadius: 5,
                                        offset: Offset(4, 5), // Shadow position
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sender,
                                        style: const TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        message,
                                        style: const TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
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
                                      offset: Offset(4, 5), // Shadow position
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      sender,
                                      style: const TextStyle(
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      message,
                                      style: const TextStyle(
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    //chat invite

                                    if (button == true ||
                                        buttonTitle == 'Accept')
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (collectionName ==
                                                        'invites' &&
                                                    buttonTitle == 'Accept') {
                                                  updatenotification(
                                                      collectionName,
                                                      collid,
                                                      notifID,
                                                      message,
                                                      buttonTitle,
                                                      senderId,
                                                      sender);
                                                } else if (collectionName ==
                                                        'chat' &&
                                                    buttonTitle == 'Chat Now') {
                                                  updatenotiChat(notifID);
                                                } else if (collectionName ==
                                                        'schedule' &&
                                                    buttonTitle == 'Accept') {
                                                  bool result =
                                                      await checkSchedValue(
                                                          'user',
                                                          currentuserid
                                                              .toString(),
                                                          'MeetingTime',
                                                          'TimeID',
                                                          collid);
                                                  if (result == true) {
                                                    popup('',
                                                        'You Already have Schedule for this Timeslot');
                                                  } else {
                                                    print('false');
                                                    acceptRequest(
                                                        notifID,
                                                        collid,
                                                        subCollId,
                                                        senderId);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(buttonTitle),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (collectionName ==
                                                        'schedule' &&
                                                    buttonTitle == 'Accept') {
                                                  rejectNotifi(notifID, collid,
                                                      subCollId, senderId);
                                                } else if (collectionName ==
                                                        'invites' &&
                                                    buttonTitle == 'Accept') {
                                                  rejectInviteNotifi(
                                                      notifID,
                                                      collid,
                                                      subCollId,
                                                      senderId);
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Text('Reject'),
                                              )),
                                        ],
                                      )
                                    else
                                      Container()
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  popup(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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
        FirebaseFirestore.instance.collection(collection).doc(currentuserid);
    final document = await reference.get();
    if (document.exists && document.data()!.containsKey(arrayFieldName)) {
      final array = document[arrayFieldName] as List<dynamic>;
      if (array != null) {
        for (final map in array) {
          if (map[mapFieldName] == mapFieldValue) {
            print(mapFieldName);
            print(mapFieldValue);
            return true;
          }
        }
      }
    }
    return false;
  }

  updatenotiChat(notifId) async {
    final ref = FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .doc(notifId);

    await ref.update({
      'seen': true,
    });
    return true;
  }

  updatenotification(
      String collname,
      String collid,
      String notifId,
      String notifMessage,
      String notifButtonTitle,
      String senderID,
      String sendername) async {
    if (collname == 'invites' && notifButtonTitle == 'Accept') {
      chatinvite(collname, collid, notifId, notifMessage, notifButtonTitle,
          senderID, sendername);
    } else if (collname == 'schedule' && notifButtonTitle == 'Accept') {}
  }

  chatinvite(
      String collname,
      String collid,
      String notifId,
      String notifMessage,
      String notifButtonTitle,
      String senderID,
      String sendername) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .update({
      "friends": FieldValue.arrayUnion(
        [senderID],
      )
    }).then((value) => listOfFriends.add(sendername));

    final addChatroom =
        await FirebaseFirestore.instance.collection('chat').add({
      'group': [
        sendername,
        fulname.toString(),
      ]
    });
    final chatid = addChatroom.id;

    await FirebaseFirestore.instance
        .collection(collname)
        .doc(collid)
        .delete()
        .then((value) => print("Document deleted successfully"))
        .catchError((error) => print("Failed to delete document: $error"));
    final ref = FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .doc(notifId);

    await ref.update({
      'message': 'You can now message',
      'collectionName': 'chat',
      'CollId': chatid.toString(),
      'seen': true,
      'button': false,
      'timestamp': DateTime.now(),
      'buttonTitle': '',
    }).then((value) => FirebaseFirestore.instance
            .collection('user')
            .doc(senderID)
            .update({
          'groups': [chatid.toString()],
          "friends": FieldValue.arrayUnion([currentuserid])
        }).then((value) => FirebaseFirestore.instance
                    .collection('user')
                    .doc(currentuserid)
                    .update({
                  'groups': [chatid.toString()],
                  "friends": FieldValue.arrayUnion([currentuserid])
                })));
    //add notification in user sender
    await FirebaseFirestore.instance
        .collection('user')
        .doc(senderID)
        .collection('notifications')
        .add({
      'sender': fulname,
      'message': 'accept your request',
      'collectionName': 'chat',
      'CollId': chatid.toString(),
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': true,
      'timestamp': DateTime.now(),
      'buttonTitle': 'Chat Now',
      'senderID': currentuserid,
    });
  }
//accept sched request

  acceptRequest(
      String notifID, String collId, String subCollId, String userID) async {
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(collId)
        .collection('tables')
        .doc(subCollId)
        .update({
      'status': 'booked',
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .update({
      'MeetingTime': FieldValue.arrayUnion([
        {'TimeID': collId, 'TableID': subCollId}
      ])
    });

    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .doc(notifID)
        .update({
      'seen': true,
      'message': 'Scheduled a meeting with you',
      'button': false,
      'buttonTitle': '',
      'timestamp': DateTime.now()
    }).catchError((error) => print("this is the error: $error"));
    //add notification in user sender
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('notifications')
        .add({
      'sender': fulname,
      'message': 'accept your request meeting',
      'collectionName': '',
      'CollId': '',
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': false,
      'timestamp': DateTime.now(),
      'buttonTitle': '',
      'senderID': currentuserid,
    });
  }

  rejectNotifi(
      String notifID, String collId, String subCollId, String userID) async {
    await FirebaseFirestore.instance
        .collection('schedule')
        .doc(collId)
        .collection('tables')
        .doc(subCollId)
        .update({'status': 'Available', 'receiver': '', 'sender': ''});
    await FirebaseFirestore.instance.collection('user').doc(userID).update({
      'MeetingTime': FieldValue.arrayRemove([
        {'TimeID': collId, 'TableID': subCollId}
      ])
    });
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .doc(notifID)
        .update({
      'seen': true,
      'message': 'Request rejected',
      'button': false,
      'buttonTitle': '',
      'timestamp': DateTime.now()
    }).catchError((error) => print("this is the error: $error"));
    //add notification in user sender
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('notifications')
        .add({
      'sender': fulname,
      'message': 'Reject your request',
      'collectionName': '',
      'CollId': '',
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': false,
      'timestamp': DateTime.now(),
      'buttonTitle': '',
      'senderID': currentuserid,
    });
  }

  rejectInviteNotifi(
      String notifID, String collId, String subCollId, String userID) async {
    await FirebaseFirestore.instance.collection('invites').doc(collId).delete();
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .collection('notifications')
        .doc(notifID)
        .update({
      'seen': true,
      'message': 'Request rejected',
      'button': false,
      'buttonTitle': '',
      'timestamp': DateTime.now()
    }).catchError((error) => print("this is the error: $error"));
    //add notification in user sender
    await FirebaseFirestore.instance
        .collection('user')
        .doc(userID)
        .collection('notifications')
        .add({
      'sender': fulname,
      'message': 'Reject your request',
      'collectionName': '',
      'CollId': '',
      'subCollId': '',
      'subCollName': '',
      'seen': false,
      'button': false,
      'timestamp': DateTime.now(),
      'buttonTitle': '',
      'senderID': currentuserid,
    });
  }
}
