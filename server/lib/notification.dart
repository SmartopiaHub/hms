// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:async';

import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/mqtt.dart';
import 'package:smartopia_hms_server/scheduler.dart';
import 'package:smartopia_hms_shared/shared.dart';

/// Defines a notification structure
class Notification{

  /// Creates a new notification
  Notification({
    required this.type,
    required this.title,
    this.topic,
    this.body,
    this.ttsText,
  });

  /// Creates a Notification from a JSON map
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      type: json['type'] as String,
      title: json['title'] as String,
      topic: json['topic'] as String?,
      body: json['body'] as String?,
      ttsText: json['ttsText'] as String?,
    );
  }

  /// The topic to which this notification belongs, e.g., 'hms/task'
  /// If null, the notification is not topic-specific.
  final String? topic;

  /// The title of the notification, e.g., 'New Task: Task Title'
  final String title;

  /// The type of the notification, e.g., 'task_assigned', 'task_overdue'
  final String type;

  /// The body of the notification, e.g., 'Task Title, Time: 2023-10-01 10:00:00, please handle it promptly.'
  final String? body;

  /// The text to be used for text-to-speech (TTS) notifications.
  /// This can be used for voice notifications, e.g., 'You have a new learning task: Task Title, please start learning.'
  final String? ttsText;

  /// Converts the Notification to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'topic': topic,
      'body': body,
      'ttsText': ttsText,
    };
  }

}


/// An abstract class for sending notifications
abstract class Notifier {
  
  /// Sends a notification.
  /// The [notification] parameter contains the details of the notification to be sent. 
  Future<void> notify(Notification notification);
}

void _notify(Notification n, List<int>? notificationMethods, {List<Object>? receivers}) {
  if (notificationMethods == null || notificationMethods.isEmpty) {
    return;
  }

  if (notificationMethods.contains(NotificationSetting.PUSH_NOTIFICATION)) {
      if (receivers != null && receivers.isNotEmpty) {
        for (final receiver in receivers) {
          pushNotification(receiver.toString(), n.toJson());
        }
      }
  }

  if (notificationMethods.contains(NotificationSetting.MQTT)) {
    MqttNotifier().notify(n);
  }
}

/// Get all users who are parents
Future<List<User>> get parents {
  return database.managers.users
      .filter((u) => u.isParent.equals(true))
      .get();
}

/// Notify parents when a task is completed
Future<void> notifyOnTaskCompleted(Task task, User completedBy) async {
  final parentsList = await parents;
  for (final parent in parentsList) {
    final settings = parent.notificationSettings;
    if (settings != null) {
      final methods = settings.onCompleted;
      if (methods != null && methods.isNotEmpty) {
        final n =  Notification(
            type: 'task',
            title: 'Task Completed', 
            topic: 'hms/task',
            body: 'Task "${task.title}" has been completed by ${completedBy.username}.',
            ttsText: 'Task "${task.title}" has been completed by ${completedBy.username}.'
          );
        _notify(n, methods, receivers: [parent.id]);
      }
    }
  }
}

/// Notify assigned users when a task is overdue
Future<void> notifyOnTaskOverdue(Task task) async {
    for (final userIdStr in task.assignedUsers) {
        final userId = int.tryParse(userIdStr);
        if (userId == null) continue;
        
        final user = await database.managers.users.filter((u) => u.id.equals(userId)).getSingleOrNull();
        if (user == null) continue;

        final settings = user.notificationSettings;
        if (settings != null) {
            final methods = settings.onOverdue;
             if (methods != null && methods.isNotEmpty) {
                final n = Notification(
                    type: 'task',
                    title: 'Task Overdue',
                    topic: 'hms/task',
                    body: 'Task "${task.title}" is overdue.',
                    ttsText: 'Task "${task.title}" is overdue.',
                );
                _notify(n, methods, receivers: [user.id]);
             }
        }
    }
}

/// Notify assigned users when a task is started
Future<void> notifyOnTaskStarted(Task task) async {
    // Notify parents? Or assigned users?
    // Usually parents want to know when task started.
    // TODO: Make this configurable? Consider different families so only notify certain parents.
    final parentsList = await parents;
    for (final parent in parentsList) {
        final settings = parent.notificationSettings;
        if (settings != null) {
            final methods = settings.onStarted;
            if (methods != null && methods.isNotEmpty) {
                final n = Notification(
                    type: 'task',
                    title: 'Task Started',
                    topic: 'hms/task',
                    body: 'Task "${task.title}" has been started.',
                    ttsText: 'Task "${task.title}" has been started.',
                );
                _notify(n, methods, receivers: [parent.id]);
            }
        }
    }
}

/// Notify assigned users when a task is assigned to them
Future<void> notifyOnTaskAssigned(TaskTemplate tpl) async {
    for (final userIdStr in tpl.assignedUsers) {
        final userId = int.tryParse(userIdStr);
        if (userId == null) continue;
        
        final user = await database.managers.users.filter((u) => u.id.equals(userId)).getSingleOrNull();
        if (user == null) continue;

        final settings = user.notificationSettings;
        if (settings != null) {
            final methods = settings.onAssigned;
             if (methods != null && methods.isNotEmpty) {
                final n = Notification(
                    type: 'task',
                    title: 'New Task Assigned',
                    topic: 'hms/task',
                    body: 'You have been assigned a new task: ${tpl.title}',
                    ttsText: 'You have been assigned a new task: ${tpl.title}',
                );
                _notify(n, methods, receivers: [user.id]);
             }
        }
    }
}

/// Notify assigned users when a task is graded
Future<void> notifyOnTaskGraded(Task task) async {
    for (final userIdStr in task.assignedUsers) {
        final userId = int.tryParse(userIdStr);
        if (userId == null) continue;
        
        final user = await database.managers.users.filter((u) => u.id.equals(userId)).getSingleOrNull();
        if (user == null) continue;

        final settings = user.notificationSettings;
        if (settings != null) {
            final methods = settings.onGraded;
             if (methods != null && methods.isNotEmpty) {
                final n = Notification(
                    type: 'task',
                    title: 'Task Graded',
                    topic: 'hms/task',
                    body: 'Task "${task.title}" has been graded.',
                    ttsText: 'Task "${task.title}" has been graded.',
                );
                _notify(n, methods, receivers: [user.id]);
             }
        }
    }
}

// Task ID and the timer for its notification
final Map<int, Timer> _notificationTimers = {};

void _scheduleNotification(Task task,  Duration delay, VoidCallback callback,) {
  _notificationTimers[task.id] = Timer(delay, () async {
    try {
      callback(); // Execute the callback function
      await Future<void>.delayed(const Duration(seconds: 1)); // Add a small delay to avoid firing the same instance twice
      await scheduleNotification(task); // Reschedule the notification
    } catch (e, st) {
      logError(
        'Failed to schedule notification for task ${task.id} (${task.title})',
        e,
        st,
      );
    }
  });
}

typedef VoidCallback = void Function();

/// Schedules a notification for a task.
Future<void> scheduleNotification(Task task) async {
  _notificationTimers[task.id]?.cancel(); // Cancel any existing timer

  final now = DateTime.now();
  const epsilon = Duration(seconds: 1); // Add a small epsilon to avoid firing the same instance twice

  // notify on task started
  if (!task.isStarted){
    var delay = task.startTime.difference(now);
    if (delay.isNegative) {
      delay = epsilon; // If the task start time is in the past, set delay to zero
    }

    // Always schedule, check settings in callback
    _scheduleNotification(task, delay, () {
      notifyOnTaskStarted(task);
    });
    logInfo('Scheduled notification on task started: ${task.title} at ${task.startTime}');
    return;
  }

  // notify on task overdue
  if (!task.isCompleted && !task.isOverdue) {
    final delay = task.dueTime.difference(now);
    if (!delay.isNegative) {
      _scheduleNotification(task, delay, () {
        notifyOnTaskOverdue(task);
      });
      logInfo('Scheduled notification on task overdue: ${task.title} at ${task.dueTime}');
      return;
    }
  }
}