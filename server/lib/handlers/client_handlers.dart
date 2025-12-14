// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> latestWindows(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Get the latest version file dynamically
    final clientsDir = Directory('data/clients');

    if (!clientsDir.existsSync()) {
      return Response(
          statusCode: HttpStatus.notFound, body: 'Clients directory not found');
    }

    final files = clientsDir.listSync();
    final windowsVersions = <String, File>{};

    for (final file in files) {
      if (file is! File) continue;
      final fileName = file.path.split('/').last;

      // Extract version from filename pattern: smartopia_learning_windows_<version>.zip
      final match = RegExp(r'smartopia_learning_windows_(\d+\.\d+\.\d+)\.zip')
          .firstMatch(fileName);
      if (match != null) {
        final version = match.group(1)!;
        windowsVersions[version] = file;
      }
    }

    if (windowsVersions.isEmpty) {
      return Response(
          statusCode: HttpStatus.notFound,
          body: 'No Windows client versions found');
    }

    // Sort versions and get latest
    final sortedVersions = windowsVersions.keys.toList()
      ..sort((a, b) {
        final aParts = a.split('.').map(int.parse).toList();
        final bParts = b.split('.').map(int.parse).toList();
        for (int i = 0; i < 3; i++) {
          if (aParts[i] != bParts[i]) {
            return bParts[i].compareTo(aParts[i]);
          }
        }
        return 0;
      });

    final latestVersion = sortedVersions.first;
    final latestFile = windowsVersions[latestVersion]!;
    final fileName = 'smartopia_learning_windows_$latestVersion.zip';

    // Read file as bytes
    final bytes = await latestFile.readAsBytes();

    // Determine content type
    const contentType = 'application/zip';

    // Return file with appropriate headers
    return Response.bytes(
      body: bytes,
      headers: {
        'Content-Type': contentType,
        'Content-Disposition': 'attachment; filename="$fileName"',
        'Content-Length': bytes.length.toString(),
      },
    );
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to retrieve Windows client: $e');
  }
}

Future<Response> latestMacos(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Get the latest version file dynamically
    final clientsDir = Directory('data/clients');

    if (!clientsDir.existsSync()) {
      return Response(
          statusCode: HttpStatus.notFound, body: 'Clients directory not found');
    }

    final files = clientsDir.listSync();
    final macosVersions = <String, File>{};

    for (final file in files) {
      if (file is! File) continue;
      final fileName = file.path.split('/').last;

      // Extract version from filename pattern: smartopia_learning_macos_<version>.dmg
      final match = RegExp(r'smartopia_learning_macos_(\d+\.\d+\.\d+)\.dmg')
          .firstMatch(fileName);
      if (match != null) {
        final version = match.group(1)!;
        macosVersions[version] = file;
      }
    }

    if (macosVersions.isEmpty) {
      return Response(
          statusCode: HttpStatus.notFound,
          body: 'No macOS client versions found');
    }

    // Sort versions and get latest
    final sortedVersions = macosVersions.keys.toList()
      ..sort((a, b) {
        final aParts = a.split('.').map(int.parse).toList();
        final bParts = b.split('.').map(int.parse).toList();
        for (int i = 0; i < 3; i++) {
          if (aParts[i] != bParts[i]) {
            return bParts[i].compareTo(aParts[i]);
          }
        }
        return 0;
      });

    final latestVersion = sortedVersions.first;
    final latestFile = macosVersions[latestVersion]!;
    final fileName = 'smartopia_learning_macos_$latestVersion.dmg';

    // Read file as bytes
    final bytes = await latestFile.readAsBytes();

    // Determine content type
    const contentType = 'application/x-apple-diskimage';

    // Return file with appropriate headers
    return Response.bytes(
      body: bytes,
      headers: {
        'Content-Type': contentType,
        'Content-Disposition': 'attachment; filename="$fileName"',
        'Content-Length': bytes.length.toString(),
      },
    );
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to retrieve macOS client: $e');
  }
}

Future<Response> latestAndroid(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    // Get the latest version file dynamically
    final clientsDir = Directory('data/clients');

    if (!clientsDir.existsSync()) {
      return Response(
          statusCode: HttpStatus.notFound, body: 'Clients directory not found');
    }

    final files = clientsDir.listSync();
    final androidVersions = <String, File>{};

    for (final file in files) {
      if (file is! File) continue;
      final fileName = file.path.split('/').last;

      // Extract version from filename pattern: smartopia_learning_android_<version>.apk
      final match = RegExp(r'smartopia_learning_android_(\d+\.\d+\.\d+)\.apk')
          .firstMatch(fileName);
      if (match != null) {
        final version = match.group(1)!;
        androidVersions[version] = file;
      }
    }

    if (androidVersions.isEmpty) {
      return Response(
          statusCode: HttpStatus.notFound,
          body: 'No Android client versions found');
    }

    // Sort versions and get latest
    final sortedVersions = androidVersions.keys.toList()
      ..sort((a, b) {
        final aParts = a.split('.').map(int.parse).toList();
        final bParts = b.split('.').map(int.parse).toList();
        for (int i = 0; i < 3; i++) {
          if (aParts[i] != bParts[i]) {
            return bParts[i].compareTo(aParts[i]);
          }
        }
        return 0;
      });

    final latestVersion = sortedVersions.first;
    final latestFile = androidVersions[latestVersion]!;
    final fileName = 'smartopia_learning_android_$latestVersion.apk';

    // Read file as bytes
    final bytes = await latestFile.readAsBytes();

    // Determine content type
    const contentType = 'application/vnd.android.package-archive';

    // Return file with appropriate headers
    return Response.bytes(
      body: bytes,
      headers: {
        'Content-Type': contentType,
        'Content-Disposition': 'attachment; filename="$fileName"',
        'Content-Length': bytes.length.toString(),
      },
    );
  } catch (e) {
    return Response(
        statusCode: HttpStatus.internalServerError,
        body: 'Failed to retrieve Android client: $e');
  }
}
