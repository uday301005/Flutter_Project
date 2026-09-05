import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sugar_tracker_provider.dart';
import '../widgets/food_item_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'Today';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sugarProvider = Provider.of<SugarTrackerProvider>(context, listen: false);
      sugarProvider.loadWeeklyFoodItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Food History',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFilterChips(),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Consumer<SugarTrackerProvider>(
                builder: (context, sugarProvider, child) {
                  if (sugarProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                      ),
                    );
                  }

                  final filteredItems = _getFilteredItems(sugarProvider);
                  
                  if (filteredItems.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await sugarProvider.loadWeeklyFoodItems();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final foodItem = filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: FoodItemCard(
                            foodItem: foodItem,
                            onDelete: () {
                              sugarProvider.deleteFoodItem(foodItem.id);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Today', 'Yesterday', 'This Week', 'All Time'];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
              checkmarkColor: const Color(0xFF2E7D32),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<FoodItem> _getFilteredItems(SugarTrackerProvider sugarProvider) {
    final now = DateTime.now();
    
    switch (_selectedFilter) {
      case 'Today':
        return sugarProvider.todayFoodItems;
      case 'Yesterday':
        final yesterday = now.subtract(const Duration(days: 1));
        return sugarProvider.getFoodItemsForDate(yesterday);
      case 'This Week':
        return sugarProvider.weeklyFoodItems;
      case 'All Time':
        return sugarProvider.weeklyFoodItems; // In a real app, this would load all items
      default:
        return [];
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.history,
              size: 60,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No food items found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your meals to see your history here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
