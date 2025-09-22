import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

class FoodAnalysisResult {
  final String foodName;
  final double sugarContent;
  final double calories;
  final String category;
  final double confidence;

  FoodAnalysisResult({
    required this.foodName,
    required this.sugarContent,
    required this.calories,
    required this.category,
    required this.confidence,
  });
}

class AIFoodAnalysisService {
  // Simulated food database with sugar content per 100g
  static const Map<String, Map<String, dynamic>> _foodDatabase = {
    'apple': {'sugar': 10.4, 'calories': 52, 'category': 'Fruits'},
    'banana': {'sugar': 12.2, 'calories': 89, 'category': 'Fruits'},
    'orange': {'sugar': 9.4, 'calories': 47, 'category': 'Fruits'},
    'strawberry': {'sugar': 4.9, 'calories': 32, 'category': 'Fruits'},
    'grape': {'sugar': 16.0, 'calories': 67, 'category': 'Fruits'},
    'mango': {'sugar': 14.8, 'calories': 60, 'category': 'Fruits'},
    'pineapple': {'sugar': 9.9, 'calories': 50, 'category': 'Fruits'},
    'watermelon': {'sugar': 6.2, 'calories': 30, 'category': 'Fruits'},
    'bread': {'sugar': 3.3, 'calories': 265, 'category': 'Grains'},
    'rice': {'sugar': 0.1, 'calories': 130, 'category': 'Grains'},
    'pasta': {'sugar': 0.6, 'calories': 131, 'category': 'Grains'},
    'pizza': {'sugar': 3.6, 'calories': 266, 'category': 'Fast Food'},
    'burger': {'sugar': 4.2, 'calories': 295, 'category': 'Fast Food'},
    'fries': {'sugar': 0.3, 'calories': 365, 'category': 'Fast Food'},
    'chicken': {'sugar': 0.0, 'calories': 165, 'category': 'Protein'},
    'fish': {'sugar': 0.0, 'calories': 206, 'category': 'Protein'},
    'beef': {'sugar': 0.0, 'calories': 250, 'category': 'Protein'},
    'eggs': {'sugar': 0.6, 'calories': 155, 'category': 'Protein'},
    'milk': {'sugar': 4.7, 'calories': 42, 'category': 'Dairy'},
    'cheese': {'sugar': 0.5, 'calories': 113, 'category': 'Dairy'},
    'yogurt': {'sugar': 4.7, 'calories': 59, 'category': 'Dairy'},
    'chocolate': {'sugar': 47.9, 'calories': 546, 'category': 'Sweets'},
    'cake': {'sugar': 40.0, 'calories': 350, 'category': 'Sweets'},
    'cookies': {'sugar': 28.0, 'calories': 488, 'category': 'Sweets'},
    'ice_cream': {'sugar': 21.2, 'calories': 207, 'category': 'Sweets'},
    'soda': {'sugar': 10.6, 'calories': 42, 'category': 'Beverages'},
    'juice': {'sugar': 9.0, 'calories': 45, 'category': 'Beverages'},
    'coffee': {'sugar': 0.0, 'calories': 2, 'category': 'Beverages'},
    'tea': {'sugar': 0.0, 'calories': 1, 'category': 'Beverages'},
    'salad': {'sugar': 2.0, 'calories': 25, 'category': 'Vegetables'},
    'carrot': {'sugar': 4.7, 'calories': 41, 'category': 'Vegetables'},
    'broccoli': {'sugar': 1.5, 'calories': 34, 'category': 'Vegetables'},
    'tomato': {'sugar': 2.6, 'calories': 18, 'category': 'Vegetables'},
  };

  static Future<FoodAnalysisResult> analyzeFoodImage(File imageFile) async {
    try {
      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 2));

      // In a real app, you would:
      // 1. Load the image
      // 2. Preprocess it (resize, normalize, etc.)
      // 3. Run it through a trained CNN model
      // 4. Get predictions with confidence scores
      
      // For simulation, we'll randomly select a food item
      final random = Random();
      final foodNames = _foodDatabase.keys.toList();
      final selectedFood = foodNames[random.nextInt(foodNames.length)];
      final foodData = _foodDatabase[selectedFood]!;

      // Simulate portion size (50g to 300g)
      final portionSize = 50 + random.nextInt(251);
      final sugarContent = (foodData['sugar'] * portionSize / 100);
      final calories = (foodData['calories'] * portionSize / 100);

      // Simulate confidence (70% to 95%)
      final confidence = 0.7 + random.nextDouble() * 0.25;

      return FoodAnalysisResult(
        foodName: _formatFoodName(selectedFood),
        sugarContent: double.parse(sugarContent.toStringAsFixed(1)),
        calories: double.parse(calories.toStringAsFixed(1)),
        category: foodData['category'],
        confidence: double.parse(confidence.toStringAsFixed(2)),
      );
    } catch (e) {
      // Return a default result if analysis fails
      return FoodAnalysisResult(
        foodName: 'Unknown Food',
        sugarContent: 0.0,
        calories: 0.0,
        category: 'Unknown',
        confidence: 0.0,
      );
    }
  }

  static String _formatFoodName(String foodKey) {
    return foodKey.split('_').map((word) => 
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  static List<String> getFoodSuggestions(String partialName) {
    final suggestions = <String>[];
    final searchTerm = partialName.toLowerCase();
    
    for (final foodName in _foodDatabase.keys) {
      if (foodName.contains(searchTerm) || 
          _formatFoodName(foodName).toLowerCase().contains(searchTerm)) {
        suggestions.add(_formatFoodName(foodName));
      }
    }
    
    return suggestions.take(5).toList();
  }

  static FoodAnalysisResult getFoodDataByName(String foodName) {
    final foodKey = foodName.toLowerCase().replaceAll(' ', '_');
    final foodData = _foodDatabase[foodKey];
    
    if (foodData != null) {
      return FoodAnalysisResult(
        foodName: foodName,
        sugarContent: foodData['sugar'].toDouble(),
        calories: foodData['calories'].toDouble(),
        category: foodData['category'],
        confidence: 1.0,
      );
    }
    
    // Return default if not found
    return FoodAnalysisResult(
      foodName: foodName,
      sugarContent: 0.0,
      calories: 0.0,
      category: 'Unknown',
      confidence: 0.0,
    );
  }
}
