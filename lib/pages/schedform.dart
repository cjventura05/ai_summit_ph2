import 'package:blankevent/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'listofdelegate.dart';

class SchedForm extends StatefulWidget {
  final String name;
  final String userID;
  const SchedForm({super.key, required this.name, required this.userID});
  @override
  State<SchedForm> createState() => _SchedFormState();
}

class _SchedFormState extends State<SchedForm> {
  String tableValue = '';
  String name = '';
  String validator = '';
  String dropdownValue = '';
  String? selectedTableValue;
  List<DropdownMenuItem<String>> items = [];
  List lisItem = [];
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    retrieveItems();
    _controller.text = widget.name.toString();
  }

  void retrieveItems() async {
    final currentsnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .get();
    //current user
    if (currentsnapshot.exists &&
        currentsnapshot.data()!.containsKey('MeetingTime')) {
      final timelist = currentsnapshot.data()!['MeetingTime'];
      for (var timeslot in timelist) {
        final timeid = timeslot['TimeID'];
        lisItem.add(timeid);
      }

      itemList();
    }
  }

  itemList() {
    FirebaseFirestore.instance
        .collection('schedule')
        .orderBy('time')
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        String itemName = doc.data()['time'];
        String docid = doc.id;
        if (!lisItem.contains(docid)) {
          items.add(
            DropdownMenuItem(
              value: docid,
              child: Text(itemName),
            ),
          );
        }
        // add each item name to the list of dropdown menu items
      }

      // set the initial value of the dropdown menu to be the first item in the list
      setState(() {
        dropdownValue = items[0].value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                validator == ''
                    ? Container()
                    : Text(
                        validator,
                        style: const TextStyle(color: Colors.red),
                      ),
                TextFormField(
                  controller: _controller,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Schedule With: ',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  child: DropdownButton(
                    isExpanded: true,
                    icon: const Icon(CupertinoIcons.arrow_down_circle),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black87, fontSize: 18),
                    value:
                        dropdownValue, // set the initial value of the dropdown menu
                    items: items,
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value.toString();
                      });
                    },
                  ),
                ),
                dropdownValue == ''
                    ? Container()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.50,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('schedule')
                              .doc(dropdownValue.toString())
                              .collection('tables')
                              .orderBy('tablenumber')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 3),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final document = snapshot.data!.docs[index];
                                final status = document['status'];
                                final docuID = document.id;
                                final isButtonSelected =
                                    selectedTableValue == docuID.toString();
                                if (status == 'booked' || status == 'pending') {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: status == 'booked'
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.red)
                                            : status == 'pending'
                                                ? MaterialStateProperty.all<
                                                    Color>(Colors.blueGrey)
                                                : MaterialStateProperty.all<
                                                    Color>(Colors.white70)),
                                    child: Text(
                                        'Table ${document['tablenumber'].toString()}',
                                        style: TextStyle(
                                          color: status != 'Available'
                                              ? Colors.white
                                              : Colors.black87,
                                        )),
                                    onPressed: () {
                                      // handle button press
                                    },
                                  );
                                } else {
                                  return ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: isButtonSelected
                                            ? MaterialStateProperty.all<Color>(
                                                Colors.blueAccent)
                                            : status == 'booked'
                                                ? MaterialStateProperty.all<
                                                    Color>(Colors.red)
                                                : status == 'pending'
                                                    ? MaterialStateProperty.all<
                                                        Color>(Colors.blueGrey)
                                                    : MaterialStateProperty.all<
                                                        Color>(Colors.white70)),
                                    child: Text(
                                        'Table ${document['tablenumber'].toString()}',
                                        style: TextStyle(
                                          color: status != 'Available'
                                              ? Colors.white
                                              : Colors.black87,
                                        )),
                                    onPressed: () {
                                      // handle button press
                                      setState(() {
                                        selectedTableValue = docuID.toString();
                                        tableValue = docuID.toString();
                                      });
                                    },
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.text == '' ||
                          tableValue == '' ||
                          dropdownValue == '') {
                        setState(() {
                          validator = 'Please Fill Up All Form';
                        });
                      } else {
                        updateTimeSlot(dropdownValue, tableValue);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Red Table :',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Table is booked ',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'White Table :',
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Table is open',
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Grey Table :',
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Waiting for user to accept invite',
                      style: TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        )),
      );
    });
  }

  updateTimeSlot(String collTimeid, String tableID) async {
    if (collTimeid != null &&
        tableID != null &&
        collTimeid.isNotEmpty &&
        tableID.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('schedule')
          .doc(collTimeid)
          .collection('tables')
          .doc(tableID)
          .update({
            'status': 'pending',
            'sender': currentuserid,
            'receiver': widget.userID,
          })
          .then((value) => addNotification('', 'schedule', collTimeid, tableID,
              'Sent a request meeting', fulname))
          .catchError((error) => print('Failed to update timeslot: $error'));
      addSchedtime(collTimeid, tableID);
    } else {
      print('Error: document path is empty');
    }
  }

  addNotification(String notifiuserid, String collection, String collId,
      String tableid, String message, String currentfname) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.userID)
        .collection('notifications')
        .add({
          'sender': currentfname,
          'message': message,
          'collectionName': collection,
          'CollId': collId,
          'subCollName': 'tables',
          'subCollId': tableid,
          'seen': false,
          'button': true,
          'timestamp': DateTime.now(),
          'buttonTitle': 'Accept',
          'senderID': currentuserid,
        })
        .then((value) => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Already Submitted!'),
                  content: const Text('Please wait to accept your request'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const ListOfDelegate()));
                        setState(() {});
                      },
                    ),
                  ],
                );
              },
            ))
        // ignore: invalid_return_type_for_catch_error
        .catchError((error) => print('Failed to add notification: $error'));
  }

  addSchedtime(String collTimeid, tableID) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .update({
      'MeetingTime': FieldValue.arrayUnion([
        {'TimeID': collTimeid, 'TableID': tableID}
      ])
    });
  }
}
