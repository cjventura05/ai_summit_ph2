import 'package:blankevent/pages/listofdelegate.dart';
import 'package:blankevent/pages/loginpage.dart';

import 'package:blankevent/pages/speakers.dart';
import 'package:blankevent/pages/sponsors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';
import '../userinfo.dart';
import 'about.dart';
import 'agenda.dart';
import 'listofschedule.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextStyle _textStyle =
      const TextStyle(fontFamily: "Montserrat", fontSize: 17);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color color = Colors.blue;

  Future<List<String>> getSubcollectionData() async {
    List<String> subcollectionData = [];
    QuerySnapshot mainSnapshot = await FirebaseFirestore.instance
        .collection('Sponsor')
        .orderBy('number')
        .get();

    for (var doc in mainSnapshot.docs) {
      QuerySnapshot subSnapshot =
          await doc.reference.collection('sponsors').get();

      subSnapshot.docs.forEach((subDoc) {
        subcollectionData.add(subDoc['imagelink']);
      });
    }

    return subcollectionData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Banner

              notifier.value != false
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Text(
                        'Hi ${userinfo.first.toString()} ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    )
                  : Container(),
              notifier.value != false
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Welcome to Event',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                    )
                  : Container(),
              Container(
                  alignment: Alignment.center,
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset(
                      'asset/images/AI Summit_KV_Final_With Partner Logos.jpg')),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Wrap(
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    //program

                    GestureDetector(
                      onTap: () {
                        pagetitle = 'Progam';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AgendaPage()),
                        );
                      },
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 32.0) / 3.0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(50, 3, 3, 3),
                                    blurRadius: 10,
                                    offset: Offset(5, 5), // Shadow position
                                  ),
                                ],
                              ),
                              width: 100,
                              height: 100,
                              child:
                                  Image.asset('asset/icons/Program-Agenda.png'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Program', style: _textStyle)
                          ],
                        ),
                      ),
                    ),

                    //About
                    GestureDetector(
                      onTap: () {
                        pagetitle = 'About';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutPage()),
                        );
                      },
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 32.0) / 3.0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(50, 3, 3, 3),
                                    blurRadius: 10,
                                    offset: Offset(5, 5), // Shadow position
                                  ),
                                ],
                              ),
                              width: 100,
                              height: 100,
                              child: Image.asset('asset/icons/About.png'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('About', style: _textStyle)
                          ],
                        ),
                      ),
                    ),
                    //Sponsor
                    GestureDetector(
                      onTap: () {
                        pagetitle = 'Sponsor';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Sponsors()),
                        );
                      },
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 32.0) / 3.0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(50, 3, 3, 3),
                                    blurRadius: 10,
                                    offset: Offset(5, 5), // Shadow position
                                  ),
                                ],
                              ),
                              width: 100,
                              height: 100,
                              child: Image.asset('asset/icons/Sponsors.png'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Sponsors', style: _textStyle)
                          ],
                        ),
                      ),
                    ), //Speakers
                    GestureDetector(
                      onTap: () {
                        pagetitle = 'Speakers';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SpeakerPage()),
                        );
                      },
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width - 32.0) / 3.0,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(50, 3, 3, 3),
                                    blurRadius: 10,
                                    offset: Offset(5, 5), // Shadow position
                                  ),
                                ],
                              ),
                              width: 100,
                              height: 100,
                              child: Image.asset('asset/icons/Speakers.png'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text('Speakers', style: _textStyle)
                          ],
                        ),
                      ),
                    ), // List of Delegate

                    ValueListenableBuilder<bool>(
                        valueListenable: notifier,
                        builder: (BuildContext context, bool isLoggedInValue,
                            Widget? child) {
                          if (isLoggedInValue) {
                            return GestureDetector(
                              onTap: () {
                                pagetitle = 'List of Delegate';

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListOfDelegate()),
                                );
                              },
                              child: SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 33.3) /
                                        3.0,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(50, 3, 3, 3),
                                            blurRadius: 10,
                                            offset:
                                                Offset(5, 5), // Shadow position
                                          ),
                                        ],
                                      ),
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          'asset/icons/Delegates.png'),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('List of Delegate',
                                        textAlign: TextAlign.center,
                                        style: _textStyle)
                                  ],
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              pagetitle = 'List of Delegate';

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Please Login First'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LogIn()),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 33.3) /
                                      3.0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(50, 3, 3, 3),
                                          blurRadius: 10,
                                          offset:
                                              Offset(5, 5), // Shadow position
                                        ),
                                      ],
                                    ),
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                        'asset/icons/Delegates.png'),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('List of Delegate',
                                      textAlign: TextAlign.center,
                                      style: _textStyle)
                                ],
                              ),
                            ),
                          );
                        }),

                    ValueListenableBuilder<bool>(
                        valueListenable: notifier,
                        builder: (BuildContext context, bool isLoggedInValue,
                            Widget? child) {
                          if (isLoggedInValue) {
                            return GestureDetector(
                              onTap: () {
                                pagetitle = 'My Schedule';

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ListofSchedule()),
                                );
                              },
                              child: SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 33.3) /
                                        3.0,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(50, 3, 3, 3),
                                            blurRadius: 10,
                                            offset:
                                                Offset(5, 5), // Shadow position
                                          ),
                                        ],
                                      ),
                                      width: 100,
                                      height: 100,
                                      child: Image.asset(
                                          'asset/icons/Scheduled-Meetings.png'),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text('My Schedule',
                                        textAlign: TextAlign.center,
                                        style: _textStyle),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              pagetitle = 'My Schedule';

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Please Login First'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LogIn()),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width:
                                  (MediaQuery.of(context).size.width - 33.3) /
                                      3.0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(50, 3, 3, 3),
                                          blurRadius: 10,
                                          offset:
                                              Offset(5, 5), // Shadow position
                                        ),
                                      ],
                                    ),
                                    width: 100,
                                    height: 100,
                                    child: Image.asset(
                                        'asset/icons/Scheduled-Meetings.png'),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text('My Schedule',
                                      textAlign: TextAlign.center,
                                      style: _textStyle),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 5, bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sponsors',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17)),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Sponsors()),
                                );
                              },
                              child: Text('See All'))
                        ],
                      ),
                    ),
                    FutureBuilder(
                      future: getSubcollectionData(),
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
                            child: Text("no data"),
                          );
                        } else {
                          return CarouselSlider.builder(
                            itemCount: snapshot.data!.length,
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                            ),
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              final item = snapshot.data![index];
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Image.network(
                                  '${item.toString()}',
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: _launchURL,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            minimumSize: const Size.fromHeight(50)),
                        child: const Text(
                          'Audience Response System',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  _launchURL() async {
    final reference = await FirebaseFirestore.instance
        .collection('ARS')
        .where('status', isEqualTo: 'Active')
        .get();

    String url = reference.docs[0]['Link'];
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
