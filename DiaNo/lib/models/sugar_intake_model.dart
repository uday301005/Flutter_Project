import 'food_model.dart';

class SugarIntake {
  final String id;
  final String userId;
  final Food food;
  final double portionSizeGrams;
  final double sugarAmount; // actual sugar consumed in grams
  final double calories; // actual calories consumed
  final DateTime consumedAt;
  final String? notes;
  final String? imagePath; // path to the captured food image

  SugarIntake({
    required this.id,
    required this.userId,
    required this.food,
    required this.portionSizeGrams,
    required this.sugarAmount,
    required this.calories,
    required this.consumedAt,
    this.notes,
    this.imagePath,
  });

  // Create SugarIntake from food and portion size
  factory SugarIntake.fromFood({
    required String id,
    required String userId,
    required Food food,
    required double portionSizeGrams,
    DateTime? consumedAt,
    String? notes,
    String? imagePath,
  }) {
    return SugarIntake(
      id: id,
      userId: userId,
      food: food,
      portionSizeGrams: portionSizeGrams,
      sugarAmount: food.getSugarForPortion(portionSizeGrams),
      calories: food.getCaloriesForPortion(portionSizeGrams),
      consumedAt: consumedAt ?? DateTime.now(),
      notes: notes,
      imagePath: imagePath,
    );
  }

  // Get the meal type based on consumption time
  String get mealType {
    final hour = consumedAt.hour;
    if (hour >= 5 && hour < 11) return 'Breakfast';
    if (hour >= 11 && hour < 16) return 'Lunch';
    if (hour >= 16 && hour < 20) return 'Dinner';
    return 'Snack';
  }

  // Check if this intake is from today
  bool get isToday {
    final now = DateTime.now();
    return consumedAt.year == now.year &&
           consumedAt.month == now.month &&
           consumedAt.day == now.day;
  }

  // Get risk level for this intake
  String get riskLevel {
    if (sugarAmount >= 15) return 'High';
    if (sugarAmount >= 8) return 'Medium';
    return 'Low';
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'food': food.toMap(),
      'portionSizeGrams': portionSizeGrams,
      'sugarAmount': sugarAmount,
      'calories': calories,
      'consumedAt': consumedAt.toIso8601String(),
      'notes': notes,
      'imagePath': imagePath,
    };
  }

  // Create from Map
  factory SugarIntake.fromMap(Map<String, dynamic> map) {
    return SugarIntake(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      food: Food.fromMap(map['food']),
      portionSizeGrams: (map['portionSizeGrams'] ?? 0.0).toDouble(),
      sugarAmount: (map['sugarAmount'] ?? 0.0).toDouble(),
      calories: (map['calories'] ?? 0.0).toDouble(),
      consumedAt: DateTime.parse(map['consumedAt']),
      notes: map['notes'],
      imagePath: map['imagePath'],
    );
  }

  // Create a copy with updated fields
  SugarIntake copyWith({
    String? id,
    String? userId,
    Food? food,
    double? portionSizeGrams,
    double? sugarAmount,
    double? calories,
    DateTime? consumedAt,
    String? notes,
    String? imagePath,
  }) {
    return SugarIntake(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      food: food ?? this.food,
      portionSizeGrams: portionSizeGrams ?? this.portionSizeGrams,
      sugarAmount: sugarAmount ?? this.sugarAmount,
      calories: calories ?? this.calories,
      consumedAt: consumedAt ?? this.consumedAt,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'SugarIntake{food: ${food.name}, portion: ${portionSizeGrams}g, sugar: ${sugarAmount}g, meal: $mealType}';
  }
}
