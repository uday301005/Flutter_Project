import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'registration.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const First());
}

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Signup',
      home: Registration(),
    );
  }
}
