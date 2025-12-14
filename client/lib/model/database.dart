// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:smartopia_hms_shared/shared.dart';

part 'database.g.dart';

/// A table to store user information
class Users extends Table {
  /// The unique identifier for the user
  IntColumn get id => integer().autoIncrement()();

  /// A unique username column with a length between 3 and 32 characters.
  TextColumn get username => text().withLength(min: 3, max: 32)();

  /// Nickname column with a length between 3 and 32 characters.
  TextColumn get nickname => text().withLength(min: 1, max: 32).nullable()();

  /// A password column with a suitable length (storing a hashed value).
  TextColumn get password => text().withLength(min: 8, max: 128)();

  /// A column to indicate if the user is a parent (true) or a child (false).
  BoolColumn get isParent => boolean().withDefault(const Constant(true))();

  /// A column to indicate if the user is allowed to manage their own homework.
  BoolColumn get allowSelfHomeworkManagement =>
      boolean().withDefault(const Constant(false))();

  /// User's notification settings
  TextColumn get notificationSettings =>
      text().map(notificationSettingConverter).nullable()();

  /// The ID of the point system selected by the user
  TextColumn get pointSystemId => text().nullable()();

  /// Total points accumulated by the user
  IntColumn get totalPoints => integer().withDefault(const Constant(0))();

  /// Total points redeemed by the user
  IntColumn get redeemedPoints => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {username},
  ];
}

/// A table to store task templates
class TaskTemplates extends Table {
  /// The unique identifier for the task template
  IntColumn get id => integer().autoIncrement()();

  /// The name of the task
  TextColumn get title => text().withLength(min: 1, max: 256)();

  /// The username of the creator
  TextColumn get creator => text().withLength(min: 1, max: 32)();

  /// The users associated with the task
  TextColumn get assignedUsers => text().map(stringListConverter)();

  /// The tags associated with the task
  TextColumn get tags => text().map(stringListConverter).nullable()();

  /// The priority of the task, represented as an integer, the higher the number, the higher the priority
  IntColumn get priority => integer().withDefault(const Constant(0))();

  /// the number of minutes before the task is due when the user should be reminded
  IntColumn get remind => integer().withDefault(const Constant(0))();

  /// The description of the task
  TextColumn get description => text().nullable()();

  /// How often the task should be repeated
  TextColumn get recurrence => text().map(recurrencePatternConverter)();

  /// Reward information (max points, description, etc.)
  TextColumn get rewards =>
      text().map(const RewardInfoConverter()).nullable()();

  /// Penalty for not completing the task
  TextColumn get penalty => text().nullable()();

  /// Requires an attachment to be submitted for this task or not
  BoolColumn get attachmentRequired =>
      boolean().withDefault(const Constant(false))();

  /// Requires the user to submit the task or not
  BoolColumn get submissionRequired =>
      boolean().withDefault(const Constant(true))();

  /// The time when the task was created
  DateTimeColumn get creationTime => dateTime()();

  /// The expected completion time duration in minutes for each of this task
  IntColumn get expectedCompletionTimeInMinutes =>
      integer().map(const DurationConverter())();

  /// Setting how to notify the user about this task when it is overdue or completed
  TextColumn get notificationSetting =>
      text().map(notificationSettingConverter).nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {id},
  ];
}

/// A table to store task instances
class Tasks extends Table {
  /// The unique identifier for the task instance
  IntColumn get id => integer().autoIncrement()();

  /// The unique identifier for the task template
  IntColumn get templateId => integer()();

  /// The title of the task instance, derived from the template
  TextColumn get title => text().withLength(min: 1, max: 256)();

  /// The description of the task instance, derived from the template
  TextColumn get description => text().nullable()();

  /// The tags associated with the task
  TextColumn get tags => text().map(stringListConverter).nullable()();

  /// the number of minutes before the task is due when the user should be reminded
  IntColumn get remind => integer().withDefault(const Constant(0))();

  /// The users associated with the task
  TextColumn get assignedUsers => text().map(stringListConverter)();

  /// Reward information (max points, description, etc.)
  TextColumn get rewards =>
      text().map(const RewardInfoConverter()).nullable()();

  /// Penalty for not completing the task
  TextColumn get penalty => text().nullable()();

  /// The start time of the task instance
  DateTimeColumn get startTime => dateTime()();

  /// The due time of the task instance,
  DateTimeColumn get dueTime => dateTime()();

  /// The expected completion time duration in minutes for each of this task
  IntColumn get expectedCompletionTimeInMinutes =>
      integer().map(const DurationConverter())();

  /// Setting how to notify the user about this task when it is overdue or completed
  TextColumn get notificationSetting =>
      text().map(notificationSettingConverter).nullable()();

  /// The notification history for the task instance
  TextColumn get notificationHistory =>
      text().map(notificationHistoryConverter).nullable()();

  /// The submitted files for the task instance
  TextColumn get submittedFiles => text().map(stringListConverter).nullable()();

  /// The time when the task instance was completed
  DateTimeColumn get completionTime => dateTime().nullable()();

  /// The time when the task instance was evaluated
  DateTimeColumn get evaluationTime => dateTime().nullable()();

  /// The username of evaluator of the task instance
  TextColumn get evaluator => text().withLength(min: 1, max: 32).nullable()();

  /// Indicates if the task instance requires an attachment to be submitted
  BoolColumn get attachmentRequired =>
      boolean().withDefault(const Constant(false))();

  /// Requires the user to submit the task or not
  BoolColumn get submissionRequired =>
      boolean().withDefault(const Constant(true))();

  /// Requires the user to submit the task or not
  BoolColumn get cancelled => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {id},
  ];
}

/// A table to store shop items
class ShopItems extends Table {
  /// The unique identifier for the shop item
  IntColumn get id => integer().autoIncrement()();

  /// The title of the item
  TextColumn get title => text().withLength(min: 1, max: 256)();

  /// The description of the item
  TextColumn get description => text().nullable()();

  /// The URL of the image
  TextColumn get imageUrl => text().nullable()();

  /// The cost of the item in points
  IntColumn get cost => integer()();

  /// Whether the item is available for redemption
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();

  /// The ID of the creator (parent)
  IntColumn get creatorId => integer()();
}

/// A table to store redemption history
class Redemptions extends Table {
  /// The unique identifier for the redemption
  IntColumn get id => integer().autoIncrement()();

  /// The ID of the user who redeemed the item
  IntColumn get userId => integer()();

  /// The title of the redeemed item (snapshot at redemption time)
  TextColumn get itemTitle => text()();

  /// The image URL of the redeemed item (snapshot at redemption time)
  TextColumn get itemImageUrl => text().nullable()();

  /// The cost of the item at the time of redemption
  IntColumn get cost => integer()();

  /// The date and time of redemption
  DateTimeColumn get redeemedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Database instance for the application
@DriftDatabase(tables: [Users, TaskTemplates, Tasks, ShopItems, Redemptions])
class AppDatabase extends _$AppDatabase {
  /// Constructor for the AppDatabase class
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // Specify the database schema version
  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the allowSelfHomeworkManagement column in the users table
          await m.addColumn(
            users,
            users.allowSelfHomeworkManagement as GeneratedColumn<Object>,
          );
        }
        if (from < 3) {
          // we added the notificationSettings column in the users table
          await m.addColumn(
            users,
            users.notificationSettings as GeneratedColumn<Object>,
          );
        }
        if (from < 4) {
          // we added the maxPoints column in the taskTemplates table
          // await m.addColumn(taskTemplates, taskTemplates.maxPoints as GeneratedColumn<Object>);
          // we added the pointSystemId column in the users table
          await m.addColumn(
            users,
            users.pointSystemId as GeneratedColumn<Object>,
          );
          // we added the maxPoints column in the tasks table
          // await m.addColumn(tasks, tasks.maxPoints as GeneratedColumn<Object>);
        }
        if (from < 5) {
          // we added the rewards column in the taskTemplates table
          await m.addColumn(
            taskTemplates,
            taskTemplates.rewards as GeneratedColumn<Object>,
          );
          // we added the rewards column in the tasks table
          await m.addColumn(tasks, tasks.rewards as GeneratedColumn<Object>);
        }
        if (from < 6) {
          // we added the totalPoints column in the users table
          await m.addColumn(
            users,
            users.totalPoints as GeneratedColumn<Object>,
          );
        }
        if (from < 7) {
          // we added the redeemedPoints column in the users table
          await m.addColumn(
            users,
            users.redeemedPoints as GeneratedColumn<Object>,
          );
          // we added the ShopItems table
          await m.createTable(shopItems);
        }
        if (from < 8) {
          // we added the Redemptions table
          await m.createTable(redemptions);
        }
        if (from < 9) {
          // Migration: Recreate Redemptions table with new schema
          // Drop old table and create new one with itemTitle and itemImageUrl
          await m.deleteTable('redemptions');
          await m.createTable(redemptions);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return NativeDatabase.createInBackground(File('./data/app.db'));
  }
}

AppDatabase _appDatabase = AppDatabase();

/// Function to get the database instance
AppDatabase get database => _appDatabase;

extension TaskTemplateExtension on TaskTemplate {
  /// Returns the due duration for the task template.
  Duration get dueDuration {
    if (recurrence.duration != null) {
      return recurrence.duration!;
    } else {
      return expectedCompletionTimeInMinutes; // Default duration if not specified
    }
  }

  Task createTaskInstance(DateTime start, {bool cancelled = false}) {
    // Create a new task instance based on this template
    return Task(
      id: 0, // ID will be auto-incremented by the database
      templateId: id,
      title: title,
      description: description,
      tags: tags,
      assignedUsers: assignedUsers,
      startTime: start,
      dueTime: start.add(dueDuration),
      expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes,
      remind: remind,
      rewards: rewards,
      penalty: penalty,
      attachmentRequired: attachmentRequired,
      submissionRequired: submissionRequired,
      notificationSetting: notificationSetting,
      cancelled: cancelled,
    );
  }
}

enum TaskStatus {
  /// Task is not started yet
  notStarted,

  /// Task is in progress
  inProgress,

  /// Task is completed/submitted
  completed,

  /// Task is overdue and not completed yet
  overdue,

  /// Task is graded
  graded,

  /// Cancelled task
  cancelled,
}

extension TaskExtension on Task {
  /// Return the status of the task based on its properties
  TaskStatus get status {
    // Check if the task is cancelled
    if (cancelled) {
      return TaskStatus.cancelled;
    }

    if (!isStarted) {
      return TaskStatus.notStarted;
    } else if (isCompleted) {
      return isGraded ? TaskStatus.graded : TaskStatus.completed;
    } else if (isOverdue) {
      return TaskStatus.overdue;
    } else {
      return TaskStatus.inProgress;
    }
  }

  /// Return whether the task is started or not
  bool get isStarted {
    final now = DateTime.now();
    return !startTime.isAfter(now);
  }

  /// Return whether the task is completed/submitted or not
  bool get isCompleted {
    return completionTime != null;
  }

  /// Return whether the task is not completed yet and is overdue or not
  bool get isOverdue {
    return !isCompleted && dueTime.isBefore(DateTime.now());
  }

  /// Return whether the task is graded or not
  bool get isGraded {
    return rewards?.pointsAwarded != null;
  }
}

class RewardInfoConverter extends TypeConverter<RewardInfo, String> {
  const RewardInfoConverter();

  @override
  RewardInfo fromSql(String fromDb) {
    return RewardInfo.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(RewardInfo value) {
    return json.encode(value.toJson());
  }
}

/// Extension to get reward point information from User
extension RewardPointInfoExtension on User {
  /// Get the reward point information for the user
  RewardPointInfo get rewardPointInfo {
    return RewardPointInfo(
      totalPoints: totalPoints,
      redeemedPoints: redeemedPoints,
    );
  }

  /// Get available points
  int get availablePoints {
    return totalPoints - redeemedPoints;
  }
}
