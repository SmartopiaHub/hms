import 'dart:convert';
import 'dart:io';

/// Service to manage AI configuration settings
class AiConfigService {
  static const String _configFilePath = 'data/config/ai_config.json';

  AiConfig? _cachedConfig;

  /// Loads the AI configuration from file
  Future<AiConfig?> loadConfig() async {
    try {
      final file = File(_configFilePath);
      if (!await file.exists()) {
        return null;
      }

      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      _cachedConfig = AiConfig.fromJson(json);
      return _cachedConfig;
    } catch (e) {
      print('Error loading AI config: $e');
      return null;
    }
  }

  /// Saves the AI configuration to file
  Future<void> saveConfig(AiConfig config) async {
    try {
      final file = File(_configFilePath);
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(config.toJson()));
      _cachedConfig = config;
    } catch (e) {
      print('Error saving AI config: $e');
      rethrow;
    }
  }

  /// Gets the cached configuration or loads it
  Future<AiConfig?> getConfig() async {
    _cachedConfig ??= await loadConfig();
    return _cachedConfig;
  }

  /// Clears the cached configuration
  void clearCache() {
    _cachedConfig = null;
  }
}

/// AI Configuration model
class AiConfig {
  final String provider; // 'openai' or 'gemini'
  final String? openaiApiKey;
  final String? geminiApiKey;
  final String? model;
  final String? systemPrompt;

  AiConfig({
    required this.provider,
    this.openaiApiKey,
    this.geminiApiKey,
    this.model,
    this.systemPrompt,
  });

  factory AiConfig.fromJson(Map<String, dynamic> json) {
    return AiConfig(
      provider: json['provider'] as String? ?? 'openai',
      openaiApiKey: json['openaiApiKey'] as String?,
      geminiApiKey: json['geminiApiKey'] as String?,
      model: json['model'] as String?,
      systemPrompt: json['systemPrompt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider,
      if (openaiApiKey != null) 'openaiApiKey': openaiApiKey,
      if (geminiApiKey != null) 'geminiApiKey': geminiApiKey,
      if (model != null) 'model': model,
      if (systemPrompt != null) 'systemPrompt': systemPrompt,
    };
  }

  /// Creates a copy with updated fields
  AiConfig copyWith({
    String? provider,
    String? openaiApiKey,
    String? geminiApiKey,
    String? model,
    String? systemPrompt,
  }) {
    return AiConfig(
      provider: provider ?? this.provider,
      openaiApiKey: openaiApiKey ?? this.openaiApiKey,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
      model: model ?? this.model,
      systemPrompt: systemPrompt ?? this.systemPrompt,
    );
  }
}

final aiConfigService = AiConfigService();
