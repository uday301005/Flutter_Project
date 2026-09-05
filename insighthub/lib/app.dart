import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insighthub"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ),],
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 50.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
