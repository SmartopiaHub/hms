import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smartopia_hms_client/api.dart';
import 'package:smartopia_hms_client/notification.dart';
import 'package:smartopia_hms_client/pages/base.dart';

class AiSettingsPage extends StatefulWidget {
  const AiSettingsPage({super.key});

  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends PageBaseState<AiSettingsPage> {
  String _provider = 'openai';
  final _openaiKeyController = TextEditingController();
  final _geminiKeyController = TextEditingController();
  final _modelController = TextEditingController();
  final _systemPromptController = TextEditingController();

  bool _hasOpenaiKey = false;
  bool _hasGeminiKey = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _openaiKeyController.dispose();
    _geminiKeyController.dispose();
    _modelController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    try {
      final response = await apiService.httpGet('config/ai');
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _provider = data['provider'] as String? ?? 'openai';
          _hasOpenaiKey = data['hasOpenaiKey'] as bool? ?? false;
          _hasGeminiKey = data['hasGeminiKey'] as bool? ?? false;
          _modelController.text = data['model'] as String? ?? '';
          _systemPromptController.text = data['systemPrompt'] as String? ?? '';
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveConfig() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final config = <String, dynamic>{
        'provider': _provider,
        if (_openaiKeyController.text.isNotEmpty)
          'openaiApiKey': _openaiKeyController.text,
        if (_geminiKeyController.text.isNotEmpty)
          'geminiApiKey': _geminiKeyController.text,
        if (_modelController.text.isNotEmpty) 'model': _modelController.text,
        if (_systemPromptController.text.isNotEmpty)
          'systemPrompt': _systemPromptController.text,
      };

      final response = await apiService.httpPost('config/ai', body: config);

      if (response.statusCode == 200 && mounted) {
        showInfoNotification(
          'AI settings saved successfully',
          context: context,
        );
      } else if (mounted) {
        showErrorNotification('Failed to save AI settings', context: context);
      }
    } catch (e) {
      if (mounted) {
        showErrorNotification('Error: $e', context: context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  String get pageTitle => 'AI Settings';

  @override
  bool get goBackButtonInAppBar => true;

  @override
  Widget buildContent(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Provider', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _provider,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Select AI provider',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'openai',
                  child: Text('OpenAI (GPT + Whisper)'),
                ),
                DropdownMenuItem(value: 'gemini', child: Text('Google Gemini')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _provider = value;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            Text('OpenAI API Key', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _openaiKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    _hasOpenaiKey ? 'API key configured (hidden)' : 'sk-...',
                helperText: 'Get your API key from platform.openai.com',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            Text('Gemini API Key', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _geminiKeyController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText:
                    _hasGeminiKey
                        ? 'API key configured (hidden)'
                        : 'Enter API key',
                helperText: 'Get your API key from aistudio.google.com',
              ),
              obscureText: true,
            ),

            const SizedBox(height: 24),

            Text('Model (Optional)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Leave empty for default',
                helperText: 'e.g., gpt-4-vision-preview or gemini-1.5-pro',
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Custom System Prompt (Optional)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Custom instructions for the AI...',
              ),
              maxLines: 5,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveConfig,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isSaving
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Save Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
