import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/services/ai_service.dart';
import 'package:smartopia_hms_shared/shared.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final formData = await context.request.formData();

    final tempImages = <File>[];
    File? tempVoice;
    File? tempPdf;

    final files = formData.files;

    // Detect file types by MIME type or extension
    for (final entry in files.entries) {
      final uploaded = entry.value;
      final fileType = _detectFileType(uploaded);

      final savedFile = await _saveToTemp(uploaded);

      switch (fileType) {
        case FileType.image:
          tempImages.add(savedFile);
          break;
        case FileType.pdf:
          tempPdf = savedFile;
          break;
        case FileType.audio:
          tempVoice = savedFile;
          break;
        case FileType.unknown:
          // Fallback to field key for backward compatibility
          if (entry.key == 'images') {
            tempImages.add(savedFile);
          } else if (entry.key == 'pdf') {
            tempPdf = savedFile;
          } else if (entry.key == 'voice') {
            tempVoice = savedFile;
          }
          break;
      }
    }

    // for testing
    /*if (File('data/test_tasks.json').existsSync()) {
      return Response.json(
        body: jsonDecode(File('data/test_tasks.json').readAsStringSync()),
      );
    }*/

    final tasks = await aiService.extractTasks(
      images: tempImages,
      voice: tempVoice,
      pdf: tempPdf,
    );

    if (tasks == null) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': 'Failed to extract tasks'},
      );
    }

    File('data/test_tasks.json').writeAsStringSync(jsonEncode(tasks));

    // Clean up
    for (final f in tempImages) {
      if (f.existsSync()) await f.delete();
    }
    if (tempVoice != null && tempVoice.existsSync()) {
      await tempVoice.delete();
    }
    if (tempPdf != null && tempPdf.existsSync()) {
      await tempPdf.delete();
    }

    for (final task in tasks) {
      try {
        if (task['startDateTime'] != null) {
          final pattern = OncePattern(
            startDateTime: DateTime.parse(task['startDateTime'] as String),
            dueDateTime: task['endDateTime'] != null
                ? DateTime.parse(task['endDateTime'] as String)
                : null,
          );
          task['recurrence'] = pattern.toJson();
        } else {
          task['recurrence'] = OncePattern(
            startDateTime: DateTime.now(),
            dueDateTime: DateTime.now().add(const Duration(days: 1)),
          ).toJson();
        }
      } catch (e, st) {
        logError(
            'Failed to parse recurrence pattern for task ${task['id']}', e, st);
      }
    }
    return Response.json(body: tasks);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}

enum FileType { image, pdf, audio, unknown }

/// Detect file type based on MIME type or file extension
FileType _detectFileType(UploadedFile file) {
  // Check MIME type first
  final contentType = file.contentType.mimeType.toLowerCase();

  if (contentType.startsWith('image/')) {
    return FileType.image;
  } else if (contentType == 'application/pdf') {
    return FileType.pdf;
  } else if (contentType.startsWith('audio/')) {
    return FileType.audio;
  }

  // Fallback to file extension
  final fileName = file.name.toLowerCase();

  if (fileName.endsWith('.pdf')) {
    return FileType.pdf;
  } else if (fileName.endsWith('.jpg') ||
      fileName.endsWith('.jpeg') ||
      fileName.endsWith('.png') ||
      fileName.endsWith('.webp') ||
      fileName.endsWith('.heic') ||
      fileName.endsWith('.heif')) {
    return FileType.image;
  } else if (fileName.endsWith('.mp3') ||
      fileName.endsWith('.m4a') ||
      fileName.endsWith('.wav') ||
      fileName.endsWith('.webm') ||
      fileName.endsWith('.mp4') ||
      fileName.endsWith('.mpeg')) {
    return FileType.audio;
  }

  return FileType.unknown;
}

Future<File> _saveToTemp(UploadedFile uploadedFile) async {
  final tempDir = await Directory.systemTemp.createTemp('hms_ai_upload_');
  final file = File('${tempDir.path}/${uploadedFile.name}');
  final bytes = await uploadedFile.readAsBytes();
  await file.writeAsBytes(bytes);
  // for testing:
  final dataDir = Directory('data');
  if (!dataDir.existsSync()) {
    dataDir.createSync(recursive: true);
  }
  final testFile = File('data/${uploadedFile.name}');
  await testFile.writeAsBytes(bytes);
  return file;
}
