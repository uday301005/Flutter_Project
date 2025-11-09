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
        child: SingleChildScrollView(
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
           Container(
             margin: EdgeInsets.symmetric(vertical: 15),
             child: CarouselSlider(
               options: CarouselOptions(
                 height: 200,
                 autoPlay: true,
                 autoPlayInterval: Duration(seconds: 2),
                 aspectRatio: 16/9,
                 // enableInfiniteScroll: false,
                 enlargeCenterPage: true,
                 autoPlayCurve: Curves.fastOutSlowIn,
                 pageSnapping: true,
                 pauseAutoPlayOnTouch: true,
                 // reverse: true,

               ),
                 items:  items.map((item){
                     return Builder(builder: (BuildContext context){
                       return Container(

                         child: Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10),
                           ),
                           child: Stack(
                             children: [
                               ClipRRect(
                                 borderRadius: BorderRadius.circular(10),
                                 child: Image.asset("lib/container/news.jpg", fit: BoxFit.fitHeight ,height: double.infinity,),
                               ),
                               Positioned(
                                   left: 0, right: 0, bottom: 0,
                                   child: Container(
                                     decoration: BoxDecoration(
                                       gradient: LinearGradient(colors: [
                                         Colors.black12.withOpacity(0.0),
                                         Colors.black,
         
                                       ],
                                           begin: Alignment.topCenter,
                                          end:  Alignment.bottomCenter,
                                       )

                                     ),
                                 child: Text(" News Headlines" ,style : TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                               )),
                             ],
                           ),
                         ),
                       );
                     });
                 }).toList(),
               ),
           ),
              Container(
                child: SizedBox(
                  // height: 310,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      shrinkWrap: true,  // error aya kyu ki  ListView ek column ek anda hai  or usk height infinite ho sak
                      itemBuilder: (context, index){
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                          child: Card(
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          child:  Stack(
                           children : [
                             ClipRRect(
                                 borderRadius: BorderRadius.circular(15),
                                 child: Image.asset("lib/container/news.jpg")
                             ),
                             Positioned(
                               left: 0,
                               right: 0,
                               bottom: 0,
                               child:  Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(15),
                                   gradient: LinearGradient(colors: [
                                     Colors.black12.withOpacity(0.0),
                                     Colors.black,
                                   ],
                                   begin:  Alignment.topCenter,
                                     end: Alignment.bottomCenter,
                                   ),
                                 ),
                                 padding: EdgeInsets.fromLTRB(15,15,10,8),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text("News Headlines" ,style: TextStyle(
                                       fontSize: 18,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.white
                                     ),
                                     ),
                                     Text("Description of news", style: TextStyle(fontSize: 12,  color: Colors.white ),),
                                   ],
                                 ),
                               ),
                             )
                           ],
                          ),
                          ),
                          // Image.asset("lib/container/news.jpg")
                        );
          
                  }),
                ),
              )
            ],
          ),
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
