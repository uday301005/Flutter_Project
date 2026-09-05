import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    primarySwatch: Colors.deepPurple,
    cardColor: const Color.fromARGB(255, 244, 239, 239),
    canvasColor:cremeColor,
    colorScheme: ColorScheme.fromSeed(
          seedColor: darkBluishColor,
        ).copyWith(secondary: darkBluishColor),
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black),
    ),
  );
  static ThemeData darkTheme(BuildContext context) =>
      ThemeData(
        brightness: Brightness.dark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    cardColor: const Color.fromARGB(255, 22, 22, 22),
    canvasColor: darkCremeColor,
     colorScheme: ColorScheme.fromSeed(
          seedColor: lightBluishColor,
          brightness: Brightness.dark,
        ).copyWith(secondary: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white ),
    )
      );

  //Colors
  static Color cremeColor = Color(0xfff5f5f5);
  static Color darkCremeColor = Vx.gray900;
  static Color darkBluishColor = Color(0xff403b58);
  static Color lightBluishColor = Vx.indigo500;
  
}
