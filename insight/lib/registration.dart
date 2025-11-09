import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(image:  AssetImage('assets/register.png') , fit: BoxFit.cover )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body:  Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 35,top: 130),
                child: Text("Welcome\nBack",style: TextStyle(color: Colors.white, fontSize: 33),),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.5,left: 35,right: 35),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            hintText: 'Email',
                            border:OutlineInputBorder (
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height:30,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            hintText: 'Password',
                            border:OutlineInputBorder (
                                borderRadius: BorderRadius.circular(10))),),
                      SizedBox(
                        height:40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sign In', style: TextStyle(
                              color: Color(0xff4c505b),
                              fontSize: 27,fontWeight: FontWeight.w700),),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {} , icon: Icon(Icons.arrow_forward)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(onPressed: () {  Navigator.pushNamed(context, 'register');},
                              child: Text('Sign Up',style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,
                                color: Color(0xff4c505b),
                              )
                              )
                          ),
                          TextButton(onPressed: () {

                          },
                              child: Text('Forgot Password',style: TextStyle(decoration: TextDecoration.underline,
                                fontSize: 20,
                                color: Color(0xff4c505b),
                              )
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ) ,
        )
    );
  }
}
