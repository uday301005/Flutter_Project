import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FoodItem {
  final String id;
  final String name;
  final double sugarContent;
  final double calories;
  final String imageUrl;
  final DateTime timestamp;
  final String category;

  FoodItem({
    required this.id,
    required this.name,
    required this.sugarContent,
    required this.calories,
    required this.imageUrl,
    required this.timestamp,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sugarContent': sugarContent,
    'calories': calories,
    'imageUrl': imageUrl,
    'timestamp': timestamp.toIso8601String(),
    'category': category,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'],
    name: json['name'],
    sugarContent: json['sugarContent'].toDouble(),
    calories: json['calories'].toDouble(),
    imageUrl: json['imageUrl'],
    timestamp: DateTime.parse(json['timestamp']),
    category: json['category'],
  );
}

class SugarTrackerProvider with ChangeNotifier {
  List<FoodItem> _todayFoodItems = [];
  List<FoodItem> _weeklyFoodItems = [];
  double _dailySugarLimit = 25.0;
  bool _isLoading = false;
  String? _errorMessage;

  List<FoodItem> get todayFoodItems => _todayFoodItems;
  List<FoodItem> get weeklyFoodItems => _weeklyFoodItems;
  double get dailySugarLimit => _dailySugarLimit;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get todaySugarIntake {
    final today = DateTime.now();
    return _todayFoodItems
        .where((item) => _isSameDay(item.timestamp, today))
        .fold(0.0, (sum, item) => sum + item.sugarContent);
  }

  double get todayCalories {
    final today = DateTime.now();
    return _todayFoodItems
        .where((item) => _isSameDay(item.timestamp, today))
        .fold(0.0, (sum, item) => sum + item.calories);
  }

  double get remainingSugar => _dailySugarLimit - todaySugarIntake;
  double get sugarProgress => todaySugarIntake / _dailySugarLimit;

  SugarTrackerProvider() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await loadTodayFoodItems();
    await loadWeeklyFoodItems();
    await loadDailySugarLimit();
  }

  Future<void> loadTodayFoodItems() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load from SharedPreferences for demo
      final prefs = await SharedPreferences.getInstance();
      final todayItemsJson = prefs.getString('today_food_items') ?? '[]';
      final List<dynamic> todayItemsList = json.decode(todayItemsJson);
      
      _todayFoodItems = todayItemsList
          .map((item) => FoodItem.fromJson(item))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load food items';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadWeeklyFoodItems() async {
    try {
      // Load from SharedPreferences for demo
      final prefs = await SharedPreferences.getInstance();
      final weeklyItemsJson = prefs.getString('weekly_food_items') ?? '[]';
      final List<dynamic> weeklyItemsList = json.decode(weeklyItemsJson);
      
      _weeklyFoodItems = weeklyItemsList
          .map((item) => FoodItem.fromJson(item))
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load weekly data';
      notifyListeners();
    }
  }

  Future<void> loadDailySugarLimit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _dailySugarLimit = prefs.getDouble('daily_sugar_limit') ?? 25.0;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load sugar limit';
      notifyListeners();
    }
  }

  Future<void> addFoodItem(FoodItem foodItem) async {
    try {
      _isLoading = true;
      notifyListeners();

      _todayFoodItems.insert(0, foodItem);
      _weeklyFoodItems.insert(0, foodItem);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('today_food_items', json.encode(_todayFoodItems.map((item) => item.toJson()).toList()));
      await prefs.setString('weekly_food_items', json.encode(_weeklyFoodItems.map((item) => item.toJson()).toList()));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add food item';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDailySugarLimit(double newLimit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('daily_sugar_limit', newLimit);
      
      _dailySugarLimit = newLimit;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update sugar limit';
      notifyListeners();
    }
  }

  Future<void> deleteFoodItem(String foodItemId) async {
    try {
      _todayFoodItems.removeWhere((item) => item.id == foodItemId);
      _weeklyFoodItems.removeWhere((item) => item.id == foodItemId);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('today_food_items', json.encode(_todayFoodItems.map((item) => item.toJson()).toList()));
      await prefs.setString('weekly_food_items', json.encode(_weeklyFoodItems.map((item) => item.toJson()).toList()));

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete food item';
      notifyListeners();
    }
  }

  List<FoodItem> getFoodItemsForDate(DateTime date) {
    return _weeklyFoodItems
        .where((item) => _isSameDay(item.timestamp, date))
        .toList();
  }

  double getSugarIntakeForDate(DateTime date) {
    return getFoodItemsForDate(date)
        .fold(0.0, (sum, item) => sum + item.sugarContent);
  }

  Map<String, double> getWeeklySugarData() {
    final now = DateTime.now();
    final Map<String, double> weeklyData = {};
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dayName = _getDayName(date.weekday);
      weeklyData[dayName] = getSugarIntakeForDate(date);
    }
    
    return weeklyData;
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
