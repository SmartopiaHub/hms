// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';

List<int> encodeJsonToIntList(Map<String, dynamic> json) {
  final jsonString = jsonEncode(json);
  return utf8.encode(jsonString);
}

Map<String, dynamic> decodeIntListToJson(List<int> intList) {
  final jsonString = utf8.decode(intList);
  return jsonDecode(jsonString) as Map<String, dynamic>;
}

class NotificationRecord {
  int taskId;
  String receiver; // username of the receiver
  int method; // Notification method, e.g., PUSH_NOTIFICATION, EMAIL, SMS, MQTT
  DateTime time;

  NotificationRecord({
    required this.taskId,
    required this.receiver,
    required this.method,
    required this.time,
  });

  factory NotificationRecord.fromJson(Map<String, dynamic> json) {
    return NotificationRecord(
      taskId: json['taskId'] as int,
      receiver: json['receiver'] as String,
      method: json['method'] as int,
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'receiver': receiver,
      'method': method,
      'time': time.toIso8601String(),
    };
  }
}

class NotificationHistory {
  int taskId;
  List<NotificationRecord> onAssigned;
  List<NotificationRecord> onStarted;
  List<NotificationRecord> onOverdue;
  List<NotificationRecord> onGraded;
  List<NotificationRecord> onCompleted;


  NotificationHistory({
    required this.taskId,
    this.onAssigned = const [],
    this.onStarted = const [],
    this.onOverdue = const [],
    this.onGraded = const [],
    this.onCompleted = const [],
  });

  factory NotificationHistory.fromJson(Map<String, dynamic> json) {
    return NotificationHistory(
      taskId: json['taskId'] as int,
      onAssigned: (json['onAssigned'] as List<dynamic>?)
          ?.map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      onStarted: (json['onStarted'] as List<dynamic>?)
          ?.map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      onOverdue: (json['onOverdue'] as List<dynamic>?)
          ?.map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      onGraded: (json['onGraded'] as List<dynamic>?)
          ?.map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      onCompleted: (json['onCompleted'] as List<dynamic>?)
          ?.map((e) => NotificationRecord.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'onAssigned': onAssigned.map((e) => e.toJson()).toList(),
      'onStarted': onStarted.map((e) => e.toJson()).toList(),
      'onOverdue': onOverdue.map((e) => e.toJson()).toList(),
      'onGraded': onGraded.map((e) => e.toJson()).toList(),
      'onCompleted': onCompleted.map((e) => e.toJson()).toList(),
    };
  }
}

class NotificationSetting {
  /// Notification method constants
  /// 10+ for custom methods
  static const int NONE = 0;
  static const int PUSH_NOTIFICATION = 1;
  static const int EMAIL = 2;
  static const int SMS = 3;
  static const int MQTT = 4;
  
  List<int>? onAssigned;
  List<int>? onStarted;
  List<int>? onOverdue;
  List<int>? onGraded;
  List<int>? onCompleted;

  NotificationSetting({
    this.onAssigned,
    this.onStarted,
    this.onOverdue,
    this.onGraded,
    this.onCompleted,
  });

  NotificationSetting.fromJson(Map<String, dynamic> json) {
    onOverdue = (json['onOverdue'] as List?)?.map((e) => e as int).toList();
    onAssigned = (json['onAssigned'] as List?)?.map((e) => e as int).toList();
    onCompleted = (json['onCompleted'] as List?)?.map((e) => e as int).toList();
    onStarted = (json['onStarted'] as List?)?.map((e) => e as int).toList();
    onGraded = (json['onGraded'] as List?)?.map((e) => e as int).toList();
  }
  Map<String, dynamic> toJson() {
    return {
      'onOverdue': onOverdue,
      'onAssigned': onAssigned,
      'onCompleted': onCompleted,
      'onStarted': onStarted,
      'onGraded': onGraded,
    };
  }
}