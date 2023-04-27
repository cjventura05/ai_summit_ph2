import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../drawer.dart';

class Sponsors extends StatefulWidget {
  const Sponsors({super.key});

  @override
  State<Sponsors> createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
            minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Sponsor')
                          .orderBy('number')
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
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final bio = doc['category'];
                                  final docid = doc.id;

                                  return Column(
                                    children: [
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            bio.toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Sponsor')
                                            .doc(docid)
                                            .collection('sponsors')
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
                                          final total =
                                              snapshot.data!.docs.length;
                                          return Center(
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                            total >= 2 ? 2 : 1,
                                                        crossAxisSpacing: 20,
                                                        mainAxisExtent: 100,
                                                        mainAxisSpacing: 20),
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                itemBuilder: (context, index) {
                                                  final sponsorimage = snapshot
                                                      .data!.docs[index];
                                                  String imagelink =
                                                      sponsorimage['imagelink'];

                                                  return imagelink == ''
                                                      ? null
                                                      : FancyShimmerImage(
                                                          imageUrl: imagelink,
                                                          boxFit:
                                                              BoxFit.contain,
                                                        );
                                                }),
                                          );
                                        },
                                      )
                                    ],
                                  );
                                }));
                      })
                ]))));
  }
}
