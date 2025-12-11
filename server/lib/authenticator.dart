
// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// lib/authenticator.dart

import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:logging/logging.dart';
import 'package:smartopia_hms_server/model/database.dart';

// Helper method to hash passwords.
String hashPassword(String password) {
  final salt = BCrypt.gensalt();
  return BCrypt.hashpw(password, salt);
}

// TODO: Update this to your secret key.
SecretKey get secretKey => SecretKey('123');

final _logger = Logger('Authenticator');

/// Helper class to authenticate users.
class Authenticator {

  Future<User?> findByUsername({required String username}) async {
    return database.managers.users.filter((t) => t.username.equals(username)).getSingleOrNull();
  }

  /// Find a user by username and password.
  /// Returns a [User] object if the credentials are valid, otherwise null.
  Future<User?> findByUsernameAndPassword ({
    required String username,
    required String password,
  }) async {

    final user = await database.managers.users.filter((t) => t.username.equals(username)).getSingleOrNull();
    if (user != null){
      if (BCrypt.checkpw(password, user.password)) return user;
      return null;
    }
    return null;
  }

  Future<User?> verifyToken(String token) async {
    try {
      final payload = JWT.verify(
        token,
        secretKey,
      );

      final payloadData = payload.payload as Map<String, dynamic>;

      final username = payloadData['username'] as String;
      return findByUsername(username: username);
    } catch (e, st) {
      //developer.log('verifyToken failed', error: e, stackTrace: st);
      _logger.severe('verifyToken failed', e, st);
      return null;
    }
  }

  String generateToken({
    required User user,
  }) {
    final jwt = JWT(
      {
        'id': user.id,
        'username': user.username,
      },
    );

    return jwt.sign(secretKey, expiresIn: const Duration(days: 7));
  }

}
