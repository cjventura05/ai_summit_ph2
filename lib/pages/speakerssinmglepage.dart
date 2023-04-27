// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class SpeakerProfilePage extends StatefulWidget {
  final image;
  final name;
  final company;
  final position;
  final bio;

  const SpeakerProfilePage(
      {super.key,
      this.image,
      this.name,
      this.company,
      this.position,
      this.bio});

  @override
  State<SpeakerProfilePage> createState() => _SpeakerProfilePageState();
}

class _SpeakerProfilePageState extends State<SpeakerProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //profile pict

                Container(
                  alignment: Alignment.topLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.image.toString() == ""
                            ? const AssetImage('asset/images/person.png')
                            : NetworkImage(widget.image.toString())
                                as ImageProvider),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.white70,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 25,
                        weight: 400,
                      ),
                    ),
                  ),
                ),
                //Info
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name.toString(),
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 25)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(widget.position.toString(),
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.normal,
                              fontSize: 18)),
                      Text(widget.company.toString(),
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(widget.bio.toString(),
                          style: const TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.normal,
                              fontSize: 16)),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
