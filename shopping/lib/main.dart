import 'package:flutter/material.dart';
import 'package:shopping/core/store.dart';
import 'package:shopping/pages/cart.dart';
import 'package:shopping/pages/login.dart';
import 'package:shopping/widgets/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'pages/home.dart';
import 'package:shopping/utils/routes.dart';
void main() {
  runApp(VxState(
    store: MyStore(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.homeRoute,
      routes: {
         MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute : (context) => LoginPage(),
        MyRoutes.cartRoute : (context) => CartPage(),
      }
    ) ;
  }
}