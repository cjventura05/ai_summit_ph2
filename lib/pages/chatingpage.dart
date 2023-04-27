import 'package:blankevent/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String roomID;
  final String names;
  final String userid;
  const ChatPage(
      {super.key,
      required this.roomID,
      required this.names,
      required this.userid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
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
          title: Text(
            'Chat With ${widget.names.toString()}',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87),
          ),
          centerTitle: false,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings_applications_sharp,
                ))
          ],
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //header with name

                //message list
                MessageList(roomid: widget.roomID.toString()),
                //message form
                TxtChatForm(
                  roomid: widget.roomID.toString(),
                  name: widget.names,
                  userid: widget.userid,
                )
              ],
            ),
          ),
        ),
      );
}

class TxtChatForm extends StatefulWidget {
  final String roomid;
  final String name;
  final String userid;
  const TxtChatForm(
      {super.key,
      required this.roomid,
      required this.name,
      required this.userid});

  @override
  State<TxtChatForm> createState() => _TxtChatFormState();
}

class _TxtChatFormState extends State<TxtChatForm> {
  final TextEditingController _controller = TextEditingController();
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 250, 250),
                labelText: 'Type your message',
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(20))),
            onChanged: (value) => setState(() {
              message = value;
            }),
          )),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              if (message != "") {
                addmessage(message, widget.roomid);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blueAccent),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          )
        ],
      ),
    );
  }

  addmessage(String message, String roomid) async {
    final currentusername = "${userinfo.first} ${userinfo[1]}";

    final refence = FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.roomid.toString())
        .collection('messages');
    await refence.add({
      'sender': currentusername,
      'userID': currentuserid,
      'seen': false,
      'messages': message,
      'time': DateTime.now(),
    }).then((value) => _controller.clear());
  }
}

class MessageList extends StatefulWidget {
  final String roomid;
  const MessageList({super.key, required this.roomid});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.roomid.isNotEmpty
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .doc(widget.roomid)
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text('Loading...'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Message'),
                  );
                }

                return GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        final currentusername =
                            "${userinfo.first} ${userinfo[1]}";
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (doc['sender'] != currentusername
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (doc['sender'] != currentusername
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                doc['messages'],
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text("No History of Chat"),
            ),
    );
  }

  updateSeenMessage() async {
    final refence = await FirebaseFirestore.instance
        .collection('chat')
        .doc(widget.roomid)
        .collection('messages')
        .where('userID', isNotEqualTo: currentuserid)
        .get();

    refence.docs.forEach((docs) {
      DocumentReference ref = docs.reference;
      ref.update({'seen': true});
    });
  }
}
