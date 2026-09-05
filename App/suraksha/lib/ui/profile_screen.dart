import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'widgets/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final currentUser = await _appwriteService.getSession();
      final doc = await _appwriteService.getUserProfile(currentUser.$id);
      final data = doc.data as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
      });
    } catch (e) {
      debugPrint('Profile load failed: $e');
    }
  }

  void logout() async {
    await _appwriteService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 Avatar
            CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),

            SizedBox(height: 20),

            // 🧑 Name
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // 📧 Email
            Text(email, style: TextStyle(fontSize: 16)),

            SizedBox(height: 10),

            // 📱 Phone
            Text(phone, style: TextStyle(fontSize: 16)),

            SizedBox(height: 30),

            // 🚪 Logout Button
            ElevatedButton(onPressed: logout, child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}
