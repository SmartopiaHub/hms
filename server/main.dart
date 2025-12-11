// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:smartopia_hms_server/authenticator.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/scheduler.dart';



Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  // 1. Execute any custom code prior to starting the server...
  initLogging();
  // do your one-time setup here:
  logInfo('🔧 custom startup logic…');

  // Check for admin user
  final users = await database.select(database.users).get();
  if (users.isEmpty) {
    logInfo('Creating default admin user...');
    final configFile = File('./data/config.json');
    var password = 'admin';
    if (configFile.existsSync()) {
      try {
        final json = jsonDecode(await configFile.readAsString());
        password = json['default_admin_password'] as String? ?? 'admin';
      } catch (e) {
        logInfo('Error reading config.json: $e');
      }
    } else {
      await configFile.create(recursive: true);
      await configFile.writeAsString(jsonEncode({'default_admin_password': password}));
    }

    await database.into(database.users).insert(UsersCompanion.insert(
      username: 'admin',
      password: hashPassword(password),
      isParent: const drift.Value(true),
      nickname: const drift.Value('Administrator'),
    ));
    logInfo('Default admin user created.');
  }

  await bootstrap();
  logInfo('🚀 server listening on ${ip.address}:$port');

  // 2. Use the provided `handler`, `ip`, and `port` to create a custom `HttpServer`.
  // Or use the Dart Frog serve method to do that for you.
  return serve(handler, ip, port);
}
