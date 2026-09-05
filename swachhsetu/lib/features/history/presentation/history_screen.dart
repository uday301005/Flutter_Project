import 'package:flutter/material.dart';
import '../../../core/widgets/empty_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final search = TextEditingController();
  int tab = 0;
  final reports = ['#WS-1024 - Overflowing Dustbin - In Progress'];
  final pickups = ['PK-2041 - Dry waste - Assigned'];
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = tab == 0 ? reports : pickups;
    final items = all
        .where((e) => e.toLowerCase().contains(search.text.toLowerCase()))
        .toList();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('My Activity')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: search,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search activity',
                ),
              ),
            ),
            TabBar(
              onTap: (i) => setState(() => tab = i),
              tabs: const [
                Tab(text: 'Reports'),
                Tab(text: 'Pickups'),
                Tab(text: 'Complaints'),
              ],
            ),
            Expanded(
              child: tab == 2 || items.isEmpty
                  ? const EmptyState(message: 'No matching activity')
                  : ListView(
                      children: items
                          .map(
                            (e) => ListTile(
                              leading: Icon(
                                tab == 0
                                    ? Icons.report_outlined
                                    : Icons.local_shipping_outlined,
                              ),
                              title: Text(e),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
