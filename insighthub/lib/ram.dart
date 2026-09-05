import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Ram(),
    );
  }
}

class Ram extends StatefulWidget {
  const Ram({super.key});

  @override
  State<Ram> createState() => _RamState();
}

class _RamState extends State<Ram> {
  String qrText = "Scan a QR code";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        backgroundColor: Colors.blue,
        title: Text("InSightHub", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Scanner camera view
          Expanded(
            flex: 4,
            child: MobileScanner(
              fit: BoxFit.cover,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    qrText = barcode.rawValue ?? "No data found";
                  });
                }
              },
            ),
          ),

          // 🔹 Show scanned result
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Result: $qrText",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
