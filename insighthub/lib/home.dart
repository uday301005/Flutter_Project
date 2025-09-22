import 'package:flutter/material.dart';
import 'package:insighthub/ram.dart';
import 'package:insighthub/draw.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<String> navBarItems =  ["Top News", "India", "World","Health" "Finance"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text("InSightHub", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child : Row(
                children: [
                  Icon(Icons.search, color: Colors.blueAccent),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Health',
                      ),
                    ),
                  ),
                ],
              ),
            ),
         Container(
           height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: navBarItems.length,
                 itemBuilder: (context, index){
                  return InkWell(
                    onTap: () {
                      print(navBarItems[index]);
                    },
                    onDoubleTap: (){
                      print("navBarItems[index]");
                    },
                    onLongPress: (){
                      print("long");
                    },
                    onTapDown: (details){
                      print("vertical");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                     margin: EdgeInsets.symmetric(horizontal: 5),
                                     decoration: BoxDecoration(
                     color: Colors.blueAccent,

                     borderRadius: BorderRadius.circular(15),
                                     ),
                                     child: Center(
                     child: Text(navBarItems[index]
                     ,style: TextStyle(
                           fontSize: 17,
                           fontWeight: FontWeight.bold,
                           color: Colors.white),),
                                     ),
                    ),
                  );
                 }
              ),
            ),
         CarouselSlider(
           options: CarouselOptions(
             height: 200,
             autoPlay: true,
             aspectRatio: 16/9,
             enableInfiniteScroll: false,
             enlargeCenterPage: true,

           ),
             items:  items.map((item){
                 return Builder(builder: (BuildContext context){
                   return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                       decoration: BoxDecoration(
                         color: item,

                       ),
                   );
                 });
             }).toList(),
           ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('HOME button is disabled'),
                    duration: Duration(seconds: 1)),
              );
            }),
            IconButton(
               icon: Icon(Icons.sentiment_dissatisfied_outlined ), onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => Draw()),
              );
            }),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Ram()),

          );
        },
        hoverColor: Colors.purpleAccent,
        hoverElevation: 9999.0,
        child: Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
  final List items = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.orange, Colors.purple, Colors.pink, Colors.brown, Colors.grey, Colors.black];
}
