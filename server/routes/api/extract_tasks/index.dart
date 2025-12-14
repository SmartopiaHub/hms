import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:smartopia_hms_server/services/ai_service.dart';

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

    final tasks = await aiService.extractTasks(
      images: tempImages,
      voice: tempVoice,
      pdf: tempPdf,
    );

    // Clean up
    for (final f in tempImages) {
      if (await f.exists()) await f.delete();
    }
    if (tempVoice != null && await tempVoice.exists()) {
      await tempVoice.delete();
    }
    if (tempPdf != null && await tempPdf.exists()) {
      await tempPdf.delete();
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
  final contentType = file.contentType?.mimeType.toLowerCase();

  if (contentType != null) {
    if (contentType.startsWith('image/')) {
      return FileType.image;
    } else if (contentType == 'application/pdf') {
      return FileType.pdf;
    } else if (contentType.startsWith('audio/')) {
      return FileType.audio;
    }
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
  await file.writeAsBytes(await uploadedFile.readAsBytes());
  return file;
}
