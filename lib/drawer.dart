import 'package:blankevent/pages/about.dart';
import 'package:blankevent/pages/agenda.dart';
import 'package:blankevent/pages/chat.dart';
import 'package:blankevent/pages/home.dart';
import 'package:blankevent/pages/listofdelegate.dart';
import 'package:blankevent/pages/listofschedule.dart';
import 'package:blankevent/pages/loginpage.dart';
import 'package:blankevent/pages/notification.dart';
import 'package:blankevent/pages/speakers.dart';
import 'package:blankevent/pages/sponsors.dart';
import 'package:blankevent/userinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) => Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //buildHeader(context),
                buildmenuitems(context)
              ],
            ),
          ),
        ),
      );

  // Widget buildHeader(BuildContext context) => Container();
  Widget buildmenuitems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(children: [
          Column(
            children: [
              ListTile(
                leading: Image.asset(
                  'asset/icons/Home.png',
                  height: 27,
                ),
                title: const Text("Home"),
                onTap: () {
                  pagetitle = 'Home';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'asset/icons/Program-Agenda.png',
                  height: 27,
                ),
                title: const Text("Program"),
                onTap: () {
                  pagetitle = 'Progam';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AgendaPage()));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'asset/icons/About.png',
                  height: 27,
                ),
                title: const Text("About"),
                onTap: () {
                  pagetitle = 'About';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const AboutPage()));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'asset/icons/Sponsors.png',
                  height: 27,
                ),
                title: const Text("Sponsor"),
                onTap: () {
                  pagetitle = 'Sponsor';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Sponsors()));
                },
              ),
              ListTile(
                leading: Image.asset(
                  'asset/icons/Speakers.png',
                  height: 27,
                ),
                title: const Text("Speakers"),
                onTap: () {
                  pagetitle = 'Speakers';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const SpeakerPage()));
                },
              ),
              notifier.value != false
                  ? ListTile(
                      leading: Image.asset(
                        'asset/icons/Delegates.png',
                        height: 27,
                      ),
                      title: const Text("List of Delegate"),
                      onTap: () {
                        pagetitle = 'List of Delegate';
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const ListOfDelegate()));
                      },
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              notifier.value != false
                  ? ListTile(
                      leading: Image.asset(
                        'asset/icons/Scheduled-Meetings.png',
                        height: 27,
                      ),
                      title: const Text("My Schedule"),
                      onTap: () {
                        pagetitle = 'My Schedule';
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const ListofSchedule()));
                      },
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              const Divider(
                color: Colors.black87,
              ),
              notifier.value != false
                  ? ListTile(
                      leading: const Icon(Icons.logout_outlined),
                      title: const Text("Logout"),
                      onTap: () {
                        setState(() {
                          notifier.value = false;
                        });
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      },
                    )
                  : Container(),
            ],
          ),
        ]),
      );
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff0368da),
      //drawer
      title: pagetitle == null ? const Text(" Home") : Text('$pagetitle'),
      leading: IconButton(
        icon: const Icon(
          Icons.menu_rounded,
          color: Colors.black87,
          size: 25,
          weight: 400,
        ),
        onPressed: onMenuPressed,
      ),
      actions: [
        notifier.value != false
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(currentuserid)
                    .collection('notifications')
                    .snapshots(),
                builder: (context, snapshot) {
                  int counter = 0;
                  if (snapshot.hasData) {
                    for (var element in snapshot.data!.docs) {
                      bool seen = element['seen'];
                      if (seen != true) {
                        counter++;
                      }
                    }
                  }
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //nitification bell
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                CupertinoIcons.bell,
                                size: 25,
                                color: Colors.black87,
                                weight: 400,
                              ),
                              onPressed: () {
                                pagetitle = 'Notification';
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const NotifyPage()));
                              },
                            ),
                            counter > 0
                                ? Positioned(
                                    right: 11,
                                    top: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        counter.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),

                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: const Icon(
                            CupertinoIcons.chat_bubble_text,
                            size: 25,
                            color: Colors.black87,
                            weight: 400,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ListofChat()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: const Text("Login")),
              )
      ],
      elevation: 0,
    );
  }
}
