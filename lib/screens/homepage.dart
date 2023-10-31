import 'dart:io';

import 'package:bhagvat_gita/constants.dart';

import 'package:bhagvat_gita/repos/ttsrepo.dart';
import 'package:bhagvat_gita/screens/versepage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhagvat_gita/main.dart';

enum Options {
  delete,
}

int currentchapter = 1;
int verseno = 1;
var getter;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

@override
@override
class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getter = await getshared();
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double _kextent = 30;
    Options? selectedMenu;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: Image.asset(
              'assets/images/bhagwadimg.jpg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
              child: Column(children: [
            Container(
              height: height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(" "),
                  Text(
                    'BHAGWAD GITA',
                    style: GoogleFonts.montserrat(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: PopupMenuButton<Options>(
                      initialValue: selectedMenu,
                      // Callback that sets the selected popup menu item.
                      onSelected: (Options item) async {
                        if (item == Options.delete) {
                          Directory dir = Directory(await Ttsrepo().localPath);
                          dir.deleteSync(recursive: true);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Saved episodes deleted!"),
                        ));
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<Options>>[
                        const PopupMenuItem<Options>(
                          value: Options.delete,
                          child: Text('Delete saved episodes?'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Text(
              'CHAPTERS',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            ),
            Container(
              width: width * 0.8,
              height: height * 0.3,
              child: CupertinoPicker(
                looping: true,
                squeeze: 1.2,
                useMagnifier: true,
                magnification: 1.3,
                itemExtent: _kextent,
                onSelectedItemChanged: (_) {
                  currentchapter = _ + 1;

                  setState(() {});
                },
                children:
                    List<Widget>.generate(chaptername.length, (int index) {
                  return Center(
                    child: Text(
                      chaptername[index],
                      style: GoogleFonts.anekOdia(fontWeight: FontWeight.bold),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: height * 0.23,
            ),
            Container(
              height: height * 0.05,
              child: (getter != ['noplay', 'noplay'])
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      onPressed: () async {
                        var res = await getshared();
                        print(res);

                        if (res[0] != 'noplay') {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        lang: 'odi',
                                        chap: res[0].toString(),
                                        verse: res[1].toString(),
                                      )),
                              (Route<dynamic> route) => false);
                        } else
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("No previous visits found"),
                          ));
                      },
                      child: Text(
                        "Continue last played",
                        style: TextStyle(color: Colors.black),
                      ))
                  : Container(),
            ),
            Container(
              height: height * 0.27,
              child: GridView.count(
                crossAxisCount: width ~/ 70,
                children: List.generate(
                    chap_verse[currentchapter],
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(
                            tag: "${index + 1}",
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 231, 225, 225)),
                              onPressed: () async {
                                verseno = index + 1;

                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Home(
                                              lang: 'odi',
                                              chap: currentchapter.toString(),
                                              verse: verseno.toString(),
                                            )),
                                    (Route<dynamic> route) => false);
                              },
                              child: Container(
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                      child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ))),
                            ),
                          ),
                        )),
              ),
            )
          ])),
        ],
      ),
    );
  }
}

getshared() async {
  final prefs = await SharedPreferences.getInstance();
  return [
    prefs.getString('lastchap') ?? 'noplay',
    prefs.getString('lastverse') ?? 'noplay'
  ];
}
