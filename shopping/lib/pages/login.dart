import 'package:flutter/material.dart';
import 'package:shopping/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String name = "";
  bool changeButton = false;
  final  _formKey = GlobalKey<FormState>();

  Future<void> moveToHome (BuildContext context) async {
    setState(() {
      changeButton = true;
    });
    await Future.delayed(Duration(seconds:1));
    await Navigator.pushNamed(context, MyRoutes.homeRoute);
    setState(() {
      changeButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: SingleChildScrollView(
        child: Form(
           key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.asset(
                "assets/images/hey.png",
                fit: BoxFit.cover,
                height: 300,
              ),
              SizedBox(height: 20.0),
              Text(
                "Welcome $name",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
                child: Column(
                  children: [
                    TextFormField(
              //         onChanged: (value){
              //           name = value;
              //           setState(() {
              //           });
              // },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Username",
                        labelText: "Username",
                      ),
                    ),
                    TextFormField(
                      validator: (value){
                        if( value == null || value.isEmpty){
                          return "Password cannot be empty";
                        }
                        if(value.length < 8) {
                          return "Password minimum 8 digit";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        labelText: "Password",
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 40.0),
                    Material(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(changeButton ? 50 :8),
                      child: InkWell (
                        // splashColor: Colors.red,
                        onTap: () {
                          if(_formKey.currentState!.validate()){
                            moveToHome(context);
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter valid details"),
                              ),
                            );
                      }
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: changeButton ? 50 : 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: changeButton ? Icon(
                            Icons.done,
                            color: Colors.white,
                          ) : Text( "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
