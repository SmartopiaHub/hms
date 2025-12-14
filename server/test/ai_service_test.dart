import 'dart:io';
import 'package:smartopia_hms_server/services/ai_service.dart';
import 'package:smartopia_hms_server/services/ai_config_service.dart';

/// Test suite for AI service integration
///
/// To run these tests:
/// 1. Set your API keys in the config
/// 2. Run: dart test/ai_service_test.dart
void main() async {
  print('=== AI Service Integration Tests ===\n');

  // Test 1: Configuration
  await testConfiguration();

  // Test 2: OpenAI Whisper (audio transcription)
  // await testWhisperTranscription();

  // Test 3: OpenAI GPT-4 Vision (image analysis)
  // await testGPT4Vision();

  // Test 4: Google Gemini (multimodal)
  // await testGeminiMultimodal();

  // Test 5: Full extraction flow
  // await testFullExtraction();

  print('\\n=== All Tests Completed ===');
}

Future<void> testConfiguration() async {
  print('Test 1: Configuration Management');
  print('-----------------------------------');

  try {
    // Create test config
    final config = AiConfig(
      provider: 'openai',
      openaiApiKey: 'sk-test-key',
      model: 'gpt-4-vision-preview',
      systemPrompt: 'Custom prompt for testing',
    );

    // Save config
    await aiConfigService.saveConfig(config);
    print('✓ Config saved successfully');

    // Load config
    final loadedConfig = await aiConfigService.getConfig();
    if (loadedConfig != null) {
      print('✓ Config loaded successfully');
      print('  Provider: ${loadedConfig.provider}');
      print('  Has OpenAI Key: ${loadedConfig.openaiApiKey != null}');
      print('  Model: ${loadedConfig.model}');
    }

    print('✓ Configuration test passed\\n');
  } catch (e) {
    print('✗ Configuration test failed: $e\\n');
  }
}

Future<void> testWhisperTranscription() async {
  print('Test 2: OpenAI Whisper Transcription');
  print('----------------------------------------');

  try {
    // Ensure OpenAI config is set
    final config = await aiConfigService.getConfig();
    if (config == null || config.openaiApiKey == null) {
      print('⚠ Skipping: OpenAI API key not configured\\n');
      return;
    }

    // Create a small test audio file (you need to provide this)
    final testAudio = File('test/fixtures/test_audio.m4a');
    if (!await testAudio.exists()) {
      print('⚠ Skipping: test_audio.m4a not found\\n');
      return;
    }

    final tasks = await aiService.extractTasks(voice: testAudio);
    print('✓ Extracted ${tasks.length} tasks from audio');
    for (var i = 0; i < tasks.length; i++) {
      print('  Task ${i + 1}: ${tasks[i]['title']}');
    }
    print('✓ Whisper test passed\\n');
  } catch (e) {
    print('✗ Whisper test failed: $e\\n');
  }
}

Future<void> testGPT4Vision() async {
  print('Test 3: OpenAI GPT-4 Vision');
  print('-------------------------------');

  try {
    final config = await aiConfigService.getConfig();
    if (config == null || config.openaiApiKey == null) {
      print('⚠ Skipping: OpenAI API key not configured\\n');
      return;
    }

    // Test with a sample image (you need to provide this)
    final testImage = File('test/fixtures/test_todo_list.jpg');
    if (!await testImage.exists()) {
      print('⚠ Skipping: test_todo_list.jpg not found\\n');
      return;
    }

    final tasks = await aiService.extractTasks(images: [testImage]);
    print('✓ Extracted ${tasks.length} tasks from image');
    for (var i = 0; i < tasks.length; i++) {
      print('  Task ${i + 1}: ${tasks[i]['title']}');
    }
    print('✓ GPT-4 Vision test passed\\n');
  } catch (e) {
    print('✗ GPT-4 Vision test failed: $e\\n');
  }
}

Future<void> testGeminiMultimodal() async {
  print('Test 4: Google Gemini Multimodal');
  print('------------------------------------');

  try {
    // Switch to Gemini config
    await aiConfigService.saveConfig(AiConfig(
      provider: 'gemini',
      geminiApiKey: Platform.environment['GEMINI_API_KEY'],
    ));

    final config = await aiConfigService.getConfig();
    if (config == null || config.geminiApiKey == null) {
      print('⚠ Skipping: Gemini API key not configured\\n');
      return;
    }

    final testImage = File('test/fixtures/test_todo_list.jpg');
    if (!await testImage.exists()) {
      print('⚠ Skipping: test_todo_list.jpg not found\\n');
      return;
    }

    final tasks = await aiService.extractTasks(images: [testImage]);
    print('✓ Extracted ${tasks.length} tasks from image using Gemini');
    for (var i = 0; i < tasks.length; i++) {
      print('  Task ${i + 1}: ${tasks[i]['title']}');
    }
    print('✓ Gemini test passed\\n');
  } catch (e) {
    print('✗ Gemini test failed: $e\\n');
  }
}

Future<void> testFullExtraction() async {
  print('Test 5: Full Extraction Flow (Image + Audio)');
  print('-----------------------------------------------');

  try {
    final config = await aiConfigService.getConfig();
    if (config == null || config.openaiApiKey == null) {
      print('⚠ Skipping: OpenAI API key not configured\\n');
      return;
    }

    final testImage = File('test/fixtures/test_todo_list.jpg');
    final testAudio = File('test/fixtures/test_audio.m4a');

    if (!await testImage.exists() || !await testAudio.exists()) {
      print('⚠ Skipping: Test files not found\\n');
      return;
    }

    final tasks = await aiService.extractTasks(
      images: [testImage],
      voice: testAudio,
    );

    print('✓ Extracted ${tasks.length} tasks from combined media');
    for (var i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      print('  Task ${i + 1}:');
      print('    Title: ${task['title']}');
      print('    Description: ${task['description'] ?? 'N/A'}');
      print('    Priority: ${task['priority'] ?? 3}');
      print('    Time: ${task['expectedCompletionTimeInMinutes'] ?? 30} min');
      if (task['rewards'] != null) {
        print('    Rewards: ${task['rewards']['maxPoints']} points');
      }
    }
    print('✓ Full extraction test passed\\n');
  } catch (e) {
    print('✗ Full extraction test failed: $e\\n');
  }
}
