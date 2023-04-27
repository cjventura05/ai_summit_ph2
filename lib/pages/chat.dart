import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../userinfo.dart';
import 'chatingpage.dart';

class ListofChat extends StatefulWidget {
  const ListofChat({super.key});

  @override
  State<ListofChat> createState() => _ListofChatState();
}

class _ListofChatState extends State<ListofChat> {
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
        actions: const [],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .doc(currentuserid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('You have no friends'),
                  );
                }
                List<dynamic> checkvalue = snapshot.data!.get('groups');
                if (checkvalue.isNotEmpty) {
                  List<dynamic> chatRoomIds = snapshot.data!.get('groups');
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .where(FieldPath.documentId, whereIn: chatRoomIds)
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
                            child: Text('You have no chat rooms'),
                          );
                        }
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  List name = doc['group'] ?? '';
                                  name.remove(fulname.toString());
                                  String myString = name.join(', ');
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                  roomID: doc.id.toString(),
                                                  names: myString,
                                                  userid: '',
                                                )),
                                      );
                                    },
                                    child: ListTile(
                                      title: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              myString,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontFamily: "Montserrat",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const Divider(
                                              color: Color.fromARGB(
                                                  221, 56, 56, 56),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                      });
                } else {
                  return Center(
                    child: Center(
                      child: Text('No data'),
                    ),
                  );
                }
              },
            )
          ],
        ),
      )),
    );
  }
}
