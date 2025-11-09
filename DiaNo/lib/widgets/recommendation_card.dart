import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final double currentIntake;
  final double dailyLimit;

  const RecommendationCard({
    super.key,
    required this.currentIntake,
    required this.dailyLimit,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentIntake / dailyLimit;
    String title;
    String description;
    List<String> recommendations;
    Color cardColor;
    IconData icon;

    if (progress >= 1.0) {
      title = 'Limit Exceeded!';
      description = 'You have exceeded your daily sugar limit.';
      recommendations = [
        'Drink plenty of water to help flush out excess sugar',
        'Choose sugar-free alternatives for your next meal',
        'Consider light exercise to help burn excess calories',
        'Plan healthier meals for tomorrow',
      ];
      cardColor = Colors.red;
      icon = Icons.warning;
    } else if (progress >= 0.8) {
      title = 'Approaching Limit';
      description = 'You\'re close to your daily sugar limit.';
      recommendations = [
        'Choose water or unsweetened beverages',
        'Opt for fresh fruits instead of desserts',
        'Read food labels carefully',
        'Consider smaller portion sizes',
      ];
      cardColor = Colors.orange;
      icon = Icons.warning_amber;
    } else if (progress >= 0.6) {
      title = 'Moderate Intake';
      description = 'You\'re doing well with your sugar intake.';
      recommendations = [
        'Continue making healthy food choices',
        'Add more vegetables to your meals',
        'Stay hydrated throughout the day',
        'Keep tracking your food intake',
      ];
      cardColor = Colors.amber;
      icon = Icons.info;
    } else {
      title = 'Great Progress!';
      description = 'You\'re well within your healthy sugar limits.';
      recommendations = [
        'Keep up the excellent work!',
        'Consider adding more variety to your diet',
        'Stay consistent with your tracking',
        'Share your success with others',
      ];
      cardColor = const Color(0xFF4CAF50);
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cardColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommendations:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 12),
          ...recommendations.map((recommendation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
