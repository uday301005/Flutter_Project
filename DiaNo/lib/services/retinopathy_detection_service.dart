import 'dart:io';
import 'dart:math' show max;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class RetinopathyDetectionResult {
  final String classification;
  final double confidence;
  final Map<String, double> allProbabilities;

  RetinopathyDetectionResult({
    required this.classification,
    required this.confidence,
    required this.allProbabilities,
  });

  String get severity {
    switch (classification) {
      case 'No DR':
        return 'Normal - No Diabetic Retinopathy detected';
      case 'Mild DR':
        return 'Early stage - Mild Diabetic Retinopathy';
      case 'Moderate DR':
        return 'Intermediate stage - Moderate Diabetic Retinopathy';
      case 'Severe DR':
        return 'Advanced stage - Severe Diabetic Retinopathy';
      case 'Proliferative DR':
        return 'Critical stage - Proliferative Diabetic Retinopathy';
      default:
        return 'Unknown classification';
    }
  }

  String get recommendation {
    switch (classification) {
      case 'No DR':
        return 'Continue regular check-ups every 12 months';
      case 'Mild DR':
        return 'Schedule a follow-up within 6-8 months';
      case 'Moderate DR':
        return 'Consult an eye specialist within 3 months';
      case 'Severe DR':
        return 'Urgent: See an eye specialist within 1 month';
      case 'Proliferative DR':
        return 'Emergency: Immediate medical attention required';
      default:
        return 'Please consult a healthcare professional';
    }
  }
}

class RetinopathyDetectionService {
  static const String modelPath = 'assets/models/retinopathy_model.tflite';
  static const List<String> labels = [
    'No DR',
    'Mild DR',
    'Moderate DR',
    'Severe DR',
    'Proliferative DR'
  ];

  Interpreter? _interpreter;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final interpreterOptions = InterpreterOptions()..threads = 4;
      _interpreter = await Interpreter.fromAsset(modelPath, options: interpreterOptions);
      _isInitialized = true;
      print('TFLite model loaded successfully');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  final Dio _dio = Dio();
  static const String _baseUrl = 'http://127.0.0.1:8000/api';

  Future<RetinopathyDetectionResult> detectRetinopathy(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Load and preprocess the image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Failed to load image');
      
      // Resize to 224x224 as required by the model
      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // Prepare nested input list with shape [1,224,224,3]
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (_) => List.generate(
            224,
            (_) => List<double>.filled(3, 0.0),
          ),
        ),
      );

      // Fill input with normalized pixel values
      for (var y = 0; y < resizedImage.height; y++) {
        for (var x = 0; x < resizedImage.width; x++) {
          final dynamic pixel = resizedImage.getPixel(x, y);
          int ri, gi, bi;
          if (pixel is int) {
            ri = (pixel >> 16) & 0xFF;
            gi = (pixel >> 8) & 0xFF;
            bi = pixel & 0xFF;
          } else {
            // Pixel may be an object with r,g,b fields in newer image package
            ri = (pixel.r as int);
            gi = (pixel.g as int);
            bi = (pixel.b as int);
          }
          final r = ri.toDouble();
          final g = gi.toDouble();
          final b = bi.toDouble();
          input[0][y][x][0] = (r / 127.5) - 1.0;
          input[0][y][x][1] = (g / 127.5) - 1.0;
          input[0][y][x][2] = (b / 127.5) - 1.0;
        }
      }

      // Prepare output tensor
      var outputs = List<List<double>>.filled(1, List<double>.filled(labels.length, 0));

      // Run inference
      _interpreter!.run(input, outputs);
      
      // Process results
      final probabilities = outputs[0];
      final maxProb = probabilities.reduce(max);
      final classIndex = probabilities.indexOf(maxProb);
      
      // Create probability map
      final Map<String, double> probabilityMap = {};
      for (int i = 0; i < labels.length; i++) {
        probabilityMap[labels[i]] = probabilities[i];
      }

      return RetinopathyDetectionResult(
        classification: labels[classIndex],
        confidence: maxProb * 100,
        allProbabilities: probabilityMap,
      );
    } catch (e) {
      print('Error during detection: $e');
      rethrow;
    }
  }

  void dispose() {
    _interpreter?.close();
  }

  // Local wrapper that delegates to the main detector
  Future<RetinopathyDetectionResult> detectLocalRetinopathy(File imageFile) async {
    return await detectRetinopathy(imageFile);
  }

  // Process image using remote API
  Future<RetinopathyDetectionResult> detectRemoteRetinopathy(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dio.post(
        '$_baseUrl/detect-retinopathy',
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return RetinopathyDetectionResult(
          classification: data['classification'],
          confidence: data['confidence'],
          allProbabilities: Map<String, double>.from(data['probabilities']),
        );
      } else {
        throw Exception('Failed to process image');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}