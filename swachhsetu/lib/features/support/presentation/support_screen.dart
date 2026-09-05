import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _description = TextEditingController();
  String? _error;
  bool _sent = false;
  final _questions = const [
    'How do I report waste?',
    'How does waste scanning work?',
    'How do I request pickup?',
    'How can I track my report?',
    'How do I find nearby bins?',
  ];

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Frequently asked questions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ..._questions.map(
            (question) => ExpansionTile(
              title: Text(question),
              children: const [
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'This workflow is available in the SwachhSetu app.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Contact Support',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Production support contact details will be configured later.',
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _description,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Describe an app problem',
              errorText: _error,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () {
              if (_description.text.trim().isEmpty) {
                setState(() => _error = 'Describe the issue');
                return;
              }
              setState(() {
                _error = null;
                _sent = true;
              });
            },
            child: Text(_sent ? 'Request submitted' : 'Submit support request'),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'About SwachhSetu\nSmarter Waste. Cleaner Communities.\nCitizen-focused SIH project for responsible waste management.\n\nPrivacy and Terms will be configured for production.',
          ),
        ],
      ),
    );
  }
}
