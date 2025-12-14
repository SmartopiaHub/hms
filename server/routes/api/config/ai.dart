import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/services/ai_config_service.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _getConfig(context);
    case HttpMethod.post:
      return _saveConfig(context);
    case HttpMethod.delete:
      return _deleteConfig(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _getConfig(RequestContext context) async {
  try {
    final config = await aiConfigService.getConfig();

    if (config == null) {
      return Response.json(
        body: {},
      );
    }

    // Don't send API keys to client for security
    return Response.json(
      body: {
        'provider': config.provider,
        'model': config.model,
        'systemPrompt': config.systemPrompt,
        'hasOpenaiKey':
            config.openaiApiKey != null && config.openaiApiKey!.isNotEmpty,
        'hasGeminiKey':
            config.geminiApiKey != null && config.geminiApiKey!.isNotEmpty,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

Future<Response> _saveConfig(RequestContext context) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final provider = body['provider'] as String?;
    if (provider == null || (provider != 'openai' && provider != 'gemini')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'error': 'Invalid or missing provider. Must be "openai" or "gemini"'
        },
      );
    }

    // Load existing config to preserve keys if not being updated
    final existingConfig = await aiConfigService.getConfig();

    final config = AiConfig(
      provider: provider,
      openaiApiKey:
          body['openaiApiKey'] as String? ?? existingConfig?.openaiApiKey,
      geminiApiKey:
          body['geminiApiKey'] as String? ?? existingConfig?.geminiApiKey,
      model: body['model'] as String?,
      systemPrompt: body['systemPrompt'] as String?,
    );

    await aiConfigService.saveConfig(config);

    return Response.json(
      body: {'message': 'AI configuration saved successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

Future<Response> _deleteConfig(RequestContext context) async {
  try {
    final file = File('data/ai_config.json');
    if (await file.exists()) {
      await file.delete();
    }
    aiConfigService.clearCache();

    return Response.json(
      body: {'message': 'AI configuration deleted successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}
