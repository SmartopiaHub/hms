import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'ai_config_service.dart';

/// Service to handle AI task extraction using OpenAI and Gemini
/// Updated to use OpenAI Responses API with StructuredOutputs
class AiService {
  static const String defaultSystemPrompt = '''
You are a task extraction assistant. Analyze the provided content (images, PDFs, or transcribed audio) and extract actionable tasks.

Extract each task with the following fields:
- title: A clear, concise task title (required)
- description: Detailed description of what needs to be done (optional)
- priority: Integer from 1-5, where 5 is highest priority (default: 3)
- expectedCompletionTimeInMinutes: Estimated time in minutes (default: 30)
- rewards: Object with maxPoints (integer, optional)
- penalty: String describing penalty for not completing (optional)

Return tasks as a structured JSON array.
''';

  /// JSON Schema for structured output
  static final Map<String, dynamic> taskSchema = {
    "type": "object",
    "properties": {
      "tasks": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "title": {"type": "string"},
            "description": {"type": "string"},
            "priority": {"type": "integer", "minimum": 1, "maximum": 5},
            "expectedCompletionTimeInMinutes": {
              "type": "integer",
              "minimum": 1
            },
            "rewards": {
              "type": "object",
              "properties": {
                "maxPoints": {"type": "integer"}
              },
              "additionalProperties": false // ✅ REQUIRED in strict mode
            },
            "penalty": {"type": "string"}
          },
          "required": ["title"],
          "additionalProperties": false
        }
      }
    },
    "required": ["tasks"],
    "additionalProperties": false
  };

  /// Extracts tasks from media files using configured AI provider
  Future<List<Map<String, dynamic>>> extractTasks({
    List<File>? images,
    File? voice,
    File? pdf,
  }) async {
    final config = await aiConfigService.getConfig();

    if (config == null) {
      throw Exception(
          'AI configuration not found. Please configure AI settings first.');
    }

    switch (config.provider.toLowerCase()) {
      case 'openai':
        return await _extractWithOpenAI(
          config,
          images: images,
          voice: voice,
          pdf: pdf,
        );
      case 'gemini':
        return await _extractWithGemini(
          config,
          images: images,
          voice: voice,
          pdf: pdf,
        );
      default:
        throw Exception('Unsupported AI provider: ${config.provider}');
    }
  }

  /// Extract tasks using OpenAI Responses API with Structured Outputs
  Future<List<Map<String, dynamic>>> _extractWithOpenAI(
    AiConfig config, {
    List<File>? images,
    File? voice,
    File? pdf,
  }) async {
    if (config.openaiApiKey == null || config.openaiApiKey!.isEmpty) {
      throw Exception('OpenAI API key not configured');
    }

    final List<String> textPrompts = [];

    // Process voice with Whisper
    if (voice != null) {
      final transcription =
          await _transcribeWithWhisper(config.openaiApiKey!, voice);
      textPrompts.add('Audio transcription: $transcription');
    }

    // Build content for Responses API
    final List<Map<String, dynamic>> content = [];

    // Add system prompt
    final prompt = textPrompts.isNotEmpty
        ? '${config.systemPrompt ?? defaultSystemPrompt}\n\nAdditional context: ${textPrompts.join('\n')}'
        : config.systemPrompt ?? defaultSystemPrompt;

    content.add({'type': 'input_text', 'text': prompt});

    // Add images as base64
    if (images != null && images.isNotEmpty) {
      for (final image in images) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        content.add({
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$base64Image',
          }
        });
      }
    }

    // Upload PDF using Files API and reference by ID
    String? fileId;
    if (pdf != null) {
      fileId = await _uploadFileToOpenAI(config.openaiApiKey!, pdf);
      content.add({
        'type': 'input_file',
        'file_id': fileId,
      });
    }

    try {
      // Use chat/completions (not responses) for vision with files
      final response = await _callChatCompletionsWithFiles(
        config.openaiApiKey!,
        content,
        model: config.model ?? 'gpt-5.2',
      );

      return response;
    } finally {
      // Clean up uploaded file
      if (fileId != null) {
        await _deleteFileFromOpenAI(config.openaiApiKey!, fileId);
      }
    }
  }

  /// Upload file to OpenAI Files API
  Future<String> _uploadFileToOpenAI(String apiKey, File file) async {
    final url = Uri.parse('https://api.openai.com/v1/files');

    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['purpose'] = 'assistants'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
          'OpenAI Files API error: ${response.statusCode} - ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return jsonResponse['id'] as String;
  }

  /// Delete file from OpenAI
  Future<void> _deleteFileFromOpenAI(String apiKey, String fileId) async {
    final url = Uri.parse('https://api.openai.com/v1/files/$fileId');

    try {
      await http.delete(
        url,
        headers: {'Authorization': 'Bearer $apiKey'},
      );
    } catch (e) {
      // Ignore deletion errors
      print('Failed to delete file $fileId: $e');
    }
  }

  /// Call OpenAI Chat Completions with file references and structured outputs
  Future<List<Map<String, dynamic>>> _callChatCompletionsWithFiles(
    String apiKey,
    List<Map<String, dynamic>> content, {
    String model = 'gpt-5.2',
  }) async {
    final url = Uri.parse('https://api.openai.com/v1/responses');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'input': [
          {'role': 'user', 'content': content}
        ],
        'text': {
          'format': {
            'type': 'json_schema',
            'name': 'task_extraction',
            'schema': taskSchema,
            'strict': false
          }
        },
        'max_output_tokens': 16384,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'OpenAI Chat Completions API error: ${response.statusCode} - ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    print(jsonResponse);
    File('data/response.json').writeAsStringSync(jsonEncode(jsonResponse));

    final tasks = _extractTasksFromResponsesApi(jsonResponse);

    return tasks.cast<Map<String, dynamic>>();
  }

  List<Map<String, dynamic>> _extractTasksFromResponsesApi(
      Map<String, dynamic> resp) {
    final output = (resp['output'] as List?) ?? const [];

    // 1) Find the first "message" output block
    final message = output.cast<Map>().firstWhere(
          (o) => o['type'] == 'message',
          orElse: () => {},
        );

    if (message.isEmpty) return [];

    // 2) Find the first "output_text" content chunk
    final content = (message['content'] as List?)?.cast<Map>() ?? const [];
    final textChunk = content.firstWhere(
      (c) => c['type'] == 'output_text',
      orElse: () => {},
    );

    final rawText = textChunk['text'];
    if (rawText == null) return [];

    // 3) Parse JSON (sometimes SDKs already give Map, so handle both)
    final Map<String, dynamic> decoded = rawText is String
        ? (jsonDecode(rawText) as Map<String, dynamic>)
        : (rawText as Map).cast<String, dynamic>();

    // 4) Return tasks as List<Map<String,dynamic>>
    final tasks = (decoded['tasks'] as List?) ?? const [];
    return tasks.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  /// Extract tasks using Google Gemini (updated for PDF support)
  Future<List<Map<String, dynamic>>> _extractWithGemini(
    AiConfig config, {
    List<File>? images,
    File? voice,
    File? pdf,
  }) async {
    if (config.geminiApiKey == null || config.geminiApiKey!.isEmpty) {
      throw Exception('Gemini API key not configured');
    }

    final model = config.model ?? 'gemini-1.5-flash';
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=${config.geminiApiKey}',
    );

    final List<Map<String, dynamic>> parts = [];

    // Add system prompt
    parts.add({
      'text': config.systemPrompt ?? defaultSystemPrompt,
    });

    // Add images
    if (images != null) {
      for (final image in images) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        parts.add({
          'inline_data': {
            'mime_type': 'image/jpeg',
            'data': base64Image,
          }
        });
      }
    }

    // Add PDF
    if (pdf != null) {
      final bytes = await pdf.readAsBytes();
      final base64Pdf = base64Encode(bytes);
      parts.add({
        'inline_data': {
          'mime_type': 'application/pdf',
          'data': base64Pdf,
        }
      });
    }

    // Add audio
    if (voice != null) {
      final bytes = await voice.readAsBytes();
      final base64Audio = base64Encode(bytes);
      parts.add({
        'inline_data': {
          'mime_type': 'audio/mp4',
          'data': base64Audio,
        }
      });
    }

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': parts}
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 8192,
          'responseMimeType': 'application/json',
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Gemini API error: ${response.statusCode} - ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = jsonResponse['candidates'] as List?;

    if (candidates == null || candidates.isEmpty) {
      return [];
    }

    final content = candidates[0]['content'] as Map<String, dynamic>;
    final contentParts = content['parts'] as List;
    final text = contentParts[0]['text'] as String;

    return _parseTasksFromResponse(text);
  }

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

final aiService = AiService();
