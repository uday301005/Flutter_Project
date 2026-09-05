import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/retinopathy_detection_service.dart';

class RetinopathyDetectionScreen extends StatefulWidget {
  const RetinopathyDetectionScreen({Key? key}) : super(key: key);

  @override
  _RetinopathyDetectionScreenState createState() => _RetinopathyDetectionScreenState();
}

class _RetinopathyDetectionScreenState extends State<RetinopathyDetectionScreen> {
  File? _selectedImage;
  bool _isProcessing = false;
  RetinopathyDetectionResult? _result;
  final _retinopathyService = RetinopathyDetectionService();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return; // user cancelled selection

      File? finalFile;

      // Try cropping, but fall back to original file if cropper returns null or throws
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 90,
        );

        if (croppedFile != null) {
          finalFile = File(croppedFile.path);
        } else {
          // Cropper returned null (user cancelled or unsupported). Use original image.
          finalFile = File(image.path);
        }
      } catch (e) {
        // Cropper threw an error (possible unsupported format on some devices). Log and use original.
        print('ImageCropper error: $e');
        finalFile = File(image.path);
      }

      if (finalFile != null) {
        setState(() {
          _selectedImage = finalFile;
          _result = null;
        });
        await _processImage();
      }
    } catch (e) {
      print('Image pick error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: ${e.toString()}')),
      );
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final result = await _retinopathyService.detectLocalRetinopathy(_selectedImage!);
      setState(() {
        _result = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Widget _buildResultsChart() {
    if (_result == null) return const SizedBox.shrink();

    final data = _result!.allProbabilities.entries.toList();
    data.sort((a, b) => b.value.compareTo(a.value));

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barGroups: data.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.value * 100,
                  color: Colors.blue,
                  width: 25,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data[index].key.split(' ')[0], // Show only first word
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retinopathy Detection'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.file(
                  _selectedImage!,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _pickImage,
              icon: const Icon(Icons.add_a_photo),
              label: Text(_isProcessing ? 'Processing...' : 'Select Eye Image'),
            ),
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              Text(
                'Detection Result:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _result!.classification,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Confidence: ${_result!.confidence.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Text(
                'Probability Distribution:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildResultsChart(),
            ],
          ],
        ),
      ),
    );
  }
}