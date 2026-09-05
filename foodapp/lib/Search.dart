import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:foodapp/recipe_view.dart';
import 'dart:developer';
import 'model.dart';
import 'package:foodapp/home.dart';

class Search extends StatefulWidget {
  final String query;
  const Search({Key? key, required this.query}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isLoading = true;
  bool isSearching = false;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = TextEditingController();

  getRecipe(String query) async {
    setState(() {
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
            appUrl: element['strSource'] ?? "",
          );
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
    searchController.text = widget.query;
    getRecipe(widget.query);
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
              gradient: LinearGradient(
                colors: [Color(0xff213A50), Color(0xff071938)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                // Back Button
                Container(
                  margin: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(100, 100, 100, 0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.5)),
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Container(
                  margin: EdgeInsets.only(
                    top: 0,
                    left: 16,
                    right: 16,
                    bottom: 12,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(100, 100, 100, 0.4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchController.text).replaceAll(' ', '') ==
                              '') {
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Search for a dish...",
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontFamily: "t0",
                            ),
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
                SizedBox(height: 10),
                Container(
                  height: 500,
                  child: isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipeView(url: recipeList[index].appUrl)));
                              },
                              child: Card(
                                margin: EdgeInsets.all(8),
                                elevation: 0.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        recipeList[index].appImgUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: double.infinity,
                                                height: 200,
                                                color: Colors.grey[300],
                                                child: Icon(Icons.error),
                                              );
                                            },
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                        ),
                                        child: Text(
                                          recipeList[index].appLabel,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      width: 70,
                                      height: 30,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,

                                            children: [
                                              Icon(
                                                Icons.local_fire_department,
                                                color: Colors.red,
                                                size: 16,
                                              ),
                                              Text(
                                                recipeList[index].appCalories
                                                    .toStringAsFixed(0),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
