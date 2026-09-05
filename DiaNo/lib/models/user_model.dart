class User {
  final String id;
  final String email;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final double weight; // in kg
  final double height; // in cm
  final double dailySugarLimit; // in grams
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.weight,
    required this.height,
    required this.dailySugarLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  // Calculate BMI
  double get bmi => weight / ((height / 100) * (height / 100));

  // Calculate age
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'weight': weight,
      'height': height,
      'dailySugarLimit': dailySugarLimit,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth']),
      gender: map['gender'] ?? '',
      weight: (map['weight'] ?? 0.0).toDouble(),
      height: (map['height'] ?? 0.0).toDouble(),
      dailySugarLimit: (map['dailySugarLimit'] ?? 25.0).toDouble(), // WHO recommendation: 25g/day
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? email,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    double? weight,
    double? height,
    double? dailySugarLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      dailySugarLimit: dailySugarLimit ?? this.dailySugarLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, name: $name, age: $age, bmi: ${bmi.toStringAsFixed(1)}}';
  }
}
