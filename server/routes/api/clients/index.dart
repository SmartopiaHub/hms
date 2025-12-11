// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final clientsDir = Directory('data/clients');
    
    if (!clientsDir.existsSync()) {
      return Response.json(
        body: {
          'android': null,
          'macos': null,
          'windows': null,
        },
      );
    }

    final files = clientsDir.listSync();
    
    // Parse version numbers from filenames
    final androidVersions = <String>[];
    final macosVersions = <String>[];
    final windowsVersions = <String>[];
    
    for (final file in files) {
      if (file is! File) continue;
      final fileName = file.path.split('/').last;
      
      // Extract version from filename pattern: smartopia_learning_<platform>_<version>.<ext>
      final match = RegExp(r'smartopia_learning_(android|macos|windows)_(\d+\.\d+\.\d+)\.(apk|dmg|zip)').firstMatch(fileName);
      if (match != null) {
        final platform = match.group(1)!;
        final version = match.group(2)!;
        
        if (platform == 'android') {
          androidVersions.add(version);
        } else if (platform == 'macos') {
          macosVersions.add(version);
        } else if (platform == 'windows') {
          windowsVersions.add(version);
        }
      }
    }
    
    // Sort versions and get latest
    String? getLatestVersion(List<String> versions) {
      if (versions.isEmpty) return null;
      versions.sort((a, b) {
        final aParts = a.split('.').map(int.parse).toList();
        final bParts = b.split('.').map(int.parse).toList();
        for (int i = 0; i < 3; i++) {
          if (aParts[i] != bParts[i]) {
            return bParts[i].compareTo(aParts[i]);
          }
        }
        return 0;
      });
      return versions.first;
    }
    
    final androidLatest = getLatestVersion(androidVersions);
    final macosLatest = getLatestVersion(macosVersions);
    final windowsLatest = getLatestVersion(windowsVersions);
    
    // System requirements - these should be kept up to date
    final response = {
      'android': androidLatest != null ? {
        'version': androidLatest,
        'available': true,
        'minSystemVersion': 'Android 5.0 (API 21)',
        'downloadUrl': '/clients/smartopia_learning_android_$androidLatest.apk',
      } : {
        'available': false,
        'status': 'Under Development',
      },
      'macos': macosLatest != null ? {
        'version': macosLatest,
        'available': true,
        'minSystemVersion': 'macOS 10.14 (Mojave)',
        'downloadUrl': '/clients/smartopia_learning_macos_$macosLatest.dmg',
      } : {
        'available': false,
        'status': 'Under Development',
      },
      'windows': windowsLatest != null ? {
        'version': windowsLatest,
        'available': true,
        'minSystemVersion': 'Windows 10 (64-bit)',
        'downloadUrl': '/clients/smartopia_learning_windows_$windowsLatest.zip',
      } : {
        'available': false,
        'status': 'Under Development',
      },
    };
    
    return Response.json(body: response);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to retrieve client information: $e'},
    );
  }
}
