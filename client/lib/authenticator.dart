// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:smartopia_hms_shared/shared.dart';

import 'api.dart';
import 'local_storage.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class AuthProvider extends ChangeNotifier {
  String? _token;
  DateTime? _expiry;
  String? _username;
  bool? _isParent;
  bool? _allowSelfHomeworkManagement;
  RewardPointInfo? _rewardPoints;
  String? _pointSystemId;

  bool get isAuthenticated => _token != null && _expiry != null && DateTime.now().isBefore(_expiry!);

  String? get token => _token;

  String? get username => _username;

  bool get isParent => _isParent ?? false;

  bool get allowSelfHomeworkManagement => _allowSelfHomeworkManagement ?? false;

  RewardPointInfo get rewardPointInfo => _rewardPoints ?? RewardPointInfo(totalPoints: 0, redeemedPoints: 0);
  
  String? get pointSystemId => _pointSystemId;

  Future<void> refreshPoints() async {
    if (isAuthenticated) {
      try {
        final points = await apiService.fetchMyPoints();
        updatePoints(points);
      } catch (e) {
        print('Failed to refresh points: $e');
      }
    }
  }

  void updatePoints(RewardPointInfo points) {
    _rewardPoints = points;
    save(key: 'totalPoints', value: points.totalPoints.toString());
    save(key: 'redeemedPoints', value: points.redeemedPoints.toString());
    notifyListeners();
  }

  Future<void> loadCredentials() async {
    try{
      _username = await read('username');
      _isParent = await read('isParent') == 'true';
      _allowSelfHomeworkManagement = await read('allowSelfHomeworkManagement') == 'true';
      _pointSystemId = await read('pointSystemId');
      var totalPoints = await read('totalPoints');
      var redeemedPoints = await read('redeemedPoints');
      _rewardPoints = RewardPointInfo(
        totalPoints: totalPoints == null ? 0 : int.tryParse(totalPoints) ?? 0,
        redeemedPoints: redeemedPoints == null ? 0 : int.tryParse(redeemedPoints) ?? 0);
      var token = await read('authToken');
      if (token == null) {
        _token = null;
        _expiry = null;
      } 
      else {
        // Get the expiration DateTime
        final DateTime expiry = JwtDecoder.getExpirationDate(token);
        // Check if it’s expired
        final bool isExpired = JwtDecoder.isExpired(token);
        if (isExpired) {
          _token = null;
          _expiry = null;
          await delete('authToken');
        } else {
          _token = token;
          _expiry = expiry;
          if (!_isParent!) {
            _rewardPoints = await apiService.fetchMyPoints();
          }
        }
      }
      notifyListeners();
    }
    catch(e, s){
      print('Error loading credentials: $e\n$s');
      _token = null;
      _expiry = null;
      _username = null;
      _isParent = false;
      _allowSelfHomeworkManagement = false;
      _pointSystemId = null;
      _rewardPoints = null;
      await delete('authToken');
      await delete('username');
      await delete('isParent');
      await delete('allowSelfHomeworkManagement');
      await delete('pointSystemId');
      await delete('totalPoints');
      notifyListeners();
    }
  }

  Future<bool> signIn(String username, String password) async {
    var success = await apiService.signIn(username, password);
    if (success){ 
      await loadCredentials();
    }
    return success;
  }

  Future<void> signOut() async {
    _token = null;
    _expiry = null;
    _username = null;
    _isParent = false;
    _pointSystemId = null;
    _rewardPoints = null;
    await delete('authToken');
    await delete('username');
    await delete('isParent');
    await delete('pointSystemId');
    await delete('totalPoints');
    await delete('redeemedPoints');
    notifyListeners();
  }
}