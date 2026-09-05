import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
// Mobile webview
import 'package:webview_flutter/webview_flutter.dart';
// Windows webview
import 'package:webview_windows/webview_windows.dart';

class RecipeView extends StatefulWidget {
  final String url;
  const RecipeView({Key? key, required this.url}) : super(key: key);

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  // For Windows
  final webviewController = WebviewController();
  bool isWindowsWebViewReady = false;

  // For mobile
  late WebViewController mobileController;
  late String finalUrl;

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      webviewController.initialize().then((_) {
        setState(() {
          isWindowsWebViewReady = true;
        });
        webviewController.loadUrl(widget.url);
      });
    } else {
      if (widget.url.toString().contains("http://")) {
        finalUrl = widget.url.toString().replaceAll("http://", "https://");
      } else {
        finalUrl = widget.url;
      }
      mobileController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(finalUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile: Use webview_flutter
      return Scaffold(
        appBar: AppBar(title: Text("Recipe")),
        body: WebViewWidget(controller: mobileController),
      );
    } else if (Platform.isWindows) {
      // Windows: Use webview_windows
      return Scaffold(
        appBar: AppBar(title: Text("Recipe")),
        body: isWindowsWebViewReady
            ? Webview(webviewController)
            : Center(child: CircularProgressIndicator()),
      );
    } else {
      // Fallback for unsupported platforms
      return Scaffold(
        appBar: AppBar(title: Text("Recipe")),
        body: Center(child: Text("WebView not supported on this platform.")),
      );
    }
  }
}

