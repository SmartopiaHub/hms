// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:drift/drift.dart';
import 'package:smartopia_hms_shared/shared.dart';

class User {
  /// The unique identifier for the user
  final int id;

  /// A unique username column with a length between 3 and 32 characters.
  final String username;

  /// Nickname column with a length between 3 and 32 characters.
  final String? nickname;

  /// A password column with a suitable length (storing a hashed value).
  final String password;

  /// A column to indicate if the user is a parent (true) or a child (false).
  final bool isParent;

  /// A column to indicate if the user is allowed to manage their own homework.
  final bool allowSelfHomeworkManagement;

  /// The ID of the point system selected by the user
  final String? pointSystemId;

  /// Total points for the user (only relevant for children)
  final int? totalPoints;

  /// Redeemed points for the user (only relevant for children)
  final int? redeemedPoints;

  int get availablePoints {
    if (totalPoints == null) {
      return 0;
    }
    return totalPoints! - (redeemedPoints ?? 0);
  }

  const User(
      {required this.id,
      required this.username,
      this.nickname,
      required this.password,
      required this.isParent,
      this.allowSelfHomeworkManagement = false,
      this.pointSystemId,
      this.redeemedPoints,
      this.totalPoints});
  
  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      password: serializer.fromJson<String>(json['password']),
      isParent: serializer.fromJson<bool>(json['isParent']),
      allowSelfHomeworkManagement: serializer.fromJson<bool>(json['allowSelfHomeworkManagement'] ?? false),
      pointSystemId: serializer.fromJson<String?>(json['pointSystemId']),
      totalPoints: json.containsKey('totalPoints') ? serializer.fromJson<int?>(json['totalPoints']) : null,
      redeemedPoints: json.containsKey('redeemedPoints') ? serializer.fromJson<int?>(json['redeemedPoints']) : null,
    );
  }
  
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'nickname': serializer.toJson<String?>(nickname),
      'password': serializer.toJson<String>(password),
      'isParent': serializer.toJson<bool>(isParent),
      'allowSelfHomeworkManagement': serializer.toJson<bool>(allowSelfHomeworkManagement),
      'pointSystemId': serializer.toJson<String?>(pointSystemId),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          String? nickname,
          String? password,
          bool? isParent,
          bool? allowSelfHomeworkManagement,
          String? pointSystemId}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        nickname: nickname ?? this.nickname,
        password: password ?? this.password,
        isParent: isParent ?? this.isParent,
        allowSelfHomeworkManagement: allowSelfHomeworkManagement ?? this.allowSelfHomeworkManagement,
        pointSystemId: pointSystemId ?? this.pointSystemId,
      );
  

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('nickname: $nickname, ')
          ..write('password: $password, ')
          ..write('isParent: $isParent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, nickname, password, isParent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.nickname == this.nickname &&
          other.password == this.password &&
          other.isParent == this.isParent);
}

class TaskTemplate {
  /// The unique identifier for the task template
  final int id;

  /// The name of the task
  final String title;

  /// The username of the creator
  final String creator;

  /// The users associated with the task
  final List<String> assignedUsers;

  /// The tags associated with the task
  final List<String>? tags;

  /// The priority of the task, represented as an integer, the higher the number, the higher the priority
  final int priority;

  /// the number of minutes before the task is due when the user should be reminded
  final int remind;

  /// The description of the task
  final String? description;

  /// How often the task should be repeated
  final RecurrencePattern recurrence;

  /// Reward information
  final RewardInfo? rewards;

  /// Penalty for not completing the task
  final String? penalty;

  /// Requires an attachment to be submitted for this task or not
  final bool attachmentRequired;

  /// Requires the user to submit the task or not
  final bool submissionRequired;

  /// The time when the task was created
  final DateTime creationTime;

  /// The expected completion time duration in minutes for each of this task
  final Duration expectedCompletionTimeInMinutes;

  /// Setting how to notify the user about this task when it is overdue or completed
  final NotificationSetting? notificationSetting;

  const TaskTemplate(
      {required this.id,
      required this.title,
      required this.creator,
      required this.assignedUsers,
      this.tags,
      required this.priority,
      required this.remind,
      this.description,
      required this.recurrence,
      this.rewards,
      this.penalty,
      required this.attachmentRequired,
      required this.submissionRequired,
      required this.creationTime,
      required this.expectedCompletionTimeInMinutes,
      this.notificationSetting});
  
  factory TaskTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTemplate(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      creator: serializer.fromJson<String>(json['creator']),
      assignedUsers: stringListConverter
          .fromJson(serializer.fromJson<Object?>(json['assignedUsers'])),
      tags: json['tags'] == null ? null : stringListConverter.fromJson(serializer.fromJson<Object?>(json['tags'])),
      priority: serializer.fromJson<int>(json['priority']),
      remind: serializer.fromJson<int>(json['remind']),
      description: serializer.fromJson<String?>(json['description']),
      recurrence: recurrencePatternConverter
          .fromJson(serializer.fromJson<Object?>(json['recurrence'])),
      rewards: json['rewards'] == null ? null : RewardInfo.fromJson(json['rewards']),
      penalty: serializer.fromJson<String?>(json['penalty']),
      attachmentRequired: serializer.fromJson<bool>(json['attachmentRequired']),
      submissionRequired: serializer.fromJson<bool>(json['submissionRequired']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      expectedCompletionTimeInMinutes: DurationConverter()
          .fromJson(serializer
              .fromJson<Object?>(json['expectedCompletionTimeInMinutes'])),
      notificationSetting: json['notificationSetting'] == null ? null : notificationSettingConverter
          .fromJson(serializer.fromJson<Object?>(json['notificationSetting'])),
    );
  }
  
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'creator': serializer.toJson<String>(creator),
      'assignedUsers': serializer.toJson<Object?>(
          stringListConverter.toJson(assignedUsers)),
      'tags': tags == null ? null : serializer
          .toJson<Object?>(stringListConverter.toJson(tags!)),
      'priority': serializer.toJson<int>(priority),
      'remind': serializer.toJson<int>(remind),
      'description': serializer.toJson<String?>(description),
      'recurrence': serializer.toJson<Object?>(
          recurrencePatternConverter.toJson(recurrence)),
      'rewards': rewards?.toJson(),
      'penalty': serializer.toJson<String?>(penalty),
      'attachmentRequired': serializer.toJson<bool>(attachmentRequired),
      'submissionRequired': serializer.toJson<bool>(submissionRequired),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'expectedCompletionTimeInMinutes': serializer.toJson<Object?>(
          DurationConverter().toJson(expectedCompletionTimeInMinutes)),
      'notificationSetting': notificationSetting == null ? null : serializer.toJson<Object?>(
          notificationSettingConverter.toJson(notificationSetting!)),
    };
  }

  TaskTemplate copyWith(
          {int? id,
          String? title,
          String? creator,
          List<String>? assignedUsers,
          Value<List<String>?> tags = const Value.absent(),
          int? priority,
          int? remind,
          Value<String?> description = const Value.absent(),
          RecurrencePattern? recurrence,
          Value<RewardInfo?> rewards = const Value.absent(),
          Value<String?> penalty = const Value.absent(),
          bool? attachmentRequired,
          bool? submissionRequired,
          DateTime? creationTime,
          Duration? expectedCompletionTimeInMinutes,
          Value<NotificationSetting?> notificationSetting =
              const Value.absent()}) =>
      TaskTemplate(
        id: id ?? this.id,
        title: title ?? this.title,
        creator: creator ?? this.creator,
        assignedUsers: assignedUsers ?? this.assignedUsers,
        tags: tags.present ? tags.value : this.tags,
        priority: priority ?? this.priority,
        remind: remind ?? this.remind,
        description: description.present ? description.value : this.description,
        recurrence: recurrence ?? this.recurrence,
        rewards: rewards.present ? rewards.value : this.rewards,
        penalty: penalty.present ? penalty.value : this.penalty,
        attachmentRequired: attachmentRequired ?? this.attachmentRequired,
        submissionRequired: submissionRequired ?? this.submissionRequired,
        creationTime: creationTime ?? this.creationTime,
        expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes ??
            this.expectedCompletionTimeInMinutes,
        notificationSetting: notificationSetting.present
            ? notificationSetting.value
            : this.notificationSetting,
      );
  

  @override
  String toString() {
    return (StringBuffer('TaskTemplate(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('creator: $creator, ')
          ..write('assignedUsers: $assignedUsers, ')
          ..write('tags: $tags, ')
          ..write('priority: $priority, ')
          ..write('remind: $remind, ')
          ..write('description: $description, ')
          ..write('recurrence: $recurrence, ')
          ..write('rewards: $rewards, ')
          ..write('penalty: $penalty, ')
          ..write('attachmentRequired: $attachmentRequired, ')
          ..write('submissionRequired: $submissionRequired, ')
          ..write('creationTime: $creationTime, ')
          ..write(
              'expectedCompletionTimeInMinutes: $expectedCompletionTimeInMinutes, ')
          ..write('notificationSetting: $notificationSetting')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      title,
      creator,
      assignedUsers,
      tags,
      priority,
      remind,
      description,
      recurrence,
      rewards,
      penalty,
      attachmentRequired,
      submissionRequired,
      creationTime,
      expectedCompletionTimeInMinutes,
      notificationSetting);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskTemplate &&
          other.id == this.id &&
          other.title == this.title &&
          other.creator == this.creator &&
          other.assignedUsers == this.assignedUsers &&
          other.tags == this.tags &&
          other.priority == this.priority &&
          other.remind == this.remind &&
          other.description == this.description &&
          other.recurrence == this.recurrence &&
          other.rewards == this.rewards &&
          other.penalty == this.penalty &&
          other.attachmentRequired == this.attachmentRequired &&
          other.submissionRequired == this.submissionRequired &&
          other.creationTime == this.creationTime &&
          other.expectedCompletionTimeInMinutes ==
              this.expectedCompletionTimeInMinutes &&
          other.notificationSetting == this.notificationSetting);
}

class Task {
  /// The unique identifier for the task instance
  final int id;

  /// The unique identifier for the task template
  final int templateId;

  /// The title of the task instance, derived from the template
  final String title;

  /// The description of the task instance, derived from the template
  final String? description;

  /// The tags associated with the task
  final List<String>? tags;

  /// the number of minutes before the task is due when the user should be reminded
  final int remind;

  /// The users associated with the task
  final List<String> assignedUsers;

  /// Reward information
  final RewardInfo? rewards;

  /// Penalty for not completing the task
  final String? penalty;

  /// The start time of the task instance
  final DateTime startTime;

  /// The due time of the task instance,
  final DateTime dueTime;

  /// The expected completion time duration in minutes for each of this task
  final Duration expectedCompletionTimeInMinutes;

  /// Setting how to notify the user about this task when it is overdue or completed
  final NotificationSetting? notificationSetting;

  /// The notification history for the task instance
  final NotificationHistory? notificationHistory;

  /// The submitted files for the task instance
  final List<String>? submittedFiles;

  /// The time when the task instance was completed
  final DateTime? completionTime;

  /// The time when the task instance was evaluated
  final DateTime? evaluationTime;

  /// The username of evaluator of the task instance
  final String? evaluator;

  /// Indicates if the task instance requires an attachment to be submitted
  final bool attachmentRequired;

  /// Indicates if the task instance is cancelled or not
  final bool cancelled;

  /// Requires the user to submit the task or not
  final bool submissionRequired;
  const Task(
      {required this.id,
      required this.templateId,
      // below are from task template
      required this.title,
      this.description,
      this.tags,
      required this.remind,
      required this.assignedUsers,
      this.rewards,
      this.penalty,
      required this.startTime,
      required this.expectedCompletionTimeInMinutes,
      this.notificationSetting,
      // below are specific to task instance
      required this.dueTime,
      this.notificationHistory,
      this.submittedFiles,
      this.completionTime,
      this.evaluationTime,
      this.evaluator,
      this.cancelled = false,
      required this.attachmentRequired,
      required this.submissionRequired});
  
  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      tags: json['tags'] == null
          ? null: stringListConverter
          .fromJson(serializer.fromJson<Object?>(json['tags'])),
      remind: serializer.fromJson<int>(json['remind']),
      assignedUsers: stringListConverter
          .fromJson(serializer.fromJson<Object?>(json['assignedUsers'])),
      rewards: json['rewards'] == null ? null : RewardInfo.fromJson(json['rewards']),
      penalty: serializer.fromJson<String?>(json['penalty']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      dueTime: serializer.fromJson<DateTime>(json['dueTime']),
      expectedCompletionTimeInMinutes: DurationConverter()
          .fromJson(serializer
              .fromJson<Object?>(json['expectedCompletionTimeInMinutes'])),
      notificationSetting: json['notificationSetting'] == null ? null : notificationSettingConverter
          .fromJson(serializer.fromJson<Object?>(json['notificationSetting'])),
      notificationHistory: json['notificationHistory'] == null ? null : notificationHistoryConverter
          .fromJson(serializer.fromJson<Object?>(json['notificationHistory'])),
      submittedFiles: json['submittedFiles'] == null
          ? null : stringListConverter
          .fromJson(serializer.fromJson<Object?>(json['submittedFiles'])),
      completionTime: serializer.fromJson<DateTime?>(json['completionTime']),
      evaluationTime: serializer.fromJson<DateTime?>(json['evaluationTime']),
      evaluator: serializer.fromJson<String?>(json['evaluator']),
      attachmentRequired: serializer.fromJson<bool>(json['attachmentRequired']),
      submissionRequired: serializer.fromJson<bool>(json['submissionRequired']),
      cancelled: serializer.fromJson<bool>(json['cancelled'] ?? false),
    );
  }
  
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'tags': tags == null
          ? null :
          serializer.toJson<Object?>(stringListConverter.toJson(tags!)),
      'remind': serializer.toJson<int>(remind),
      'assignedUsers': serializer.toJson<Object?>(
          stringListConverter.toJson(assignedUsers)),
      'rewards': rewards?.toJson(),
      'penalty': serializer.toJson<String?>(penalty),
      'startTime': serializer.toJson<DateTime>(startTime),
      'dueTime': serializer.toJson<DateTime>(dueTime),
      'expectedCompletionTimeInMinutes': serializer.toJson<Object?>(DurationConverter()
          .toJson(expectedCompletionTimeInMinutes)),
      'notificationSetting': notificationSetting == null ? null : serializer.toJson<Object?>(
          notificationSettingConverter
          .toJson(notificationSetting!)),
      'notificationHistory': notificationHistory == null ? null : serializer.toJson<Object?>(
          notificationHistoryConverter
          .toJson(notificationHistory!)),
      'submittedFiles': submittedFiles == null ? null : serializer.toJson<Object?>(
          stringListConverter.toJson(submittedFiles!)),
      'completionTime': serializer.toJson<DateTime?>(completionTime),
      'evaluationTime': serializer.toJson<DateTime?>(evaluationTime),
      'evaluator': serializer.toJson<String?>(evaluator),
      'attachmentRequired': serializer.toJson<bool>(attachmentRequired),
      'submissionRequired': serializer.toJson<bool>(submissionRequired),
      'cancelled': serializer.toJson<bool>(cancelled),
    };
  }

  Task copyWith(
          {int? id,
          int? templateId,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<List<String>?> tags = const Value.absent(),
          int? remind,
          List<String>? assignedUsers,
          Value<RewardInfo?> rewards = const Value.absent(),
          Value<String?> penalty = const Value.absent(),
          DateTime? startTime,
          DateTime? dueTime,
          Duration? expectedCompletionTimeInMinutes,
          Value<NotificationSetting?> notificationSetting =
              const Value.absent(),
          Value<NotificationHistory?> notificationHistory =
              const Value.absent(),
          Value<List<String>?> submittedFiles = const Value.absent(),
          Value<DateTime?> completionTime = const Value.absent(),
          Value<DateTime?> evaluationTime = const Value.absent(),
          Value<String?> evaluator = const Value.absent(),
          bool? attachmentRequired,
          bool? cancelled,
          bool? submissionRequired}) =>
      Task(
        id: id ?? this.id,
        templateId: templateId ?? this.templateId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        tags: tags.present ? tags.value : this.tags,
        remind: remind ?? this.remind,
        assignedUsers: assignedUsers ?? this.assignedUsers,
        rewards: rewards.present ? rewards.value : this.rewards,
        penalty: penalty.present ? penalty.value : this.penalty,
        startTime: startTime ?? this.startTime,
        dueTime: dueTime ?? this.dueTime,
        expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes ??
            this.expectedCompletionTimeInMinutes,
        notificationSetting: notificationSetting.present
            ? notificationSetting.value
            : this.notificationSetting,
        notificationHistory: notificationHistory.present
            ? notificationHistory.value
            : this.notificationHistory,
        submittedFiles:
            submittedFiles.present ? submittedFiles.value : this.submittedFiles,
        completionTime:
            completionTime.present ? completionTime.value : this.completionTime,
        evaluationTime:
            evaluationTime.present ? evaluationTime.value : this.evaluationTime,
        evaluator: evaluator.present ? evaluator.value : this.evaluator,
        attachmentRequired: attachmentRequired ?? this.attachmentRequired,
        submissionRequired: submissionRequired ?? this.submissionRequired,
        cancelled: cancelled ?? this.cancelled,
      );
  

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('tags: $tags, ')
          ..write('remind: $remind, ')
          ..write('assignedUsers: $assignedUsers, ')
          ..write('rewards: $rewards, ')
          ..write('penalty: $penalty, ')
          ..write('startTime: $startTime, ')
          ..write('dueTime: $dueTime, ')
          ..write(
              'expectedCompletionTimeInMinutes: $expectedCompletionTimeInMinutes, ')
          ..write('notificationSetting: $notificationSetting, ')
          ..write('notificationHistory: $notificationHistory, ')
          ..write('submittedFiles: $submittedFiles, ')
          ..write('completionTime: $completionTime, ')
          ..write('evaluationTime: $evaluationTime, ')
          ..write('evaluator: $evaluator, ')
          ..write('attachmentRequired: $attachmentRequired, ')
          ..write('submissionRequired: $submissionRequired')
          ..write('cancelled: $cancelled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        templateId,
        title,
        description,
        tags,
        remind,
        assignedUsers,
        rewards,
        penalty,
        startTime,
        dueTime,
        expectedCompletionTimeInMinutes,
        notificationSetting,
        notificationHistory,
        submittedFiles,
        completionTime,
        evaluationTime,
        evaluator,
        attachmentRequired,
        submissionRequired,
        cancelled,
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.title == this.title &&
          other.description == this.description &&
          other.tags == this.tags &&
          other.remind == this.remind &&
          other.assignedUsers == this.assignedUsers &&
          other.rewards == this.rewards &&
          other.penalty == this.penalty &&
          other.startTime == this.startTime &&
          other.dueTime == this.dueTime &&
          other.expectedCompletionTimeInMinutes ==
              this.expectedCompletionTimeInMinutes &&
          other.notificationSetting == this.notificationSetting &&
          other.notificationHistory == this.notificationHistory &&
          other.submittedFiles == this.submittedFiles &&
          other.completionTime == this.completionTime &&
          other.evaluationTime == this.evaluationTime &&
          other.evaluator == this.evaluator &&
          other.attachmentRequired == this.attachmentRequired &&
          other.submissionRequired == this.submissionRequired &&
          other.cancelled == this.cancelled);
}



extension TaskTemplateExtension on TaskTemplate {
  /// Returns the due duration for the task template.
  Duration get dueDuration{
    if (recurrence.duration != null) {
      return recurrence.duration!;
    } else {
      return expectedCompletionTimeInMinutes; // Default duration if not specified
    }
  }

  Task? createTaskInstance(DateTime start, {bool cancelled = false}) {
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
      cancelled: cancelled
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

  /// Task is cancelled
  cancelled,
}

extension TaskExtension on Task {

  /// Return the status of the task based on its properties
  TaskStatus get status {
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
