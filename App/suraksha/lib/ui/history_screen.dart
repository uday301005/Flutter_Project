import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {

  final AppwriteService service =
  AppwriteService();

  List alerts = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {

    final user =
    await service.getSession();

    final result =
    await service.getMyAlerts(
      user.$id,
    );

    setState(() {
      alerts = result.documents;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("SOS History"),
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (_, index) {

          final doc = alerts[index];
          final data =
          doc.data as Map<String,dynamic>;

          return ListTile(
            leading: const Icon(
              Icons.history,
            ),
            title: Text(
              data['status'],
            ),
            subtitle: Text(
              data['timestamp'],
            ),
          );
        },
      ),
    );
  }
}