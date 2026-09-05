import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Contain extends StatefulWidget {
  const Contain({super.key});

  @override
  State<Contain> createState() => _ContainState();
}

class _ContainState extends State<Contain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.blue,
        title: Text("InSightHub", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body:  Column(
       children: [
         Card(
           elevation: 10,
           shape: RoundedRectangleBorder(
             
           ),
         ),
    ],
      ),
    );
  }
}
