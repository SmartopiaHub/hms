// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/model/database.dart';
import 'package:smartopia_hms_server/mqtt.dart';
import 'package:smartopia_hms_server/notification.dart';
import 'package:smartopia_hms_shared/shared.dart';


final _timers = <int, Timer>{};

/// One StreamController per username
final _controllers = <String, StreamController<List<int>>>{};

StreamController<List<int>> _controllerFor(String user) {
  return _controllers.putIfAbsent(
    user,
    StreamController<List<int>>.broadcast,
  );
}

/// Called by your scheduler to push an event
void pushNotification(String user, Map<String, dynamic> data) {
  final ctrl = _controllerFor(user);
  if (!ctrl.isClosed) ctrl.add(encodeJsonToIntList(data));
}

/// Used by your SSE handler to get the stream
Stream<List<int>> notificationsFor(String user) {
  return _controllerFor(user).stream;
}

/// Creates a new task instance in the DB for [tpl] at [start], but only
/// if no task instance with the same templateId and startTime exists.
/// Runs the check+insert in a single transaction for atomicity.
Future<void> createTaskInstance(TaskTemplate tpl, DateTime start) async {
  // assume you have a top‐level `database` instance of AppDatabase
  final task = await database.transaction(() async {
    // 1) see if an instance already exists
    final existing = await (database.select(database.tasks)
          ..where((t) =>
            t.templateId.equals(tpl.id) &
            t.startTime.equals(start),
          ))
        .getSingleOrNull();

    // if it exists, do nothing
    if (existing != null) {
      logInfo(
        'createTaskInstance: Task instance already exists for template ${tpl.id} at $start',
      );
      return existing;
    }

    // 2) if not, insert a new row
    if (existing == null) {
      final companion = tpl.createTaskInstance(start).toCompanion(true).copyWith(id: const Value.absent());
      final taskId = await database.into(database.tasks).insert(companion);

      final task = await database.managers.tasks
          .filter((t) => t.id.equals(taskId))
          .getSingle();

      return task;
    }
  });

  if (task == null) {
    logError(
      'createTaskInstance: Failed to create task instance for template ${tpl.id} at $start',
    );
    return;
  }

  await notifyOnTaskStarted(task);
  await scheduleNotification(task);
}

/// Schedule the next “fire” for this template.
/// If called when one is already scheduled, it cancels the old one.
void scheduleNextInstance(TaskTemplate tpl) {
  // cancel previous if any
  _timers[tpl.id]?.cancel();
  final next = tpl.recurrence.next();
  if (next == null) return;

  var delay = next.difference(DateTime.now());
  if (delay.isNegative) {
    delay = const Duration(seconds: 1);
  }
  
  _timers[tpl.id] = Timer(delay, () async {
    try{
      // 1) Create a new task instance
      await createTaskInstance(tpl, next);

      // 2) Remove fired timer
      _timers.remove(tpl.id);

      // add an epsilon to avoid firing the same instance twice
      await Future<void>.delayed(const Duration(seconds: 1));

      // 3) Reschedule the following occurrence
      scheduleNextInstance(tpl);
    } catch (e, st) {
      logError(
        'scheduleNextInstance: Failed to create task instance for template ${tpl.id} (${tpl.title})',
        e,
        st,
      );
    }
  });
  logInfo(
        'scheduleNextInstance: Scheduled next instance for template ${tpl.id} (${tpl.title}) at $next',
  );
}

/// Cancels the scheduled instance for the given template ID.
void cancelScheduledInstance(int templateId) {
  // cancel the timer if it exists
  _timers.remove(templateId)?.cancel();
}

/// Call this on server startup to re‐hydrate any pending timers
Future<void> bootstrap() async {
  try{
    logInfo(
        'bootstrapping ... connecting to MQTT broker',
    );
    final mqttConfig = MqttService.instance.loadConfig();
    if (mqttConfig == null) {
      logError(
        'bootstrapping: Failed to load MQTT configuration',
      );
    }
    else {
      await MqttService.instance.connect(mqttConfig);
    }

    logInfo(
        'bootstrapping ... connected to MQTT broker',
    );

    // Schedule any pending task instances
    final all = await database.managers.taskTemplates
        .filter((t) => t.recurrence.isNotNull())
        .get();
    logInfo(
        'bootstrapping ... schedule next instances for ${all.length} task templates',
    );
    for (final tpl in all) {
      scheduleNextInstance(tpl);
    }

    logInfo(
      'bootstrapping ... completed',
    );
  } catch (e, st) {
    logError(
      'bootstrapping: Failed to bootstrap',
      e,
      st,
    );
  }
}
