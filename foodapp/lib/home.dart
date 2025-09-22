import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp/Search.dart';
import 'package:foodapp/recipe_view.dart';
import 'dart:convert';
import 'dart:developer';
import 'model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  bool isSearching = false;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController  searchController = TextEditingController();
  List <Map<String, dynamic>> recipeCatList = [
    {"imgUrl": "https://images.unsplash.com/photo-1513104890138-7c749659a591", "heading": "Pizza"},
    {"imgUrl": "https://images.unsplash.com/photo-1568901346375-23c9450c58cd", "heading": "Burger"},
    {"imgUrl": "https://images.unsplash.com/photo-1504674900247-0877df9cc836", "heading": "Pasta"},
    {"imgUrl": "https://images.unsplash.com/photo-1604503468506-a8da13d82791", "heading": "Chicken"},
    {"imgUrl": "https://images.unsplash.com/photo-1540420773420-3366772f4999", "heading": "Salad"},
    {"imgUrl": "https://images.unsplash.com/photo-1565958011703-44f9829ba187", "heading": "Dessert"}
  ];

  getRecipe(String query) async {
    setState(() {
      isLoading = true;
      isSearching = true;
    });
    
    String url = "https://www.themealdb.com/api/json/v1/1/search.php?s=$query";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    // log(data.toString());

    if (data['meals'] != null) {
      setState(() {
        recipeList.clear();
        data['meals'].forEach((element) {
          RecipeModel recipeModel = RecipeModel(
              appLabel: element['strMeal'] ?? "",
              appImgUrl: element['strMealThumb'] ?? "",
              appCalories: double.tryParse(element['idMeal'] ?? "0") ?? 0.0,
              appUrl: element['strSource'] ?? "",     );
          recipeList.add(recipeModel);
        });
        isLoading = false;
        isSearching = false;
      });
    } else {
      setState(() {
        recipeList.clear();
        isLoading = false;
        isSearching = false;
      });
      log('No meals found for this search.');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xff213A50), Color(0xff071938),
              ]
              ),
            ),
          ),
          Column(
            children: [
              // Back to Home Button
              Container(
                margin: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Already on home, just show a message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('You are already on Home!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(100, 100, 100, 0.4),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'HOME',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100,100, 100, 0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0,0,0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchController.text).replaceAll(' ', '') == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a dish name'),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search(query: searchController.text)));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: isSearching 
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24,
                              ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: "Search for a dish...",
                            hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                          ),
                          onSubmitted: (value) {
                            if (value.trim().isNotEmpty) {
                              getRecipe(value.trim());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("WHAT DO YOU WANT TO COOK TODAY?", style: TextStyle(color: Colors.white, fontSize: 20, )),
                      SizedBox(height: 10),
                      Text("Let's Cook! \nwith MASTER", style: TextStyle(color: Colors.white, fontSize: 20,)),
                    ],
                  ),
                ),
                SizedBox(height: 1),
                Expanded(
                  child: isLoading 
                    ? Center(child: CircularProgressIndicator()) 
                    : recipeList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white70,
                                size: 80,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Search for recipes to get started!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeView(url: recipeList[index].appUrl)));
                              },
                              child: Card(
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        recipeList[index].appImgUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.error, size: 40),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Text(
                                          recipeList[index].appLabel,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.local_fire_department, color: Colors.red, size: 14),
                                            SizedBox(width: 4),
                                            Text(
                                              recipeList[index].appCalories.toStringAsFixed(0),
                                              style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ),
                  Container(
                  height: 120,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: recipeCatList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search(query: recipeCatList[index]["heading"])));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    recipeCatList[index]['imgUrl'], 
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 120,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 120,
                                        color: Colors.grey[300],
                                        child: Icon(Icons.fastfood, size: 30, color: Colors.grey[600]),
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      recipeCatList[index]["heading"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
     ),
        ],
      ),
    );
  }
}
