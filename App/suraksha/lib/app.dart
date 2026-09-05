import 'package:flutter/material.dart';
import 'package:suraksha/services/appwrite_services.dart';
import 'ui/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'ui/widgets/auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 MyApp.build() called');
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasData) {
      //       return HomeScreen();
      //     }
      //     return AuthScreen();
      //   },
      // ),
      home: FutureBuilder(
        future: AppwriteService().getSession(),
        builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return HomeScreen();
          }
          return AuthScreen();
        },),
    );
  }
}
