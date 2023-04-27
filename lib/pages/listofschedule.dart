import 'package:blankevent/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../drawer.dart';

class ListofSchedule extends StatefulWidget {
  const ListofSchedule({super.key});

  @override
  State<ListofSchedule> createState() => _ListofScheduleState();
}

class _ListofScheduleState extends State<ListofSchedule> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List meetingTimeItemList = [];

  Future<bool> checkFieldExists() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(currentuserid)
        .get();
    if (snapshot.exists && snapshot.data()!.containsKey('MeetingTime')) {
      final meetingTimeList = snapshot.data()!['MeetingTime'];
      for (int i = 0; i < meetingTimeList.length; i++) {
        meetingTimeItemList.add(meetingTimeList[i]);
      }
      return true;
    } else {
      return false;
    }
  }

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
            minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<bool>(
                      future: checkFieldExists(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.white,
                              child: Container());
                        }
                        if (snapshot.data != true) {
                          return const Center(
                            child: Text('You dont have Any Schedule'),
                          );
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: ListView.builder(
                              itemCount: meetingTimeItemList.length,
                              itemBuilder: (context, index) {
                                final meetingTime = meetingTimeItemList[index];

                                return FutureBuilder<List>(
                                    future: getTimeSched(meetingTime['TimeID'],
                                        meetingTime['TableID']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.white,
                                            child: Container());
                                      }
                                      if (!snapshot.hasData) {
                                        return Text('no data');
                                      }
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        snapshot.data![0]
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 17),
                                                      ),
                                                      Text(
                                                          'Table ${snapshot.data![1].toString()}',
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  "Montserrat",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 14)),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellowAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(snapshot.data![2]
                                                      .toString()
                                                      .toUpperCase()),
                                                )
                                              ],
                                            ),
                                            const Divider(
                                              thickness: 1,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }),
                        );
                      })
                ],
              ),
            )));
  }

  Future<List> getTimeSched(String timeid, String tableid) async {
    final timetitle = await FirebaseFirestore.instance
        .collection('schedule')
        .doc(timeid)
        .get();
    final tabletitle = await FirebaseFirestore.instance
        .collection('schedule')
        .doc(timeid)
        .collection('tables')
        .doc(tableid)
        .get();

    if (timetitle.data() != null && tabletitle.data() != null) {
      List dataid = [
        timetitle.data()!['time'],
        tabletitle.data()!['tablenumber'],
        tabletitle.data()!['status']
      ];

      return dataid;
    }

    return [];
  }
}
