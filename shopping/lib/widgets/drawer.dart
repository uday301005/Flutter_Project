import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUZPbzsRmoZGCVp8S2vGyYOch07N07iOa6ver4ZNEpfQ&s=10";
    return Drawer(
      child: Container(
        color: Colors.red,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(

                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                ),
                accountName: Text("Master"),
                accountEmail: Text("123@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),

              ),
            ),
            ListTile(
              leading: Icon(
                  CupertinoIcons.home,
                  color: Colors.white,
              ),
              title: Text("Home",
                  textScaleFactor: 1.2,
                  style : TextStyle(color:Colors.white)
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.white,
              ),
              title: Text("Profile",
                  textScaleFactor: 1.2,
                  style : TextStyle(color:Colors.white)
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.mail,
                color: Colors.white,
              ),
              title: Text("Email me",
                  textScaleFactor: 1.2,
                  style : TextStyle(color:Colors.white)
              ),
            ),
          ],
        ),
      )  ,
    );
  }
}
