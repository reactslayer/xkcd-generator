import 'dart:io';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xkcd_generator/widgets/internet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckUserConnection();
  }

  void getNextImage() async {
    String random_src = "c.xkcd.com";
    var url = Uri.https(random_src, '/random/comic/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var document = parse(response.body);
      String so = document
          .getElementById("comic")
          ?.children[0]
          .attributes['src'] as String;
      String t = document.getElementById('ctitle')!.innerHtml;
      setState(() {
        source = "https:" + so;
        title = t;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  String title = "Comic";
  String source = "https://imgs.xkcd.com/comics/salt_dome.png";
  @override
  Widget build(BuildContext context) {
    if (!ActiveConnection) {
      setState(() {
        ActiveConnection = false;
      });
      return InternetNotWorking(T: T);
    } else {
      return SafeArea(
        child: Material(
            child: Container(
          child: ListView(children: [
            Padding(padding: EdgeInsets.all(15)),
            Align(
                alignment: Alignment.center,
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        decoration: TextDecoration.none, fontSize: 25))),
            Padding(padding: EdgeInsets.all(15)),
            Image.network(source),
            Container(
              margin: EdgeInsets.all(25),
              child: ElevatedButton(
                  onPressed: () => {getNextImage()},
                  child: Text("Generate Next")),
            )
          ]),
        )),
      );
    }
  }
}
