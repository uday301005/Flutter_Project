class AppConfig {
  const AppConfig({
    required this.appName,
    required this.tagline,
    required this.demoMode,
    required this.environment,
    required this.googleMapsApiKey,
    required this.aiEndpoint,
  });

  factory AppConfig.fromEnvironment() {
    return AppConfig(
      appName: defaultAppName,
      tagline: defaultTagline,
      demoMode: const bool.fromEnvironment('DEMO_MODE', defaultValue: true),
      environment: const String.fromEnvironment(
        'APP_ENVIRONMENT',
        defaultValue: 'development',
      ),
      googleMapsApiKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY'),
      aiEndpoint: const String.fromEnvironment('AI_ENDPOINT'),
    );
  }

  static const defaultAppName = 'SwachhSetu';
  static const defaultTagline = 'Smarter Waste. Cleaner Communities.';

  final String appName;
  final String tagline;
  final bool demoMode;
  final String environment;
  final String googleMapsApiKey;
  final String aiEndpoint;

  bool get isProduction => environment == 'production';
  bool get hasGoogleMapsKey => googleMapsApiKey.trim().isNotEmpty;
  bool get hasAiEndpoint => aiEndpoint.trim().isNotEmpty;
}
