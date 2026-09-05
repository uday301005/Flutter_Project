import 'sugar_intake_model.dart';

class DailyRecord {
  final String id;
  final String userId;
  final DateTime date;
  final double totalSugarConsumed; // in grams
  final double totalCalories;
  final double dailySugarLimit; // in grams
  final List<SugarIntake> intakes;
  final Map<String, double> sugarByMealType; // breakfast, lunch, dinner, snack
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalSugarConsumed,
    required this.totalCalories,
    required this.dailySugarLimit,
    required this.intakes,
    required this.sugarByMealType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create from list of sugar intakes
  factory DailyRecord.fromIntakes({
    required String id,
    required String userId,
    required DateTime date,
    required double dailySugarLimit,
    required List<SugarIntake> intakes,
  }) {
    double totalSugar = 0;
    double totalCalories = 0;
    Map<String, double> mealTypeSugar = {
      'Breakfast': 0,
      'Lunch': 0,
      'Dinner': 0,
      'Snack': 0,
    };

    for (var intake in intakes) {
      totalSugar += intake.sugarAmount;
      totalCalories += intake.calories;
      mealTypeSugar[intake.mealType] = 
          (mealTypeSugar[intake.mealType] ?? 0) + intake.sugarAmount;
    }

    return DailyRecord(
      id: id,
      userId: userId,
      date: date,
      totalSugarConsumed: totalSugar,
      totalCalories: totalCalories,
      dailySugarLimit: dailySugarLimit,
      intakes: intakes,
      sugarByMealType: mealTypeSugar,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Calculate percentage of daily limit consumed
  double get sugarPercentage => (totalSugarConsumed / dailySugarLimit) * 100;

  // Get remaining sugar allowance
  double get remainingSugar => dailySugarLimit - totalSugarConsumed;

  // Check if user exceeded daily limit
  bool get isOverLimit => totalSugarConsumed > dailySugarLimit;

  // Get risk status
  String get riskStatus {
    final percentage = sugarPercentage;
    if (percentage >= 100) return 'Exceeded';
    if (percentage >= 80) return 'Warning';
    if (percentage >= 60) return 'Caution';
    return 'Safe';
  }

  // Get the meal with highest sugar consumption
  String get highestSugarMeal {
    return sugarByMealType.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // Get intake count by meal type
  Map<String, int> get intakeCountByMeal {
    Map<String, int> count = {
      'Breakfast': 0,
      'Lunch': 0,
      'Dinner': 0,
      'Snack': 0,
    };

    for (var intake in intakes) {
      count[intake.mealType] = (count[intake.mealType] ?? 0) + 1;
    }

    return count;
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'totalSugarConsumed': totalSugarConsumed,
      'totalCalories': totalCalories,
      'dailySugarLimit': dailySugarLimit,
      'intakes': intakes.map((intake) => intake.toMap()).toList(),
      'sugarByMealType': sugarByMealType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory DailyRecord.fromMap(Map<String, dynamic> map) {
    return DailyRecord(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      date: DateTime.parse(map['date']),
      totalSugarConsumed: (map['totalSugarConsumed'] ?? 0.0).toDouble(),
      totalCalories: (map['totalCalories'] ?? 0.0).toDouble(),
      dailySugarLimit: (map['dailySugarLimit'] ?? 25.0).toDouble(),
      intakes: (map['intakes'] as List<dynamic>)
          .map((intake) => SugarIntake.fromMap(intake))
          .toList(),
      sugarByMealType: Map<String, double>.from(map['sugarByMealType'] ?? {}),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy with updated fields
  DailyRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? totalSugarConsumed,
    double? totalCalories,
    double? dailySugarLimit,
    List<SugarIntake>? intakes,
    Map<String, double>? sugarByMealType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DailyRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      totalSugarConsumed: totalSugarConsumed ?? this.totalSugarConsumed,
      totalCalories: totalCalories ?? this.totalCalories,
      dailySugarLimit: dailySugarLimit ?? this.dailySugarLimit,
      intakes: intakes ?? this.intakes,
      sugarByMealType: sugarByMealType ?? this.sugarByMealType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'DailyRecord{date: $date, sugar: ${totalSugarConsumed}g/${dailySugarLimit}g, status: $riskStatus}';
  }
}
