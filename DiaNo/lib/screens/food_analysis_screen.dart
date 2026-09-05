import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/sugar_tracker_provider.dart';
import '../providers/notification_provider.dart';
import '../services/ai_food_analysis_service.dart';
import '../widgets/food_analysis_result_widget.dart';

class FoodAnalysisScreen extends StatefulWidget {
  const FoodAnalysisScreen({super.key});

  @override
  State<FoodAnalysisScreen> createState() => _FoodAnalysisScreenState();
}

class _FoodAnalysisScreenState extends State<FoodAnalysisScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  File? _selectedImage;
  FoodAnalysisResult? _analysisResult;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null;
        });
        await _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await AIFoodAnalysisService.analyzeFoodImage(_selectedImage!);
      
      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });

      // Show notification
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      await notificationProvider.showFoodAnalysisResult(
        result.foodName,
        result.sugarContent,
      );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _addToTracker() async {
    if (_analysisResult == null) return;

    final sugarProvider = Provider.of<SugarTrackerProvider>(context, listen: false);
    
    final foodItem = FoodItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _analysisResult!.foodName,
      sugarContent: _analysisResult!.sugarContent,
      calories: _analysisResult!.calories,
      imageUrl: _selectedImage?.path ?? '',
      timestamp: DateTime.now(),
      category: _analysisResult!.category,
    );

    await sugarProvider.addFoodItem(foodItem);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food item added to tracker!'),
          backgroundColor: Colors.green,
        ),
      );

      // Check if we should show a warning
      final currentIntake = sugarProvider.todaySugarIntake + _analysisResult!.sugarContent;
      if (currentIntake > sugarProvider.dailySugarLimit * 0.8) {
        final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        await notificationProvider.showSugarLimitWarning(
          currentIntake,
          sugarProvider.dailySugarLimit,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Food Analysis',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Take a photo of your food to analyze sugar content',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Image Selection
              Expanded(
                child: _selectedImage == null
                    ? _buildImageSelection()
                    : _buildImageAnalysis(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Select an image to analyze',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a photo or choose from gallery',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                'Camera',
                Icons.camera_alt,
                () => _pickImage(ImageSource.camera),
              ),
              _buildActionButton(
                'Gallery',
                Icons.photo_library,
                () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageAnalysis() {
    return Column(
      children: [
        // Selected Image
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Analysis Result or Loading
        Expanded(
          child: _isAnalyzing
              ? _buildLoadingState()
              : _analysisResult != null
                  ? FoodAnalysisResultWidget(
                      result: _analysisResult!,
                      onAddToTracker: _addToTracker,
                      onRetake: () {
                        setState(() {
                          _selectedImage = null;
                          _analysisResult = null;
                        });
                      },
                    )
                  : Container(),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(32),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          const Text(
            'Analyzing your food...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Our AI is identifying the food and calculating sugar content',
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
}
