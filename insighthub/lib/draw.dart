import 'package:flutter/material.dart';

import 'Home.dart';
import 'app.dart';
import 'contain.dart';
class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  List<String> myItems = ["Home", "Profile", "Settings", "Logout"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.blue,
        title: Text("InSightHub", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.all(0),

          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(  color: Colors.blue ),
               accountName: Text("Master",style : TextStyle(fontSize:18 , color:Colors.white)),
               accountEmail: Text("godMaster@gmail.com",style : TextStyle(fontSize:18 , color:Colors.white)),
               currentAccountPictureSize: Size.square(75),
               currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage("lib/container/jinwo.jpg"),
                          ),
                    ) ,
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.hdr_auto),
              title: Text("App Bar"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => App()  ),
                    ); }
            ),
            ListTile(
                leading: Icon(Icons.face),
                title: Text("Container"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Contain()  ),
                  ); }
            ),
          ]
        )
      ),
      endDrawer :  Drawer(
        child: ListView.builder(
            itemCount : 4,
          itemBuilder: (BuildContext context, int idx ) {
            return ListTile(
              leading: Icon(Icons.list),
              title: Text(myItems[idx]),
              trailing: Icon(Icons.done),
            );}
          ),
        ),
     body: Center(
          child: Material(
    color: Colors.transparent, // Material ancestor for ripple
    child: InkWell(
    onTap: () {
    print("onTap: Single tap detected");
    },
    onDoubleTap: () {
    print("onDoubleTap: Double tap detected");
    },
    onLongPress: () {
    print("onLongPress: Long press detected");
    },
    onTapDown: (details) {
    print("onTapDown: Finger touched at ${details.globalPosition}");
    },
    onTapCancel: () {
    print("onTapCancel: Tap cancelled");
    },
    splashColor: Colors.redAccent,       // ripple color
    highlightColor: Colors.blue, // pressed background color
    hoverColor: Colors.green,      // mouse hover color (web/desktop)
    focusColor: Colors.brown,       // focus color
    borderRadius: BorderRadius.circular(20),        // rounded ripple
    customBorder: RoundedRectangleBorder(           // custom shape (optional)
    borderRadius: BorderRadius.circular(20),
    ),
    child: Container(
    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
    decoration: BoxDecoration(
    // color: Colors.orange,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.black, width: 2),
    ),
    child: Text(
    "Tap Me!",
    style: TextStyle(fontSize: 20,),
    ),
    ),
    ),
     ),
     ),
      );
  }
}
