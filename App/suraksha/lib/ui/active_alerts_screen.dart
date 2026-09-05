import 'package:flutter/material.dart';
import '../services/appwrite_services.dart';
import 'map_screen.dart';


class ActiveAlertsScreen extends StatefulWidget {
  const ActiveAlertsScreen({super.key});

  @override
  State<ActiveAlertsScreen> createState() =>
      _ActiveAlertsScreenState();
}

class _ActiveAlertsScreenState
    extends State<ActiveAlertsScreen> {

  final AppwriteService service =
  AppwriteService();

  List alerts = [];

  @override
  void initState() {
    super.initState();
    loadAlerts();
  }

  Future<void> loadAlerts() async {

    final result =
    await service.getActiveAlerts();

    setState(() {
      alerts = result.documents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Active SOS"),
      ),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (_, index) {

          final doc = alerts[index];
          final data =
          doc.data as Map<String,dynamic>;

          return ListTile(
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(
                    userId: data['uid'],
                    lat: (data['latitude'] as num).toDouble(),
                    lon: (data['longitude'] as num).toDouble(),
                    alertId: doc.$id,
                  ),
                ),
              );
            },
            leading: const Icon(
              Icons.warning,
              color: Colors.red,
            ),
            title: Text(
              data['uid'],
            ),
            subtitle: Text(
              data['status'],
            ),
          );
        },
      ),
    );
  }
}
