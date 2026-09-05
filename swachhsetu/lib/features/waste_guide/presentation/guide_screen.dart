import 'package:flutter/material.dart';
import '../domain/waste_guide_entry.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});
  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  String q = '';
  @override
  Widget build(BuildContext c) {
    final items = wasteGuideEntries
        .where((e) => e.title.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Waste Guide')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Search waste types',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (c, i) => ListTile(
                leading: Icon(items[i].icon),
                title: Text(items[i].title),
                subtitle: Text(items[i].description),
                onTap: () => showDialog(
                  context: c,
                  builder: (_) => AlertDialog(
                    title: Text(items[i].title),
                    content: Text(
                      '${items[i].examples}\n\nDo: ${items[i].doText}\n\nDo not: ${items[i].dontText}\n\n${items[i].recommendation}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
