import 'dart:convert';
import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:http/http.dart' as http;
import 'package:smartopia_hms_server/logger.dart';

import 'ai_config_service.dart';

/// Service to handle AI task extraction using OpenAI and Gemini
/// Updated to use OpenAI Responses API with StructuredOutputs
class AiService {
  static bool _isInitialized = false;

  /// Initialize AI service
  static Future<bool> init() async {
    if (_isInitialized) return true;
    final config = await AiConfigService().getConfig();
    if (config == null) {
      logInfo(
          'AI configuration not found. Please configure AI settings first.');
      return false;
    }
    if (config.provider.toLowerCase() == 'openai') {
      if (config.openaiApiKey == null || config.openaiApiKey!.isEmpty) {
        logInfo(
            'OpenAI API key not configured. Please configure AI settings first.');
        return false;
      }
      OpenAI.apiKey = config.openaiApiKey!;
      OpenAI.showLogs = true;
    } else if (config.provider.toLowerCase() == 'gemini') {
      if (config.geminiApiKey == null || config.geminiApiKey!.isEmpty) {
        logInfo(
            'Gemini API key not configured. Please configure AI settings first.');
        return false;
      }
      // TODO: implement Gemini
    }
    _isInitialized = true;
    return true;
  }

  /// Upload PDF to OpenAI and return file ID
  Future<String?> _uploadPdfAndGetFileId(String pdfPath,
      [String purpose = 'user_data']) async {
    try {
      await init();
      final file = await OpenAI.instance.file.upload(
        file: File(pdfPath),
        purpose: purpose,
      );

      return file.id;
    } catch (e, st) {
      logError('Failed to upload PDF to OpenAI: $e', e, st);
      return null;
    }
  }

  static const String _defaultOpenAIModel = 'gpt-5.2';
  static const String _defaultSTTModel = 'whisper-1';

  static const String _defaultSystemPrompt = '''
You are a task extraction assistant. Analyze the provided content (images, PDFs, or transcribed text) and extract actionable tasks.

Extract each task with the following fields:
- title: A clear, concise task title (required)
- description: Detailed description of what needs to be done (optional)
- priority: Integer from 1-5, where 5 is highest priority (default: 3)
- expectedCompletionTimeInMinutes: Estimated time in minutes (default: 30)
- rewards: Object with maxPoints (integer, optional)
- penalty: String describing penalty for not completing (optional)
- startDateTime: String in ISO 8601 format (optional)
- endDateTime: String in ISO 8601 format (optional)

Try to deduce the absolute date and time of the task with reference to the current date and time. For example, if the current date is 2025-12-14 and the task is scheduled on Friday, the due date should be 2025-12-19.

Only extract tasks that are explicitly stated or clearly implied as actionable items in the provided content.

If the content contains NO actionable tasks, return:
{"has_tasks": false, "tasks": []}

Do NOT create, invent, assume, or infer tasks that are not present.
Do NOT rewrite general information as a task.

Return tasks as a structured JSON array.
''';

  /// JSON Schema for structured output
  static final Map<String, dynamic> taskSchema = {
    'type': 'object',
    'properties': {
      'has_tasks': {'type': 'boolean'},
      'tasks': {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {
            'title': {'type': 'string'},
            'description': {'type': 'string'},
            'priority': {'type': 'integer', 'minimum': 1, 'maximum': 5},
            'expectedCompletionTimeInMinutes': {
              'type': 'integer',
              'minimum': 1
            },
            'rewards': {
              'type': 'object',
              'properties': {
                'maxPoints': {'type': 'integer'}
              },
              'additionalProperties': false // ✅ REQUIRED in strict mode
            },
            'penalty': {'type': 'string'},
            'startDateTime': {'type': 'string', 'format': 'date-time'},
            'endDateTime': {'type': 'string', 'format': 'date-time'}
          },
          'required': ['title'],
          'additionalProperties': false
        }
      }
    },
    'required': ['has_tasks', 'tasks'],
    'additionalProperties': false
  };

  /// Extracts tasks from a PDF file using OpenAI's Responses API
  /// Return [] if no tasks are extracted
  /// Return null if failed to extract tasks
  Future<List<Map<String, dynamic>>?> extractTasksFromPdf({
    required String fileId,
    required Map<String, dynamic> taskSchema,
  }) async {
    try {
      await init();
      final config = await aiConfigService.getConfig();
      final input = [
        {
          'role': 'user',
          'content': [
            {'type': 'input_file', 'file_id': fileId},
            {
              'type': 'input_text',
              'text': config?.systemPrompt ?? _defaultSystemPrompt,
            }
          ]
        }
      ];

      final response = await OpenAI.instance.responses.create(
        model: config?.model ?? _defaultOpenAIModel,
        input: input,
        // dart_openai passes extra fields through for Responses.
        // If your version’s method signature is strict, see the note below.
        text: {
          'format': {
            'type': 'json_schema',
            'name': 'task_extraction',
            'schema': taskSchema,
            'strict': false
          }
        },
        maxOutputTokens: 2000,
      ); // :contentReference[oaicite:3]{index=3}

      // The package typically exposes something like outputText / toJson().
      // Safest is to convert to JSON-map and then read output_text.
      // Extract the output_text chunk (same approach you used before)
      final outputs = (response.output as List).cast<Map<String, dynamic>>();
      final msg = outputs.firstWhere((o) => o['type'] == 'message');
      final content = (msg['content'] as List).cast<Map<String, dynamic>>();

      final textChunk = content.firstWhere(
        (c) => c['type'] == 'output_text',
        orElse: () => {},
      );

      final rawText = textChunk['text'];
      if (rawText == null) return [];

      return _extractTasksRawJsonText(rawText);
    } catch (e, st) {
      logError('Failed to extract tasks from PDF: $e\n$st');
      return null;
    } finally {
      try {
        await OpenAI.instance.file.delete(fileId);
      } catch (e, st) {
        logError('Failed to delete file: $e\n$st');
      }
    }
  }

  Future<List<Map<String, dynamic>>?> _extractTasksRawJsonText(
      dynamic rawText) async {
    // 3) Parse JSON (sometimes SDKs already give Map, so handle both)
    if (rawText is String) {
      File('data/test_tasks_raw_text.json').writeAsStringSync(rawText);
    }
    final decoded = rawText is String
        ? (jsonDecode(rawText) as Map<String, dynamic>)
        : (rawText as Map).cast<String, dynamic>();

    // 4) Return tasks as List<Map<String,dynamic>>
    final tasks = (decoded['tasks'] as List?) ?? const [];

    return tasks.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  /// Extracts tasks from media files using configured AI provider
  Future<List<Map<String, dynamic>>?> extractTasks({
    List<File>? images,
    File? voice,
    File? pdf,
  }) async {
    await init();
    if (pdf != null) {
      final fileId = await _uploadPdfAndGetFileId(pdf.path);
      if (fileId == null) return null;
      return extractTasksFromPdf(fileId: fileId, taskSchema: taskSchema);
    }
    if (voice != null) {
      return extractTasksFromVoice(voice);
    }
    if (images != null) {}

    return null;
  }

  Future<List<Map<String, dynamic>>?> extractTasksFromVoice(File voice) async {
    try {
      // for testing
      if (File('data/test_tasks_raw_text.json').existsSync()) {
        return _extractTasksRawJsonText(
            File('data/test_tasks_raw_text.json').readAsStringSync());
      }

      final transcription = await OpenAI.instance.audio.createTranscription(
        model: _defaultSTTModel,
        file: voice,
      );
      // Handling different transcription response formats
      late String text;
      if (transcription is OpenAITranscriptionModel) {
        text = transcription.text;
      } else if (transcription is OpenAITranscriptionVerboseModel) {
        text = transcription.text;
      }

      return extractTasksFromText(text);
    } catch (e, st) {
      logError('Failed to extract tasks from voice: $e\n$st');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> extractTasksFromText(String text) async {
    try {
      await init();
      final config = await aiConfigService.getConfig();
      final input = [
        {
          'role': 'user',
          'content': [
            {'type': 'input_text', 'text': text},
            {
              'type': 'input_text',
              'text': config?.systemPrompt ?? _defaultSystemPrompt,
            }
          ]
        }
      ];

      final response = await OpenAI.instance.responses.create(
        model: config?.model ?? _defaultOpenAIModel,
        input: input,
        // dart_openai passes extra fields through for Responses.
        // If your version’s method signature is strict, see the note below.
        text: {
          'format': {
            'type': 'json_schema',
            'name': 'task_extraction',
            'schema': taskSchema,
            'strict': false
          }
        },
        maxOutputTokens: 2000,
      ); // :contentReference[oaicite:3]{index=3}

      // The package typically exposes something like outputText / toJson().
      // Safest is to convert to JSON-map and then read output_text.
      // Extract the output_text chunk (same approach you used before)
      final outputs = (response.output as List).cast<Map<String, dynamic>>();
      final msg = outputs.firstWhere((o) => o['type'] == 'message');
      final content = (msg['content'] as List).cast<Map<String, dynamic>>();

      final textChunk = content.firstWhere(
        (c) => c['type'] == 'output_text',
        orElse: () => {},
      );

      final rawText = textChunk['text'];
      if (rawText == null) return [];

      return _extractTasksRawJsonText(rawText);
    } catch (e, st) {
      logError('Failed to extract tasks from text: $e\n$st');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> extractTasksFromImages(
      List<File> images) async {}

  /// Transcribe audio using OpenAI Whisper
  Future<String> _transcribeWithWhisper(String apiKey, File audioFile) async {
    final url = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = 'whisper-1'
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
          'Whisper API error: ${response.statusCode} - ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse['text'] as String;
  }

  /// Parse tasks from AI response (fallback for non-structured outputs)
  List<Map<String, dynamic>> _parseTasksFromResponse(String response) {
    try {
      // Try to parse as direct JSON first
      final parsed = jsonDecode(response);

      if (parsed is Map && parsed.containsKey('tasks')) {
        return (parsed['tasks'] as List).cast<Map<String, dynamic>>();
      }

      if (parsed is List) {
        return parsed.cast<Map<String, dynamic>>();
      }

      // Try to find JSON array in the response
      final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response);
      if (jsonMatch == null) {
        print('No JSON array found in response: $response');
        return [];
      }

      final jsonStr = jsonMatch.group(0)!;
      final arrayParsed = jsonDecode(jsonStr);

      if (arrayParsed is List) {
        return arrayParsed.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
      print('Error parsing AI response: $e');
      print('Response was: $response');
      return [];
    }
  }
}

/// Singleton instance of AiService
final aiService = AiService();
