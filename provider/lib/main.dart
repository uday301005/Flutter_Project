import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:   HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
   int  _count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Home'),
      ),
      body: Center(
        child: Text('$_count', style: TextStyle(fontSize: 25),),

      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),onPressed: () {

        setState(() {
          _count++;
        });
      }),
    );
  }
}

