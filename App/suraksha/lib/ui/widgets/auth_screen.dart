import 'package:flutter/material.dart';
import '../../services/appwrite_services.dart';
import '../home_screen.dart';
import 'package:appwrite/appwrite.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final Client client = Client()
    ..setEndpoint('https://sgp.cloud.appwrite.io/v1')
    ..setProject('6a26df87003b0454aa2e');

  bool isLogin = true;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AppwriteService _appwriteService = AppwriteService();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await _appwriteService.login(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        await _appwriteService.signup(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          phone: phoneController.text.trim(),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() => isLoading = false);
  }
 Future<void> testPing() async {
  await _appwriteService.testPing();
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // 🔥 APP TITLE
                Text(
                  "Suraksha",
                  style: TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                // 🔁 TOGGLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => isLogin = true);
                      },
                      child: Text("Login",
                          style: TextStyle(
                              color: isLogin
                                  ? Colors.blue
                                  : Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => isLogin = false);
                      },
                      child: Text("Register",
                          style: TextStyle(
                              color: !isLogin
                                  ? Colors.blue
                                  : Colors.grey)),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // 👤 NAME (Register only)
                if (!isLogin)
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (val) =>
                    val!.isEmpty ? "Enter name" : null,
                  ),

                if (!isLogin) SizedBox(height: 10),

                // 📱 PHONE (Register only)
                if (!isLogin)
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                    validator: (val) =>
                    val!.isEmpty ? "Enter phone" : null,
                  ),

                if (!isLogin) SizedBox(height: 10),

                // 📧 EMAIL
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (val) =>
                  val!.contains("@") ? null : "Invalid email",
                ),

                SizedBox(height: 10),

                // 🔒 PASSWORD
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: (val) =>
                  val!.length < 6 ? "Min 6 chars" : null,
                ),

                SizedBox(height: 20),

                // 🚀 BUTTON
                isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: submit,
                  child: Text(isLogin ? "Login" : "Register"),
                ),

                SizedBox(height: 10),

                // 🔄 SWITCH TEXT
                TextButton(
                  onPressed: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Text(isLogin
                      ? "Don't have an account? Register"
                      : "Already have an account? Login"),
                ),
                ElevatedButton(
  onPressed: testPing,
  child: Text("Test Ping"),
)
              ],
            ),
          ),
        ),
      ),
    );
  }
}