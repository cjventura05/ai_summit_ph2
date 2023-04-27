import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../drawer.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String categoryday = "Day 1";
  bool btn1 = true;
  bool btn2 = false;
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          categoryday = 'Day 1';
                          btn1 = true;
                          btn2 = false;
                        });
                      },
                      child: Text(
                        'Day 1',
                        style: TextStyle(
                            color: btn1 == true ? Colors.white : Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              btn1 == true ? Colors.blue : Colors.white)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          categoryday = 'Day 2';
                          btn1 = false;
                          btn2 = true;
                        });
                      },
                      child: Text(
                        'Day 2',
                        style: TextStyle(
                            color: btn2 == true ? Colors.white : Colors.black),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              btn2 == true ? Colors.blue : Colors.white)),
                    )
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('agenda')
                        .where('category', isEqualTo: categoryday)
                        .orderBy('number')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading..."),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("no data"),
                        );
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.85,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              String time = doc['time'];
                              int lastitem = snapshot.data!.docs.length - 1;

                              List<dynamic> array = doc['content'] ?? [];

                              double contentheight = 80;
                              bool readmore = false;

                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return TimelineTile(
                                  indicatorStyle: const IndicatorStyle(
                                      color: Color(0xff0368da),
                                      height: 20,
                                      width: 20),
                                  isFirst: index == 0 ? true : false,
                                  isLast: index == lastitem ? true : false,
                                  endChild: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff0368da),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 0, 0, 0)
                                                .withOpacity(0.5),
                                            spreadRadius: 0.1,
                                            blurRadius: 2,
                                            offset: const Offset(0,
                                                2), // changes position of shadow
                                          ),
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: contentheight,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: array.length,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                final content = array[index];

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      content['title'],
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "Montserrat",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      content['subtitle'],
                                                      style: const TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Divider(
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                        array.length >= 2
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    time,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        if (readmore != false) {
                                                          setState(() {
                                                            contentheight = 70;
                                                            readmore = false;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            double
                                                                totalcontent =
                                                                double.parse(array
                                                                    .length
                                                                    .toString());
                                                            contentheight = 70 *
                                                                totalcontent;

                                                            readmore = true;
                                                          });
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          readmore != true
                                                              ? const Text(
                                                                  'read more')
                                                              : const Text(
                                                                  'read less'),
                                                          readmore != true
                                                              ? const Icon(Icons
                                                                  .arrow_circle_down_outlined)
                                                              : const Icon(Icons
                                                                  .arrow_circle_up_outlined)
                                                        ],
                                                      ))
                                                ],
                                              )
                                            : Text(
                                                time,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }),
                      );
                    })
              ],
            ),
          ),
        ));
  }
}
