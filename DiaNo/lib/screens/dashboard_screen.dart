import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/sugar_tracker_provider.dart';
import '../providers/notification_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/food_item_card.dart';
import '../widgets/sugar_meter_widget.dart';
import '../widgets/recommendation_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sugarProvider = Provider.of<SugarTrackerProvider>(context, listen: false);
      sugarProvider.loadTodayFoodItems();
      sugarProvider.loadWeeklyFoodItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final sugarProvider = Provider.of<SugarTrackerProvider>(context, listen: false);
            await sugarProvider.loadTodayFoodItems();
            await sugarProvider.loadWeeklyFoodItems();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),
                const SizedBox(height: 20),

                // Sugar Meter
                _buildSugarMeter(),
                const SizedBox(height: 20),

                // Quick Stats
                _buildQuickStats(),
                const SizedBox(height: 20),

                // Weekly Chart
                _buildWeeklyChart(),
                const SizedBox(height: 20),

                // Today's Food Items
                _buildTodayFoodItems(),
                const SizedBox(height: 20),

                // Recommendations
                _buildRecommendations(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userName = authProvider.user?.displayName ?? 'User';
        final currentHour = DateTime.now().hour;
        String greeting;
        
        if (currentHour < 12) {
          greeting = 'Good Morning';
        } else if (currentHour < 17) {
          greeting = 'Good Afternoon';
        } else {
          greeting = 'Good Evening';
        }

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting,',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF2E7D32),
                size: 24,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSugarMeter() {
    return Consumer<SugarTrackerProvider>(
      builder: (context, sugarProvider, child) {
        return SugarMeterWidget(
          currentIntake: sugarProvider.todaySugarIntake,
          dailyLimit: sugarProvider.dailySugarLimit,
          remainingSugar: sugarProvider.remainingSugar,
          progress: sugarProvider.sugarProgress,
        );
      },
    );
  }

  Widget _buildQuickStats() {
    return Consumer<SugarTrackerProvider>(
      builder: (context, sugarProvider, child) {
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Today\'s Intake',
                '${sugarProvider.todaySugarIntake.toStringAsFixed(1)}g',
                Icons.local_drink,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Calories',
                sugarProvider.todayCalories.toStringAsFixed(0),
                Icons.whatshot,
                const Color(0xFFFF9800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Food Items',
                '${sugarProvider.todayFoodItems.length}',
                Icons.restaurant,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Consumer<SugarTrackerProvider>(
      builder: (context, sugarProvider, child) {
        final weeklyData = sugarProvider.getWeeklySugarData();
        
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
              const Text(
                'Weekly Sugar Intake',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 30,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const style = TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            );
                            Widget text;
                            switch (value.toInt()) {
                              case 0:
                                text = const Text('Mon', style: style);
                                break;
                              case 1:
                                text = const Text('Tue', style: style);
                                break;
                              case 2:
                                text = const Text('Wed', style: style);
                                break;
                              case 3:
                                text = const Text('Thu', style: style);
                                break;
                              case 4:
                                text = const Text('Fri', style: style);
                                break;
                              case 5:
                                text = const Text('Sat', style: style);
                                break;
                              case 6:
                                text = const Text('Sun', style: style);
                                break;
                              default:
                                text = const Text('', style: style);
                                break;
                            }
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 16,
                              child: text,
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: weeklyData.entries.map((entry) {
                      final index = weeklyData.keys.toList().indexOf(entry.key);
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value,
                            color: entry.value > sugarProvider.dailySugarLimit
                                ? Colors.red
                                : const Color(0xFF4CAF50),
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodayFoodItems() {
    return Consumer<SugarTrackerProvider>(
      builder: (context, sugarProvider, child) {
        if (sugarProvider.todayFoodItems.isEmpty) {
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
              children: [
                const Icon(
                  Icons.restaurant_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No food items today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Start tracking your meals by scanning food items',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Food Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 12),
            ...sugarProvider.todayFoodItems.take(3).map((foodItem) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FoodItemCard(
                  foodItem: foodItem,
                  onDelete: () {
                    sugarProvider.deleteFoodItem(foodItem.id);
                  },
                ),
              );
            }),
            if (sugarProvider.todayFoodItems.length > 3)
              TextButton(
                onPressed: () {
                  // Navigate to full history
                },
                child: const Text('View All'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecommendations() {
    return Consumer<SugarTrackerProvider>(
      builder: (context, sugarProvider, child) {
        return RecommendationCard(
          currentIntake: sugarProvider.todaySugarIntake,
          dailyLimit: sugarProvider.dailySugarLimit,
        );
      },
    );
  }
}
