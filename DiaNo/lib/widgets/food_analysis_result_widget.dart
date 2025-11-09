import 'package:flutter/material.dart';
import '../services/ai_food_analysis_service.dart';

class FoodAnalysisResultWidget extends StatelessWidget {
  final FoodAnalysisResult result;
  final VoidCallback onAddToTracker;
  final VoidCallback onRetake;

  const FoodAnalysisResultWidget({
    super.key,
    required this.result,
    required this.onAddToTracker,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(result.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(result.category),
                  color: _getCategoryColor(result.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.foodName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      result.category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getConfidenceColor(result.confidence),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(result.confidence * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Nutrition Information
          const Text(
            'Nutrition Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNutritionCard(
                  'Sugar',
                  '${result.sugarContent.toStringAsFixed(1)}g',
                  Icons.local_drink,
                  const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNutritionCard(
                  'Calories',
                  result.calories.toStringAsFixed(0),
                  Icons.whatshot,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Health Impact
          _buildHealthImpact(),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRetake,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Retake Photo',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddToTracker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Add to Tracker',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthImpact() {
    String impact;
    Color impactColor;
    IconData impactIcon;

    if (result.sugarContent > 20) {
      impact = 'High sugar content - consume in moderation';
      impactColor = Colors.red;
      impactIcon = Icons.warning;
    } else if (result.sugarContent > 10) {
      impact = 'Moderate sugar content - good for occasional consumption';
      impactColor = Colors.orange;
      impactIcon = Icons.info;
    } else {
      impact = 'Low sugar content - healthy choice!';
      impactColor = Colors.green;
      impactIcon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: impactColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: impactColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(impactIcon, color: impactColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              impact,
              style: TextStyle(
                fontSize: 14,
                color: impactColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Colors.green;
      case 'vegetables':
        return Colors.lightGreen;
      case 'grains':
        return Colors.amber;
      case 'protein':
        return Colors.red;
      case 'dairy':
        return Colors.blue;
      case 'sweets':
        return Colors.pink;
      case 'beverages':
        return Colors.cyan;
      case 'fast food':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'grains':
        return Icons.grain;
      case 'protein':
        return Icons.restaurant;
      case 'dairy':
        return Icons.local_drink;
      case 'sweets':
        return Icons.cake;
      case 'beverages':
        return Icons.local_cafe;
      case 'fast food':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }
}
