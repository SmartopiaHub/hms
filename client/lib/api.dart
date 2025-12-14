// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

// filepath: /path/to/your/service/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'logger.dart';
import 'model/database.dart';
import 'model/mqtt.dart';
import 'model/shop_item.dart';
import 'server.dart';
import 'sse.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:smartopia_hms_shared/shared.dart';
import 'package:mime/mime.dart';

import 'local_storage.dart';

Future<String?> getToken() async {
  return await read('authToken');
}

typedef ServerErrorCallback = void Function(String error);
typedef ServerSuccessCallback = void Function();

late ApiService apiService;

class ApiService {
  ServerErrorCallback? onError;
  ServerSuccessCallback? onSuccess;

  ApiService({this.onError, this.onSuccess});

  static void initApiService({
    ServerErrorCallback? onError,
    ServerSuccessCallback? onSuccess,
  }) {
    apiService = ApiService(onError: onError, onSuccess: onSuccess);
  }

  Future<String?> get apiUrl async {
    final serverUrl = await getServerUrl();
    return serverUrl == null ? null : '$serverUrl/api';
  }

  Future<Map<String, String>> _constructHeaders() async {
    final token = await getToken();
    if (token == null) {
      return {'Content-Type': 'application/json'};
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> httpGet(String endpoint) async {
    final baseUrl = await apiUrl;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _constructHeaders(),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        onError?.call(
          'GET $endpoint failed with status code ${response.statusCode}',
        );
      } else {
        onSuccess?.call();
      }
      return response;
    } catch (e) {
      onError?.call('GET $endpoint failed with error: $e');
      return http.Response('', 500);
    }
  }

  Future<http.Response> httpPost(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final baseUrl = await apiUrl;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _constructHeaders(),
        body: jsonEncode(body),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        onError?.call(
          'POST $endpoint failed with status code ${response.statusCode}',
        );
      } else {
        onSuccess?.call();
      }
      return response;
    } catch (e) {
      onError?.call('POST $endpoint failed with error: $e');
      return http.Response('', 500);
    }
  }

  Future<http.Response> httpPut(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final baseUrl = await apiUrl;
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _constructHeaders(),
        body: jsonEncode(body),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        onError?.call(
          'PUT $endpoint failed with status code ${response.statusCode}',
        );
      } else {
        onSuccess?.call();
      }
      return response;
    } catch (e) {
      onError?.call('PUT $endpoint failed with error: $e');
      return http.Response('', 500);
    }
  }

  Future<http.Response> httpDelete(String endpoint) async {
    final baseUrl = await apiUrl;
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: await _constructHeaders(),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) {
        onError?.call(
          'DELETE $endpoint failed with status code ${response.statusCode}',
        );
      } else {
        onSuccess?.call();
      }
      return response;
    } catch (e) {
      onError?.call('DELETE $endpoint failed with error: $e');
      return http.Response('', 500);
    }
  }

  Future<bool> signIn(String username, String password) async {
    final response = await httpPost(
      'signin',
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('Sign in successful: $jsonResponse');
      String token = jsonResponse['token'];
      await save(key: 'authToken', value: token);
      await save(key: 'username', value: username);
      await save(key: 'password', value: password);
      await save(
        key: 'isParent',
        value: jsonResponse['user']['isParent'].toString(),
      );
      await save(
        key: 'allowSelfHomeworkManagement',
        value:
            (jsonResponse['user']['allowSelfHomeworkManagement'] ?? false)
                .toString(),
      );
      if (jsonResponse['user']['pointSystemId'] != null) {
        await save(
          key: 'pointSystemId',
          value: jsonResponse['user']['pointSystemId'],
        );
      }
      if (jsonResponse['user']['totalPoints'] != null) {
        await save(
          key: 'totalPoints',
          value: jsonResponse['user']['totalPoints'].toString(),
        );
      }
      if (jsonResponse['user']['redeemedPoints'] != null) {
        await save(
          key: 'redeemedPoints',
          value: jsonResponse['user']['redeemedPoints'].toString(),
        );
      }
      print('Token stored successfully. Start notification service...');
      NotificationService().init(token);
      print('Notification service started.');
      onSuccess?.call();
      return true;
    }
    onError?.call('Failed to sign in with status code ${response.statusCode}');
    return false;
  }

  Future<int?> signUp(User user) async {
    final response = await httpPost('signup', body: user.toJson());
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    }
    return null;
  }

  Future<bool> isSignupAllowed() async {
    final response = await httpGet('signup');
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['allow'];
    }
    return false;
  }

  Future<int?> createUser(User user) async {
    final response = await httpPost('users', body: user.toJson());
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    }
    return null;
  }

  Future<bool> updateUser(User user) async {
    final response = await httpPut('users/${user.id}', body: user.toJson());
    return response.statusCode == 200;
  }

  Future<bool> deleteUser(int id) async {
    final response = await httpDelete('users/$id');
    return response.statusCode == 200;
  }

  Future<bool> purgeTasks() async {
    final response = await httpPost('tasks/purge', body: {});
    return response.statusCode == 200;
  }

  Future<bool> purgeTaskTemplates() async {
    final response = await httpPost('tasktemplate/purge', body: {});
    return response.statusCode == 200;
  }

  Future<List<Map<String, dynamic>>> exportTaskTemplates() async {
    final response = await httpGet('tasktemplate/export');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  Future<Map<String, dynamic>?> importTaskTemplates(
    List<Map<String, dynamic>> templates,
  ) async {
    final response = await httpPost(
      'tasktemplate/import',
      body: {'templates': templates},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'importedCount': data['importedCount'] ?? 0,
        'duplicates': List<Map<String, dynamic>>.from(data['duplicates'] ?? []),
      };
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> exportTasks() async {
    final response = await httpGet('tasks/export');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  Future<Map<String, dynamic>?> importTasks(
    List<Map<String, dynamic>> tasks,
  ) async {
    final response = await httpPost('tasks/import', body: {'tasks': tasks});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'importedCount': data['importedCount'] ?? 0,
        'duplicates': List<Map<String, dynamic>>.from(data['duplicates'] ?? []),
      };
    }
    return null;
  }

  Future<bool> createTaskTemplate(TaskTemplate task) async {
    final response = await httpPost('tasktemplate', body: task.toJson());
    return response.statusCode == 201;
  }

  Future<bool> updateTaskTemplate(TaskTemplate task) async {
    final response = await httpPut(
      'tasktemplate/${task.id}',
      body: task.toJson(),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteTaskTemplate(int id) async {
    final response = await httpDelete('tasktemplate/$id');
    return response.statusCode == 200;
  }

  Future<List<TaskTemplate>> fetchTaskTemplates({
    int? pageKey,
    int tasksPerPage = 20,
    bool? active,
  }) async {
    final response = await httpGet(
      'tasktemplate?page=$pageKey&limit=$tasksPerPage&active=$active',
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((task) => TaskTemplate.fromJson(task)).toList();
    }
    return [];
  }

  Future<TaskTemplate?> fetchTaskTemplate(int id) async {
    final response = await httpGet('tasktemplate/$id');
    if (response.statusCode == 200) {
      return TaskTemplate.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<Task>> searchTasks({
    int? pageKey,
    int tasksPerPage = 20,
    DateTime? start,
    DateTime? end,
    List<TaskStatus> statuses = const [],
    List<String> assignedUsers = const [],
  }) async {
    // form a json body for the search
    final searchParams = {
      'page': pageKey ?? 0,
      'limit': tasksPerPage,
      'sort': 'dueDate',
      'order': 'asc',
      'filter': {
        if (start != null) 'start': start.toIso8601String(),
        if (end != null) 'end': end.toIso8601String(),
        if (statuses.isNotEmpty)
          'statuses': statuses.map((s) => s.name).toList(),
        if (assignedUsers.isNotEmpty) 'assignedUsers': assignedUsers,
      },
    };
    final response = await httpPost('tasks/search', body: searchParams);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    }
    return [];
  }

  Future<List<Task>> fetchTasks({int? pageKey, int tasksPerPage = 20}) async {
    final response = await httpGet('tasks?page=$pageKey&limit=$tasksPerPage');
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    }
    return [];
  }

  Future<Task?> fetchTask(int id) async {
    try {
      final response = await httpGet('tasks/$id');
      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e, st) {
      print('Error fetching task: $e with \n$st');
      return null;
    }
  }

  Future<bool> deleteTask(int id) async {
    final response = await httpDelete('tasks/$id');
    return response.statusCode == 200;
  }

  Future<String?> downloadFile(int taskId, String filename) async {
    final response = await httpGet('tasks/$taskId/files?filename=$filename');
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      if (kIsWeb) {
        // For web, we can use the FileSaver package to save the file
        final blob = html.Blob([bytes], 'application/octet-stream');
        final url = html.Url.createObjectUrlFromBlob(blob);
        /*final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();
        html.Url.revokeObjectUrl(url);*/
        return url; // No need to return anything for web
      } else {
        // For mobile, we can use the path_provider package to save the file
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$filename';
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return filePath; // Return the local file path
      }
    }
    return null;
  }

  Future<void> submitTask(int taskId, List<PlatformFile> files) async {
    // 1) Build the multipart request
    try {
      final baseUrl = await apiUrl;
      final uri = Uri.parse('$baseUrl/tasks/$taskId/submit');
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer ${await getToken()}';

      // 2) Attach each file under the same field name “files”
      for (final f in files) {
        req.files.add(
          http.MultipartFile.fromBytes(
            'files',
            f.bytes!,
            filename: f.name,
            contentType: MediaType('application', 'octet-stream'),
          ),
        );
      }

      // 3) Send & await a streamed response
      final streamedRes = await req.send();
      final res = await http.Response.fromStream(streamedRes);
      if (res.statusCode < 200 || res.statusCode > 299) {
        throw Exception('Server returned ${res.statusCode}');
      }
      onSuccess?.call();
    } catch (e) {
      onError?.call('Failed to submit task: $e');
    }
  }

  Future<bool> gradeTask(int taskId, int stars) async {
    final response = await httpPost(
      'tasks/$taskId/grade',
      body: {'stars': stars},
    );
    return response.statusCode == 200;
  }

  Future<bool> cancelTask({
    int? taskId,
    int? templateId,
    DateTime? startTime,
  }) async {
    final response = await httpPost(
      'tasks/cancel',
      body: {
        'taskId': taskId,
        'templateId': templateId,
        'startTime': startTime?.toIso8601String(),
      },
    );
    return response.statusCode == 200;
  }

  Future<List<User>> fetchUsers() async {
    final response = await httpGet('users');
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    }
    return [];
  }

  Future<List<String>> getChildList() async {
    final response = await httpGet('users?type=children');
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user).username).toList();
    }
    return [];
  }

  Future<User?> fetchUser(String userId) async {
    final response = await httpGet('users/$userId');
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> changePassword(int userId, String newPassword) async {
    final response = await httpPost(
      'users/password',
      body: {
        'userId': userId,
        //'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
    return response.statusCode == 200;
  }

  Future<MqttConfig?> getMqttConfig() async {
    //try{
    final response = await httpGet('mqtt/config');
    if (response.statusCode == 200) {
      return MqttConfig.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 405) {
      /// mqtt not set up yet
      return null;
    } else {
      logError(
        'Failed to fetch MQTT config with status code ${response.statusCode}',
      );
      return null;
    }
    //}
    //catch (e, st) {
    //  logError('Error fetching MQTT config', e, st);
    //  return null;
    //}
  }

  Future<bool> isMqttConnected() async {
    final response = await httpGet('mqtt/status');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final status = jsonData['status'] as String?;
      if (status == 'connected') {
        return true;
      }
    }
    return false;
  }

  Future<bool> configureMqtt(MqttConfig config) async {
    final response = await httpPost('mqtt/config', body: config.toJson());
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getConfig() async {
    final response = await httpGet('config');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  Future<bool> updateConfig(Map<String, dynamic> config) async {
    final response = await httpPut('config', body: config);
    return response.statusCode == 200;
  }

  Future<NotificationSetting?> getNotificationSettings() async {
    final response = await httpGet('users/notification-settings');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return NotificationSetting.fromJson(jsonData);
    } else {
      logError(
        'Failed to fetch notification settings with status code ${response.statusCode}',
      );
      return null;
    }
  }

  Future<bool> updateNotificationSettings(NotificationSetting settings) async {
    final response = await httpPut(
      'users/notification-settings',
      body: {'notificationSettings': settings.toJson()},
    );
    return response.statusCode == 200;
  }

  Future<String?> getPointSystem() async {
    final response = await httpGet('users/point-system');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['pointSystemId'] as String?;
    } else {
      logError(
        'Failed to fetch point system settings with status code ${response.statusCode}',
      );
      return null;
    }
  }

  Future<bool> updatePointSystem(String? pointSystemId) async {
    final response = await httpPut(
      'users/point-system',
      body: {'pointSystemId': pointSystemId},
    );
    return response.statusCode == 200;
  }

  Future<RewardPointInfo> fetchMyPoints() async {
    final response = await httpGet('users/points');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return RewardPointInfo.fromJson(data);
    }
    return RewardPointInfo(totalPoints: 0, redeemedPoints: 0);
  }

  // Shop API
  Future<List<ShopItem>> getShopItems({bool showAll = false}) async {
    final response = await httpGet('shop?all=$showAll');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ShopItem.fromJson(json)).toList();
    }
    return [];
  }

  Future<ShopItem?> createShopItem(ShopItem item) async {
    final response = await httpPost('shop', body: item.toJson());
    if (response.statusCode == 200) {
      return ShopItem.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<ShopItem?> updateShopItem(ShopItem item) async {
    final response = await httpPut(
      'shop/items/${item.id}',
      body: item.toJson(),
    );
    if (response.statusCode == 200) {
      return ShopItem.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> deleteShopItem(int id) async {
    final response = await httpDelete('shop/items/$id');
    return response.statusCode == 204;
  }

  Future<User?> redeemShopItem(int id) async {
    final response = await httpPost('shop/items/$id/redeem', body: {});
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getRedemptions() async {
    final response = await httpGet('shop/redemptions');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final baseUrl = await apiUrl;
      final uri = Uri.parse('$baseUrl/uploads');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await _constructHeaders());

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        onSuccess?.call();
        return data['url'];
      }
      onError?.call(
        'Failed to upload file with status code ${response.statusCode}',
      );
    } catch (e) {
      onError?.call('Failed to upload file: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getClientInfo() async {
    final response = await httpGet('clients');
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  /// Extracts task templates from the provided media files using AI.
  Future<List<TaskTemplate>> extractAiTasks({
    List<File>? images,
    String? voicePath,
  }) async {
    try {
      final baseUrl = await apiUrl;
      final uri = Uri.parse('$baseUrl/extract_tasks');
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await _constructHeaders());

      if (images != null) {
        for (var image in images) {
          final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
          final mime = mimeType.split('/');
          request.files.add(
            await http.MultipartFile.fromPath(
              'images',
              image.path,
              contentType: MediaType(mime[0], mime[1]),
            ),
          );
        }
      }

      if (voicePath != null) {
        final mimeType = lookupMimeType(voicePath) ?? 'audio/mp4';
        final mime = mimeType.split('/');
        request.files.add(
          await http.MultipartFile.fromPath(
            'voice',
            voicePath,
            contentType: MediaType(mime[0], mime[1]),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final me = await read('username');

        return jsonList.map((json) {
          final Map<String, dynamic> data = Map<String, dynamic>.from(json);
          // Ensure basic fields are present and safe
          data['id'] = -1; // Temporary ID
          data['creator'] = me ?? 'unknown';
          data['assignedUsers'] ??= <String>[];
          data['priority'] ??= 1;
          data['remind'] ??= 0;
          data['recurrence'] ??=
              RecurrencePattern.defaultPattern(
                RecurrencePatternType.once,
              ).toJson();
          data['attachmentRequired'] ??= false;
          data['submissionRequired'] ??= false;
          data['creationTime'] ??= DateTime.now().toIso8601String();
          data['expectedCompletionTimeInMinutes'] ??= 30;

          try {
            return TaskTemplate.fromJson(data);
          } catch (e) {
            print('Error parsing AI task: $e');
            // Fallback minimal task
            return TaskTemplate(
              id: -1,
              title: data['title'] ?? 'Untitled Task',
              creator: me ?? 'unknown',
              assignedUsers: [],
              priority: 1,
              remind: 0,
              description: data['description'],
              recurrence: RecurrencePattern.defaultPattern(
                RecurrencePatternType.once,
              ),
              attachmentRequired: false,
              submissionRequired: false,
              creationTime: DateTime.now(),
              expectedCompletionTimeInMinutes: const Duration(minutes: 30),
              rewards:
                  data['rewards'] != null
                      ? RewardInfo.fromJson(data['rewards'])
                      : null,
              penalty: data['penalty'],
            );
          }
        }).toList();
      } else {
        onError?.call(
          'Failed to extract tasks: ${response.statusCode} ${response.body}',
        );
        return [];
      }
    } catch (e) {
      onError?.call('Error communicating with AI service: $e');
      return [];
    }
  }
}
