import 'package:blankevent/pages/speakerssinmglepage.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

import '../drawer.dart';

class SpeakerPage extends StatefulWidget {
  const SpeakerPage({super.key});

  @override
  State<SpeakerPage> createState() => _SpeakerPageState();
}

class _SpeakerPageState extends State<SpeakerPage> {
  TextStyle designation = const TextStyle(
      fontFamily: "Montserrat", fontWeight: FontWeight.normal, fontSize: 14);
  TextStyle companystyle = const TextStyle(
      fontFamily: "Montserrat", fontWeight: FontWeight.w600, fontSize: 14);
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
            minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Speakers')
                          .orderBy('name')
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
                            child: Text("no data"),
                          );
                        }
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 0,
                                      mainAxisExtent: 260,
                                      mainAxisSpacing: 0),
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final doc = snapshot.data!.docs[index];
                                final bio = doc['bio'].toString();
                                final image = doc['Imagelink'].toString();
                                final name = doc['name'].toString();
                                final company = doc['company'].toString();
                                final position = doc['position'].toString();

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SpeakerProfilePage(
                                                image: image,
                                                name: name,
                                                position: position,
                                                company: company,
                                                bio: bio,
                                              )),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        backgroundColor: Colors.white70,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: image.isEmpty
                                              ? Image.asset(
                                                  'asset/images/person.png')
                                              : FancyShimmerImage(
                                                  imageUrl: image),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        position,
                                        textAlign: TextAlign.center,
                                        style: designation,
                                      ),
                                      Text(
                                        company,
                                        textAlign: TextAlign.center,
                                        style: companystyle,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        );
                      })
                ]))));
  }
}
