import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('asset/images/About-us-banner.png')),
            //Display Content
            SizedBox(
              height: 20,
            ),
            Text(
                'MAY 10 - 11, 2023 | MARRIOTT GRAND BALLROOM (MANILA, PHILIPPINES)',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Text(
                'Aboitiz Data Innovation’s inaugural AI Summit PH is designed to be the Philippines’ biggest AI conference event. The summit will feature the best and brightest AI industry leaders converging to share their expertise on tackling current-day challenges and how to introduce long-lasting solutions that can change the lives of future generations.',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text(
                'This will be a marquee platform for AI leaders and practitioners to freely discuss the latest trends, challenges, opportunities, and advancements within the AI space. There will also be sharing sessions that showcase the practical application of AI technology, highlighting real-world cases of data being turned into actionable insights.',
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 20,
            ),
            Text(
                'Featuring a wide range of delegates from the following industries:',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Text(
                "\u2022 Private Sector Stakeholders / AI Organizations and Start-ups"
                    .toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Academe".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Financial Services".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Power".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Local and International".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Media".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text("\u2022 Government".toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 20,
            ),
            Text('Delegates can expect to:',
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    fontSize: 18)),
            SizedBox(
              height: 10,
            ),
            Text(
                "1. Exchange ideas and best practices with the Philippines’ top AI practitioners",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text(
                "2. Exchange ideas and best practices with the Philippines’ top AI practitioners",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text(
                "3. Learn from AI experts during knowledge sharing sessions and discussions",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text(
                "4. Discover real-world cases and applications for AI that are realistic and actionable",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 10,
            ),
            Text(
                "5. Facilitate business networking opportunities and foster strategic partnerships",
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16, color: Colors.black87)),
            SizedBox(
              height: 20,
            ),
          ]),
        ))));
  }
}
