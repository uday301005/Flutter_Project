class Food {
  final String id;
  final String name;
  final String category;
  final double sugarContentPer100g; // grams of sugar per 100g
  final double caloriesPer100g; // calories per 100g
  final double? carbohydratesPer100g; // optional
  final double? proteinPer100g; // optional
  final double? fatPer100g; // optional
  final String? imageUrl;
  final List<String> alternativeNames;
  final DateTime createdAt;

  Food({
    required this.id,
    required this.name,
    required this.category,
    required this.sugarContentPer100g,
    required this.caloriesPer100g,
    this.carbohydratesPer100g,
    this.proteinPer100g,
    this.fatPer100g,
    this.imageUrl,
    this.alternativeNames = const [],
    required this.createdAt,
  });

  // Calculate sugar content for a specific portion size (in grams)
  double getSugarForPortion(double portionGrams) {
    return (sugarContentPer100g * portionGrams) / 100;
  }

  // Calculate calories for a specific portion size (in grams)
  double getCaloriesForPortion(double portionGrams) {
    return (caloriesPer100g * portionGrams) / 100;
  }

  // Get risk level based on sugar content
  String get sugarRiskLevel {
    if (sugarContentPer100g >= 22.5) return 'High';
    if (sugarContentPer100g >= 5) return 'Medium';
    return 'Low';
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'sugarContentPer100g': sugarContentPer100g,
      'caloriesPer100g': caloriesPer100g,
      'carbohydratesPer100g': carbohydratesPer100g,
      'proteinPer100g': proteinPer100g,
      'fatPer100g': fatPer100g,
      'imageUrl': imageUrl,
      'alternativeNames': alternativeNames,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      sugarContentPer100g: (map['sugarContentPer100g'] ?? 0.0).toDouble(),
      caloriesPer100g: (map['caloriesPer100g'] ?? 0.0).toDouble(),
      carbohydratesPer100g: map['carbohydratesPer100g']?.toDouble(),
      proteinPer100g: map['proteinPer100g']?.toDouble(),
      fatPer100g: map['fatPer100g']?.toDouble(),
      imageUrl: map['imageUrl'],
      alternativeNames: List<String>.from(map['alternativeNames'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Create from AI recognition result
  factory Food.fromAIResult(Map<String, dynamic> aiResult) {
    return Food(
      id: aiResult['food_id'] ?? '',
      name: aiResult['name'] ?? 'Unknown Food',
      category: aiResult['category'] ?? 'Other',
      sugarContentPer100g: (aiResult['sugar_per_100g'] ?? 0.0).toDouble(),
      caloriesPer100g: (aiResult['calories_per_100g'] ?? 0.0).toDouble(),
      carbohydratesPer100g: aiResult['carbs_per_100g']?.toDouble(),
      proteinPer100g: aiResult['protein_per_100g']?.toDouble(),
      fatPer100g: aiResult['fat_per_100g']?.toDouble(),
      imageUrl: aiResult['image_url'],
      alternativeNames: List<String>.from(aiResult['alternative_names'] ?? []),
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Food{name: $name, category: $category, sugar: ${sugarContentPer100g}g/100g, calories: ${caloriesPer100g}/100g}';
  }
}
