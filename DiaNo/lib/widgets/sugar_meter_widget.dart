import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SugarMeterWidget extends StatelessWidget {
  final double currentIntake;
  final double dailyLimit;
  final double remainingSugar;
  final double progress;

  const SugarMeterWidget({
    super.key,
    required this.currentIntake,
    required this.dailyLimit,
    required this.remainingSugar,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    String statusText;
    IconData statusIcon;

    if (progress >= 1.0) {
      progressColor = Colors.red;
      statusText = 'Limit Exceeded!';
      statusIcon = Icons.warning;
    } else if (progress >= 0.8) {
      progressColor = Colors.orange;
      statusText = 'Approaching Limit';
      statusIcon = Icons.warning_amber;
    } else if (progress >= 0.6) {
      progressColor = Colors.amber;
      statusText = 'Moderate Intake';
      statusIcon = Icons.info;
    } else {
      progressColor = const Color(0xFF4CAF50);
      statusText = 'Good Progress';
      statusIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(statusIcon, color: progressColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Circular Progress Indicator
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  percent: progress.clamp(0.0, 1.0),
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${currentIntake.toStringAsFixed(1)}g',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'of ${dailyLimit.toStringAsFixed(0)}g',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  progressColor: progressColor,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: true,
                  animationDuration: 1000,
                ),
                if (progress > 1.0)
                  Positioned(
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'EXCEEDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Consumed',
                '${currentIntake.toStringAsFixed(1)}g',
                Icons.local_drink,
                const Color(0xFF2E7D32),
              ),
              _buildStatItem(
                'Remaining',
                '${remainingSugar.toStringAsFixed(1)}g',
                Icons.timer,
                remainingSugar > 0 ? const Color(0xFF4CAF50) : Colors.red,
              ),
              _buildStatItem(
                'Daily Limit',
                '${dailyLimit.toStringAsFixed(0)}g',
                Icons.flag,
                Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
