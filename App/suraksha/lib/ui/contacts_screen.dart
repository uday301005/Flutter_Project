import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'add_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final AppwriteService _appwriteService = AppwriteService();
  List<dynamic> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      final currentUser = await _appwriteService.getSession();
      final snapshot = await _appwriteService.listContacts(currentUser.$id);
      setState(() {
        contacts = snapshot.documents;
      });
    } catch (e) {
      debugPrint('Contacts load failed: $e');
    }
  }

  Future<void> deleteContact(String contactId) async {
    await _appwriteService.deleteContact(contactId);
    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts (${contacts.length})")),

      body: contacts.isEmpty
          ? const Center(
        child: Text(
          "No Contacts Added",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final doc = contacts[index];
          final c = doc.data as Map<String, dynamic>;
          final contactId = doc.$id;

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(c["name"] ?? "No Name"),
            subtitle: Text(
              c["phone"] ?? c["email"] ?? "",
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => deleteContact(contactId),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddContactScreen()),
          );
          loadContacts(); // refresh
        },
      ),
    );
  }
}
