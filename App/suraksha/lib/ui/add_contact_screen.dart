import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';


class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  final TextEditingController controller = TextEditingController();
  bool isSearching = false;
  Map<String, dynamic>? foundUser;

  Future<void> searchUser() async {
    setState(() {
      isSearching = true;
    });
    final value = controller.text.trim();
    if (value.isEmpty) return;

    try {
      final result = await _appwriteService.searchUserByEmail(value);
      if (result.documents.isNotEmpty) {
        setState(() {
          foundUser = result.documents.first.data as Map<String, dynamic>;
        });
      } else {
        setState(() {
          foundUser = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User not found"),
          ),
        );
      }
    } catch (e) {
      debugPrint('Search user failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    }
    finally {
      setState(() {
        isSearching = false;
      });
    }
  }


  Future<void> addContact() async {
    if (foundUser == null) return;

    try {
      final currentUser = await _appwriteService.getSession();
      final email = foundUser!['email'] as String? ?? '';
      final contactUid = foundUser!['uid'] as String? ?? '';

      if (email == (currentUser.email ?? '')) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('You cannot add yourself')));
        return;
      }

      final existing = await _appwriteService.findContact(
        currentUser.$id,
        contactUid,
      );
      if (existing.documents.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Contact already added')));
        return;
      }

      await _appwriteService.addContact(
        ownerId: currentUser.$id,
        contactData: {
          'contactUid': contactUid,
          'name': foundUser!['name'],
          'email': email,
          'phone': foundUser!['phone'] ?? '',
        },
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Contact added successfully')));
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Add contact failed: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Add contact failed: $e')));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Contact")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter email",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchUser,
                ),
              ),
            ),
            if (isSearching)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            SizedBox(height: 20),

            if (foundUser != null)
              Card(
                child: ListTile(
                  title: Text(foundUser!["name"]),
                  subtitle: Text(foundUser!["email"]),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: addContact,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
