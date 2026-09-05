import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';
import 'map_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AppwriteService _appwriteService = AppwriteService();

  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final currentUser = await _appwriteService.getSession();

      final result = await _appwriteService.getAllNotifications(
        currentUser.$id,
      );

      setState(() {
        notifications = result.documents;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Notification load failed: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openNotification(dynamic doc) async {
    final data = doc.data as Map<String, dynamic>;

    await _appwriteService.updateNotificationStatus(
      documentId: doc.$id,
      status: 'opened',
    );

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          userId: data['senderId'],
          lat: (data['lat'] as num).toDouble(),
          lon: (data['lon'] as num).toDouble(),
          alertId: data['alertId'],
        ),
      ),
    );
  }

  Future<void> ignoreNotification(dynamic doc) async {
    await _appwriteService.updateNotificationStatus(
      documentId: doc.$id,
      status: 'ignored',
    );

    loadNotifications();
  }
  Widget statusChip(String status) {
    switch (status) {
      case 'opened':
        return const Chip(
          label: Text("Opened"),
        );

      case 'ignored':
        return const Chip(
          label: Text("Ignored"),
        );

      default:
        return const Chip(
          label: Text("Pending"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : notifications.isEmpty
          ? const Center(
        child: Text(
          "No Notifications",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final doc = notifications[index];
          final data =
          doc.data as Map<String, dynamic>;
          final status = data['status'] ?? 'pending';
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(
                Icons.warning,
                color: Colors.red,
              ),
              title: const Text(
                "SOS Alert",
              ),
              subtitle: Text(
                "Sender: ${data['senderId']}",
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  statusChip(status),

                  PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Text('View'),
                      ),
                      const PopupMenuItem(
                        value: 'ignore',
                        child: Text('Ignore'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'view') {
                        openNotification(doc);
                      } else {
                        ignoreNotification(doc);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}