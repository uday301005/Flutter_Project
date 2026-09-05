import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/sugar_tracker_provider.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onDelete;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Food Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getCategoryColor(foodItem.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(foodItem.category),
              color: _getCategoryColor(foodItem.category),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  foodItem.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(foodItem.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Nutrition Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_drink,
                    size: 16,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${foodItem.sugarContent.toStringAsFixed(1)}g',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.whatshot,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${foodItem.calories.toStringAsFixed(0)} cal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Delete Button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 20,
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
}
