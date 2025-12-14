// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 3, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nicknameMeta =
      const VerificationMeta('nickname');
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
      'nickname', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isParentMeta =
      const VerificationMeta('isParent');
  @override
  late final GeneratedColumn<bool> isParent = GeneratedColumn<bool>(
      'is_parent', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_parent" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _allowSelfHomeworkManagementMeta =
      const VerificationMeta('allowSelfHomeworkManagement');
  @override
  late final GeneratedColumn<bool> allowSelfHomeworkManagement =
      GeneratedColumn<bool>(
          'allow_self_homework_management', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("allow_self_homework_management" IN (0, 1))'),
          defaultValue: const Constant(false));
  @override
  late final GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      notificationSettings = GeneratedColumn<String>(
              'notification_settings', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<NotificationSetting?>(
              $UsersTable.$converternotificationSettingsn);
  static const VerificationMeta _pointSystemIdMeta =
      const VerificationMeta('pointSystemId');
  @override
  late final GeneratedColumn<String> pointSystemId = GeneratedColumn<String>(
      'point_system_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalPointsMeta =
      const VerificationMeta('totalPoints');
  @override
  late final GeneratedColumn<int> totalPoints = GeneratedColumn<int>(
      'total_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _redeemedPointsMeta =
      const VerificationMeta('redeemedPoints');
  @override
  late final GeneratedColumn<int> redeemedPoints = GeneratedColumn<int>(
      'redeemed_points', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        nickname,
        password,
        isParent,
        allowSelfHomeworkManagement,
        notificationSettings,
        pointSystemId,
        totalPoints,
        redeemedPoints
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('nickname')) {
      context.handle(_nicknameMeta,
          nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('is_parent')) {
      context.handle(_isParentMeta,
          isParent.isAcceptableOrUnknown(data['is_parent']!, _isParentMeta));
    }
    if (data.containsKey('allow_self_homework_management')) {
      context.handle(
          _allowSelfHomeworkManagementMeta,
          allowSelfHomeworkManagement.isAcceptableOrUnknown(
              data['allow_self_homework_management']!,
              _allowSelfHomeworkManagementMeta));
    }
    if (data.containsKey('point_system_id')) {
      context.handle(
          _pointSystemIdMeta,
          pointSystemId.isAcceptableOrUnknown(
              data['point_system_id']!, _pointSystemIdMeta));
    }
    if (data.containsKey('total_points')) {
      context.handle(
          _totalPointsMeta,
          totalPoints.isAcceptableOrUnknown(
              data['total_points']!, _totalPointsMeta));
    }
    if (data.containsKey('redeemed_points')) {
      context.handle(
          _redeemedPointsMeta,
          redeemedPoints.isAcceptableOrUnknown(
              data['redeemed_points']!, _redeemedPointsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {username},
      ];
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      nickname: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nickname']),
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      isParent: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_parent'])!,
      allowSelfHomeworkManagement: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}allow_self_homework_management'])!,
      notificationSettings: $UsersTable.$converternotificationSettingsn.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}notification_settings'])),
      pointSystemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}point_system_id']),
      totalPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_points'])!,
      redeemedPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}redeemed_points'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationSetting, String, Object?>
      $converternotificationSettings = notificationSettingConverter;
  static JsonTypeConverter2<NotificationSetting?, String?, Object?>
      $converternotificationSettingsn =
      JsonTypeConverter2.asNullable($converternotificationSettings);
}

class User extends DataClass implements Insertable<User> {
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

  /// User's notification settings
  final NotificationSetting? notificationSettings;

  /// The ID of the point system selected by the user
  final String? pointSystemId;

  /// Total points accumulated by the user
  final int totalPoints;

  /// Total points redeemed by the user
  final int redeemedPoints;
  const User(
      {required this.id,
      required this.username,
      this.nickname,
      required this.password,
      required this.isParent,
      required this.allowSelfHomeworkManagement,
      this.notificationSettings,
      this.pointSystemId,
      required this.totalPoints,
      required this.redeemedPoints});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    map['password'] = Variable<String>(password);
    map['is_parent'] = Variable<bool>(isParent);
    map['allow_self_homework_management'] =
        Variable<bool>(allowSelfHomeworkManagement);
    if (!nullToAbsent || notificationSettings != null) {
      map['notification_settings'] = Variable<String>($UsersTable
          .$converternotificationSettingsn
          .toSql(notificationSettings));
    }
    if (!nullToAbsent || pointSystemId != null) {
      map['point_system_id'] = Variable<String>(pointSystemId);
    }
    map['total_points'] = Variable<int>(totalPoints);
    map['redeemed_points'] = Variable<int>(redeemedPoints);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      password: Value(password),
      isParent: Value(isParent),
      allowSelfHomeworkManagement: Value(allowSelfHomeworkManagement),
      notificationSettings: notificationSettings == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationSettings),
      pointSystemId: pointSystemId == null && nullToAbsent
          ? const Value.absent()
          : Value(pointSystemId),
      totalPoints: Value(totalPoints),
      redeemedPoints: Value(redeemedPoints),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      password: serializer.fromJson<String>(json['password']),
      isParent: serializer.fromJson<bool>(json['isParent']),
      allowSelfHomeworkManagement:
          serializer.fromJson<bool>(json['allowSelfHomeworkManagement']),
      notificationSettings: $UsersTable.$converternotificationSettingsn
          .fromJson(serializer.fromJson<Object?>(json['notificationSettings'])),
      pointSystemId: serializer.fromJson<String?>(json['pointSystemId']),
      totalPoints: serializer.fromJson<int>(json['totalPoints']),
      redeemedPoints: serializer.fromJson<int>(json['redeemedPoints']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'nickname': serializer.toJson<String?>(nickname),
      'password': serializer.toJson<String>(password),
      'isParent': serializer.toJson<bool>(isParent),
      'allowSelfHomeworkManagement':
          serializer.toJson<bool>(allowSelfHomeworkManagement),
      'notificationSettings': serializer.toJson<Object?>($UsersTable
          .$converternotificationSettingsn
          .toJson(notificationSettings)),
      'pointSystemId': serializer.toJson<String?>(pointSystemId),
      'totalPoints': serializer.toJson<int>(totalPoints),
      'redeemedPoints': serializer.toJson<int>(redeemedPoints),
    };
  }

  User copyWith(
          {int? id,
          String? username,
          Value<String?> nickname = const Value.absent(),
          String? password,
          bool? isParent,
          bool? allowSelfHomeworkManagement,
          Value<NotificationSetting?> notificationSettings =
              const Value.absent(),
          Value<String?> pointSystemId = const Value.absent(),
          int? totalPoints,
          int? redeemedPoints}) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        nickname: nickname.present ? nickname.value : this.nickname,
        password: password ?? this.password,
        isParent: isParent ?? this.isParent,
        allowSelfHomeworkManagement:
            allowSelfHomeworkManagement ?? this.allowSelfHomeworkManagement,
        notificationSettings: notificationSettings.present
            ? notificationSettings.value
            : this.notificationSettings,
        pointSystemId:
            pointSystemId.present ? pointSystemId.value : this.pointSystemId,
        totalPoints: totalPoints ?? this.totalPoints,
        redeemedPoints: redeemedPoints ?? this.redeemedPoints,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      password: data.password.present ? data.password.value : this.password,
      isParent: data.isParent.present ? data.isParent.value : this.isParent,
      allowSelfHomeworkManagement: data.allowSelfHomeworkManagement.present
          ? data.allowSelfHomeworkManagement.value
          : this.allowSelfHomeworkManagement,
      notificationSettings: data.notificationSettings.present
          ? data.notificationSettings.value
          : this.notificationSettings,
      pointSystemId: data.pointSystemId.present
          ? data.pointSystemId.value
          : this.pointSystemId,
      totalPoints:
          data.totalPoints.present ? data.totalPoints.value : this.totalPoints,
      redeemedPoints: data.redeemedPoints.present
          ? data.redeemedPoints.value
          : this.redeemedPoints,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('nickname: $nickname, ')
          ..write('password: $password, ')
          ..write('isParent: $isParent, ')
          ..write('allowSelfHomeworkManagement: $allowSelfHomeworkManagement, ')
          ..write('notificationSettings: $notificationSettings, ')
          ..write('pointSystemId: $pointSystemId, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('redeemedPoints: $redeemedPoints')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      username,
      nickname,
      password,
      isParent,
      allowSelfHomeworkManagement,
      notificationSettings,
      pointSystemId,
      totalPoints,
      redeemedPoints);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.nickname == this.nickname &&
          other.password == this.password &&
          other.isParent == this.isParent &&
          other.allowSelfHomeworkManagement ==
              this.allowSelfHomeworkManagement &&
          other.notificationSettings == this.notificationSettings &&
          other.pointSystemId == this.pointSystemId &&
          other.totalPoints == this.totalPoints &&
          other.redeemedPoints == this.redeemedPoints);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String?> nickname;
  final Value<String> password;
  final Value<bool> isParent;
  final Value<bool> allowSelfHomeworkManagement;
  final Value<NotificationSetting?> notificationSettings;
  final Value<String?> pointSystemId;
  final Value<int> totalPoints;
  final Value<int> redeemedPoints;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.nickname = const Value.absent(),
    this.password = const Value.absent(),
    this.isParent = const Value.absent(),
    this.allowSelfHomeworkManagement = const Value.absent(),
    this.notificationSettings = const Value.absent(),
    this.pointSystemId = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.redeemedPoints = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    this.nickname = const Value.absent(),
    required String password,
    this.isParent = const Value.absent(),
    this.allowSelfHomeworkManagement = const Value.absent(),
    this.notificationSettings = const Value.absent(),
    this.pointSystemId = const Value.absent(),
    this.totalPoints = const Value.absent(),
    this.redeemedPoints = const Value.absent(),
  })  : username = Value(username),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? nickname,
    Expression<String>? password,
    Expression<bool>? isParent,
    Expression<bool>? allowSelfHomeworkManagement,
    Expression<String>? notificationSettings,
    Expression<String>? pointSystemId,
    Expression<int>? totalPoints,
    Expression<int>? redeemedPoints,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (nickname != null) 'nickname': nickname,
      if (password != null) 'password': password,
      if (isParent != null) 'is_parent': isParent,
      if (allowSelfHomeworkManagement != null)
        'allow_self_homework_management': allowSelfHomeworkManagement,
      if (notificationSettings != null)
        'notification_settings': notificationSettings,
      if (pointSystemId != null) 'point_system_id': pointSystemId,
      if (totalPoints != null) 'total_points': totalPoints,
      if (redeemedPoints != null) 'redeemed_points': redeemedPoints,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? username,
      Value<String?>? nickname,
      Value<String>? password,
      Value<bool>? isParent,
      Value<bool>? allowSelfHomeworkManagement,
      Value<NotificationSetting?>? notificationSettings,
      Value<String?>? pointSystemId,
      Value<int>? totalPoints,
      Value<int>? redeemedPoints}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      password: password ?? this.password,
      isParent: isParent ?? this.isParent,
      allowSelfHomeworkManagement:
          allowSelfHomeworkManagement ?? this.allowSelfHomeworkManagement,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      pointSystemId: pointSystemId ?? this.pointSystemId,
      totalPoints: totalPoints ?? this.totalPoints,
      redeemedPoints: redeemedPoints ?? this.redeemedPoints,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (isParent.present) {
      map['is_parent'] = Variable<bool>(isParent.value);
    }
    if (allowSelfHomeworkManagement.present) {
      map['allow_self_homework_management'] =
          Variable<bool>(allowSelfHomeworkManagement.value);
    }
    if (notificationSettings.present) {
      map['notification_settings'] = Variable<String>($UsersTable
          .$converternotificationSettingsn
          .toSql(notificationSettings.value));
    }
    if (pointSystemId.present) {
      map['point_system_id'] = Variable<String>(pointSystemId.value);
    }
    if (totalPoints.present) {
      map['total_points'] = Variable<int>(totalPoints.value);
    }
    if (redeemedPoints.present) {
      map['redeemed_points'] = Variable<int>(redeemedPoints.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('nickname: $nickname, ')
          ..write('password: $password, ')
          ..write('isParent: $isParent, ')
          ..write('allowSelfHomeworkManagement: $allowSelfHomeworkManagement, ')
          ..write('notificationSettings: $notificationSettings, ')
          ..write('pointSystemId: $pointSystemId, ')
          ..write('totalPoints: $totalPoints, ')
          ..write('redeemedPoints: $redeemedPoints')
          ..write(')'))
        .toString();
  }
}

class $TaskTemplatesTable extends TaskTemplates
    with TableInfo<$TaskTemplatesTable, TaskTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _creatorMeta =
      const VerificationMeta('creator');
  @override
  late final GeneratedColumn<String> creator = GeneratedColumn<String>(
      'creator', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      assignedUsers = GeneratedColumn<String>(
              'assigned_users', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>(
              $TaskTemplatesTable.$converterassignedUsers);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> tags =
      GeneratedColumn<String>('tags', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($TaskTemplatesTable.$convertertagsn);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _remindMeta = const VerificationMeta('remind');
  @override
  late final GeneratedColumn<int> remind = GeneratedColumn<int>(
      'remind', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<RecurrencePattern, String>
      recurrence = GeneratedColumn<String>('recurrence', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<RecurrencePattern>(
              $TaskTemplatesTable.$converterrecurrence);
  @override
  late final GeneratedColumnWithTypeConverter<RewardInfo?, String> rewards =
      GeneratedColumn<String>('rewards', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<RewardInfo?>($TaskTemplatesTable.$converterrewardsn);
  static const VerificationMeta _penaltyMeta =
      const VerificationMeta('penalty');
  @override
  late final GeneratedColumn<String> penalty = GeneratedColumn<String>(
      'penalty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentRequiredMeta =
      const VerificationMeta('attachmentRequired');
  @override
  late final GeneratedColumn<bool> attachmentRequired = GeneratedColumn<bool>(
      'attachment_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("attachment_required" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _submissionRequiredMeta =
      const VerificationMeta('submissionRequired');
  @override
  late final GeneratedColumn<bool> submissionRequired = GeneratedColumn<bool>(
      'submission_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("submission_required" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime> creationTime = GeneratedColumn<DateTime>(
      'creation_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Duration, int>
      expectedCompletionTimeInMinutes = GeneratedColumn<int>(
              'expected_completion_time_in_minutes', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Duration>(
              $TaskTemplatesTable.$converterexpectedCompletionTimeInMinutes);
  @override
  late final GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      notificationSetting = GeneratedColumn<String>(
              'notification_setting', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<NotificationSetting?>(
              $TaskTemplatesTable.$converternotificationSettingn);
  @override
  List<GeneratedColumn> get $columns => [
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
        notificationSetting
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_templates';
  @override
  VerificationContext validateIntegrity(Insertable<TaskTemplate> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('creator')) {
      context.handle(_creatorMeta,
          creator.isAcceptableOrUnknown(data['creator']!, _creatorMeta));
    } else if (isInserting) {
      context.missing(_creatorMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('remind')) {
      context.handle(_remindMeta,
          remind.isAcceptableOrUnknown(data['remind']!, _remindMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('penalty')) {
      context.handle(_penaltyMeta,
          penalty.isAcceptableOrUnknown(data['penalty']!, _penaltyMeta));
    }
    if (data.containsKey('attachment_required')) {
      context.handle(
          _attachmentRequiredMeta,
          attachmentRequired.isAcceptableOrUnknown(
              data['attachment_required']!, _attachmentRequiredMeta));
    }
    if (data.containsKey('submission_required')) {
      context.handle(
          _submissionRequiredMeta,
          submissionRequired.isAcceptableOrUnknown(
              data['submission_required']!, _submissionRequiredMeta));
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    } else if (isInserting) {
      context.missing(_creationTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  TaskTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskTemplate(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      creator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator'])!,
      assignedUsers: $TaskTemplatesTable.$converterassignedUsers.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}assigned_users'])!),
      tags: $TaskTemplatesTable.$convertertagsn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      remind: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remind'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      recurrence: $TaskTemplatesTable.$converterrecurrence.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}recurrence'])!),
      rewards: $TaskTemplatesTable.$converterrewardsn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rewards'])),
      penalty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}penalty']),
      attachmentRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}attachment_required'])!,
      submissionRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}submission_required'])!,
      creationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}creation_time'])!,
      expectedCompletionTimeInMinutes: $TaskTemplatesTable
          .$converterexpectedCompletionTimeInMinutes
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int,
              data['${effectivePrefix}expected_completion_time_in_minutes'])!),
      notificationSetting: $TaskTemplatesTable.$converternotificationSettingn
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}notification_setting'])),
    );
  }

  @override
  $TaskTemplatesTable createAlias(String alias) {
    return $TaskTemplatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, Object?>
      $converterassignedUsers = stringListConverter;
  static JsonTypeConverter2<List<String>, String, Object?> $convertertags =
      stringListConverter;
  static JsonTypeConverter2<List<String>?, String?, Object?> $convertertagsn =
      JsonTypeConverter2.asNullable($convertertags);
  static JsonTypeConverter2<RecurrencePattern, String, Object?>
      $converterrecurrence = recurrencePatternConverter;
  static TypeConverter<RewardInfo, String> $converterrewards =
      const RewardInfoConverter();
  static TypeConverter<RewardInfo?, String?> $converterrewardsn =
      NullAwareTypeConverter.wrap($converterrewards);
  static JsonTypeConverter2<Duration, int, Object?>
      $converterexpectedCompletionTimeInMinutes = const DurationConverter();
  static JsonTypeConverter2<NotificationSetting, String, Object?>
      $converternotificationSetting = notificationSettingConverter;
  static JsonTypeConverter2<NotificationSetting?, String?, Object?>
      $converternotificationSettingn =
      JsonTypeConverter2.asNullable($converternotificationSetting);
}

class TaskTemplate extends DataClass implements Insertable<TaskTemplate> {
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

  /// Reward information (max points, description, etc.)
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['creator'] = Variable<String>(creator);
    {
      map['assigned_users'] = Variable<String>(
          $TaskTemplatesTable.$converterassignedUsers.toSql(assignedUsers));
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] =
          Variable<String>($TaskTemplatesTable.$convertertagsn.toSql(tags));
    }
    map['priority'] = Variable<int>(priority);
    map['remind'] = Variable<int>(remind);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    {
      map['recurrence'] = Variable<String>(
          $TaskTemplatesTable.$converterrecurrence.toSql(recurrence));
    }
    if (!nullToAbsent || rewards != null) {
      map['rewards'] = Variable<String>(
          $TaskTemplatesTable.$converterrewardsn.toSql(rewards));
    }
    if (!nullToAbsent || penalty != null) {
      map['penalty'] = Variable<String>(penalty);
    }
    map['attachment_required'] = Variable<bool>(attachmentRequired);
    map['submission_required'] = Variable<bool>(submissionRequired);
    map['creation_time'] = Variable<DateTime>(creationTime);
    {
      map['expected_completion_time_in_minutes'] = Variable<int>(
          $TaskTemplatesTable.$converterexpectedCompletionTimeInMinutes
              .toSql(expectedCompletionTimeInMinutes));
    }
    if (!nullToAbsent || notificationSetting != null) {
      map['notification_setting'] = Variable<String>($TaskTemplatesTable
          .$converternotificationSettingn
          .toSql(notificationSetting));
    }
    return map;
  }

  TaskTemplatesCompanion toCompanion(bool nullToAbsent) {
    return TaskTemplatesCompanion(
      id: Value(id),
      title: Value(title),
      creator: Value(creator),
      assignedUsers: Value(assignedUsers),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      priority: Value(priority),
      remind: Value(remind),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      recurrence: Value(recurrence),
      rewards: rewards == null && nullToAbsent
          ? const Value.absent()
          : Value(rewards),
      penalty: penalty == null && nullToAbsent
          ? const Value.absent()
          : Value(penalty),
      attachmentRequired: Value(attachmentRequired),
      submissionRequired: Value(submissionRequired),
      creationTime: Value(creationTime),
      expectedCompletionTimeInMinutes: Value(expectedCompletionTimeInMinutes),
      notificationSetting: notificationSetting == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationSetting),
    );
  }

  factory TaskTemplate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskTemplate(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      creator: serializer.fromJson<String>(json['creator']),
      assignedUsers: $TaskTemplatesTable.$converterassignedUsers
          .fromJson(serializer.fromJson<Object?>(json['assignedUsers'])),
      tags: $TaskTemplatesTable.$convertertagsn
          .fromJson(serializer.fromJson<Object?>(json['tags'])),
      priority: serializer.fromJson<int>(json['priority']),
      remind: serializer.fromJson<int>(json['remind']),
      description: serializer.fromJson<String?>(json['description']),
      recurrence: $TaskTemplatesTable.$converterrecurrence
          .fromJson(serializer.fromJson<Object?>(json['recurrence'])),
      rewards: serializer.fromJson<RewardInfo?>(json['rewards']),
      penalty: serializer.fromJson<String?>(json['penalty']),
      attachmentRequired: serializer.fromJson<bool>(json['attachmentRequired']),
      submissionRequired: serializer.fromJson<bool>(json['submissionRequired']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      expectedCompletionTimeInMinutes: $TaskTemplatesTable
          .$converterexpectedCompletionTimeInMinutes
          .fromJson(serializer
              .fromJson<Object?>(json['expectedCompletionTimeInMinutes'])),
      notificationSetting: $TaskTemplatesTable.$converternotificationSettingn
          .fromJson(serializer.fromJson<Object?>(json['notificationSetting'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'creator': serializer.toJson<String>(creator),
      'assignedUsers': serializer.toJson<Object?>(
          $TaskTemplatesTable.$converterassignedUsers.toJson(assignedUsers)),
      'tags': serializer
          .toJson<Object?>($TaskTemplatesTable.$convertertagsn.toJson(tags)),
      'priority': serializer.toJson<int>(priority),
      'remind': serializer.toJson<int>(remind),
      'description': serializer.toJson<String?>(description),
      'recurrence': serializer.toJson<Object?>(
          $TaskTemplatesTable.$converterrecurrence.toJson(recurrence)),
      'rewards': serializer.toJson<RewardInfo?>(rewards),
      'penalty': serializer.toJson<String?>(penalty),
      'attachmentRequired': serializer.toJson<bool>(attachmentRequired),
      'submissionRequired': serializer.toJson<bool>(submissionRequired),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'expectedCompletionTimeInMinutes': serializer.toJson<Object?>(
          $TaskTemplatesTable.$converterexpectedCompletionTimeInMinutes
              .toJson(expectedCompletionTimeInMinutes)),
      'notificationSetting': serializer.toJson<Object?>($TaskTemplatesTable
          .$converternotificationSettingn
          .toJson(notificationSetting)),
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
  TaskTemplate copyWithCompanion(TaskTemplatesCompanion data) {
    return TaskTemplate(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      creator: data.creator.present ? data.creator.value : this.creator,
      assignedUsers: data.assignedUsers.present
          ? data.assignedUsers.value
          : this.assignedUsers,
      tags: data.tags.present ? data.tags.value : this.tags,
      priority: data.priority.present ? data.priority.value : this.priority,
      remind: data.remind.present ? data.remind.value : this.remind,
      description:
          data.description.present ? data.description.value : this.description,
      recurrence:
          data.recurrence.present ? data.recurrence.value : this.recurrence,
      rewards: data.rewards.present ? data.rewards.value : this.rewards,
      penalty: data.penalty.present ? data.penalty.value : this.penalty,
      attachmentRequired: data.attachmentRequired.present
          ? data.attachmentRequired.value
          : this.attachmentRequired,
      submissionRequired: data.submissionRequired.present
          ? data.submissionRequired.value
          : this.submissionRequired,
      creationTime: data.creationTime.present
          ? data.creationTime.value
          : this.creationTime,
      expectedCompletionTimeInMinutes:
          data.expectedCompletionTimeInMinutes.present
              ? data.expectedCompletionTimeInMinutes.value
              : this.expectedCompletionTimeInMinutes,
      notificationSetting: data.notificationSetting.present
          ? data.notificationSetting.value
          : this.notificationSetting,
    );
  }

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

class TaskTemplatesCompanion extends UpdateCompanion<TaskTemplate> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> creator;
  final Value<List<String>> assignedUsers;
  final Value<List<String>?> tags;
  final Value<int> priority;
  final Value<int> remind;
  final Value<String?> description;
  final Value<RecurrencePattern> recurrence;
  final Value<RewardInfo?> rewards;
  final Value<String?> penalty;
  final Value<bool> attachmentRequired;
  final Value<bool> submissionRequired;
  final Value<DateTime> creationTime;
  final Value<Duration> expectedCompletionTimeInMinutes;
  final Value<NotificationSetting?> notificationSetting;
  const TaskTemplatesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.creator = const Value.absent(),
    this.assignedUsers = const Value.absent(),
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.remind = const Value.absent(),
    this.description = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.rewards = const Value.absent(),
    this.penalty = const Value.absent(),
    this.attachmentRequired = const Value.absent(),
    this.submissionRequired = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.expectedCompletionTimeInMinutes = const Value.absent(),
    this.notificationSetting = const Value.absent(),
  });
  TaskTemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String creator,
    required List<String> assignedUsers,
    this.tags = const Value.absent(),
    this.priority = const Value.absent(),
    this.remind = const Value.absent(),
    this.description = const Value.absent(),
    required RecurrencePattern recurrence,
    this.rewards = const Value.absent(),
    this.penalty = const Value.absent(),
    this.attachmentRequired = const Value.absent(),
    this.submissionRequired = const Value.absent(),
    required DateTime creationTime,
    required Duration expectedCompletionTimeInMinutes,
    this.notificationSetting = const Value.absent(),
  })  : title = Value(title),
        creator = Value(creator),
        assignedUsers = Value(assignedUsers),
        recurrence = Value(recurrence),
        creationTime = Value(creationTime),
        expectedCompletionTimeInMinutes =
            Value(expectedCompletionTimeInMinutes);
  static Insertable<TaskTemplate> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? creator,
    Expression<String>? assignedUsers,
    Expression<String>? tags,
    Expression<int>? priority,
    Expression<int>? remind,
    Expression<String>? description,
    Expression<String>? recurrence,
    Expression<String>? rewards,
    Expression<String>? penalty,
    Expression<bool>? attachmentRequired,
    Expression<bool>? submissionRequired,
    Expression<DateTime>? creationTime,
    Expression<int>? expectedCompletionTimeInMinutes,
    Expression<String>? notificationSetting,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (creator != null) 'creator': creator,
      if (assignedUsers != null) 'assigned_users': assignedUsers,
      if (tags != null) 'tags': tags,
      if (priority != null) 'priority': priority,
      if (remind != null) 'remind': remind,
      if (description != null) 'description': description,
      if (recurrence != null) 'recurrence': recurrence,
      if (rewards != null) 'rewards': rewards,
      if (penalty != null) 'penalty': penalty,
      if (attachmentRequired != null) 'attachment_required': attachmentRequired,
      if (submissionRequired != null) 'submission_required': submissionRequired,
      if (creationTime != null) 'creation_time': creationTime,
      if (expectedCompletionTimeInMinutes != null)
        'expected_completion_time_in_minutes': expectedCompletionTimeInMinutes,
      if (notificationSetting != null)
        'notification_setting': notificationSetting,
    });
  }

  TaskTemplatesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? creator,
      Value<List<String>>? assignedUsers,
      Value<List<String>?>? tags,
      Value<int>? priority,
      Value<int>? remind,
      Value<String?>? description,
      Value<RecurrencePattern>? recurrence,
      Value<RewardInfo?>? rewards,
      Value<String?>? penalty,
      Value<bool>? attachmentRequired,
      Value<bool>? submissionRequired,
      Value<DateTime>? creationTime,
      Value<Duration>? expectedCompletionTimeInMinutes,
      Value<NotificationSetting?>? notificationSetting}) {
    return TaskTemplatesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      creator: creator ?? this.creator,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      remind: remind ?? this.remind,
      description: description ?? this.description,
      recurrence: recurrence ?? this.recurrence,
      rewards: rewards ?? this.rewards,
      penalty: penalty ?? this.penalty,
      attachmentRequired: attachmentRequired ?? this.attachmentRequired,
      submissionRequired: submissionRequired ?? this.submissionRequired,
      creationTime: creationTime ?? this.creationTime,
      expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes ??
          this.expectedCompletionTimeInMinutes,
      notificationSetting: notificationSetting ?? this.notificationSetting,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (creator.present) {
      map['creator'] = Variable<String>(creator.value);
    }
    if (assignedUsers.present) {
      map['assigned_users'] = Variable<String>($TaskTemplatesTable
          .$converterassignedUsers
          .toSql(assignedUsers.value));
    }
    if (tags.present) {
      map['tags'] = Variable<String>(
          $TaskTemplatesTable.$convertertagsn.toSql(tags.value));
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (remind.present) {
      map['remind'] = Variable<int>(remind.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
          $TaskTemplatesTable.$converterrecurrence.toSql(recurrence.value));
    }
    if (rewards.present) {
      map['rewards'] = Variable<String>(
          $TaskTemplatesTable.$converterrewardsn.toSql(rewards.value));
    }
    if (penalty.present) {
      map['penalty'] = Variable<String>(penalty.value);
    }
    if (attachmentRequired.present) {
      map['attachment_required'] = Variable<bool>(attachmentRequired.value);
    }
    if (submissionRequired.present) {
      map['submission_required'] = Variable<bool>(submissionRequired.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (expectedCompletionTimeInMinutes.present) {
      map['expected_completion_time_in_minutes'] = Variable<int>(
          $TaskTemplatesTable.$converterexpectedCompletionTimeInMinutes
              .toSql(expectedCompletionTimeInMinutes.value));
    }
    if (notificationSetting.present) {
      map['notification_setting'] = Variable<String>($TaskTemplatesTable
          .$converternotificationSettingn
          .toSql(notificationSetting.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskTemplatesCompanion(')
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
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
      'template_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String> tags =
      GeneratedColumn<String>('tags', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($TasksTable.$convertertagsn);
  static const VerificationMeta _remindMeta = const VerificationMeta('remind');
  @override
  late final GeneratedColumn<int> remind = GeneratedColumn<int>(
      'remind', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      assignedUsers = GeneratedColumn<String>(
              'assigned_users', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($TasksTable.$converterassignedUsers);
  @override
  late final GeneratedColumnWithTypeConverter<RewardInfo?, String> rewards =
      GeneratedColumn<String>('rewards', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<RewardInfo?>($TasksTable.$converterrewardsn);
  static const VerificationMeta _penaltyMeta =
      const VerificationMeta('penalty');
  @override
  late final GeneratedColumn<String> penalty = GeneratedColumn<String>(
      'penalty', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dueTimeMeta =
      const VerificationMeta('dueTime');
  @override
  late final GeneratedColumn<DateTime> dueTime = GeneratedColumn<DateTime>(
      'due_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Duration, int>
      expectedCompletionTimeInMinutes = GeneratedColumn<int>(
              'expected_completion_time_in_minutes', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<Duration>(
              $TasksTable.$converterexpectedCompletionTimeInMinutes);
  @override
  late final GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      notificationSetting = GeneratedColumn<String>(
              'notification_setting', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<NotificationSetting?>(
              $TasksTable.$converternotificationSettingn);
  @override
  late final GeneratedColumnWithTypeConverter<NotificationHistory?, String>
      notificationHistory = GeneratedColumn<String>(
              'notification_history', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<NotificationHistory?>(
              $TasksTable.$converternotificationHistoryn);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>?, String>
      submittedFiles = GeneratedColumn<String>(
              'submitted_files', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<String>?>($TasksTable.$convertersubmittedFilesn);
  static const VerificationMeta _completionTimeMeta =
      const VerificationMeta('completionTime');
  @override
  late final GeneratedColumn<DateTime> completionTime =
      GeneratedColumn<DateTime>('completion_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _evaluationTimeMeta =
      const VerificationMeta('evaluationTime');
  @override
  late final GeneratedColumn<DateTime> evaluationTime =
      GeneratedColumn<DateTime>('evaluation_time', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _evaluatorMeta =
      const VerificationMeta('evaluator');
  @override
  late final GeneratedColumn<String> evaluator = GeneratedColumn<String>(
      'evaluator', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _attachmentRequiredMeta =
      const VerificationMeta('attachmentRequired');
  @override
  late final GeneratedColumn<bool> attachmentRequired = GeneratedColumn<bool>(
      'attachment_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("attachment_required" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _submissionRequiredMeta =
      const VerificationMeta('submissionRequired');
  @override
  late final GeneratedColumn<bool> submissionRequired = GeneratedColumn<bool>(
      'submission_required', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("submission_required" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _cancelledMeta =
      const VerificationMeta('cancelled');
  @override
  late final GeneratedColumn<bool> cancelled = GeneratedColumn<bool>(
      'cancelled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cancelled" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
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
        cancelled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('remind')) {
      context.handle(_remindMeta,
          remind.isAcceptableOrUnknown(data['remind']!, _remindMeta));
    }
    if (data.containsKey('penalty')) {
      context.handle(_penaltyMeta,
          penalty.isAcceptableOrUnknown(data['penalty']!, _penaltyMeta));
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('due_time')) {
      context.handle(_dueTimeMeta,
          dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta));
    } else if (isInserting) {
      context.missing(_dueTimeMeta);
    }
    if (data.containsKey('completion_time')) {
      context.handle(
          _completionTimeMeta,
          completionTime.isAcceptableOrUnknown(
              data['completion_time']!, _completionTimeMeta));
    }
    if (data.containsKey('evaluation_time')) {
      context.handle(
          _evaluationTimeMeta,
          evaluationTime.isAcceptableOrUnknown(
              data['evaluation_time']!, _evaluationTimeMeta));
    }
    if (data.containsKey('evaluator')) {
      context.handle(_evaluatorMeta,
          evaluator.isAcceptableOrUnknown(data['evaluator']!, _evaluatorMeta));
    }
    if (data.containsKey('attachment_required')) {
      context.handle(
          _attachmentRequiredMeta,
          attachmentRequired.isAcceptableOrUnknown(
              data['attachment_required']!, _attachmentRequiredMeta));
    }
    if (data.containsKey('submission_required')) {
      context.handle(
          _submissionRequiredMeta,
          submissionRequired.isAcceptableOrUnknown(
              data['submission_required']!, _submissionRequiredMeta));
    }
    if (data.containsKey('cancelled')) {
      context.handle(_cancelledMeta,
          cancelled.isAcceptableOrUnknown(data['cancelled']!, _cancelledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {id},
      ];
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      tags: $TasksTable.$convertertagsn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])),
      remind: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}remind'])!,
      assignedUsers: $TasksTable.$converterassignedUsers.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}assigned_users'])!),
      rewards: $TasksTable.$converterrewardsn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rewards'])),
      penalty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}penalty']),
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      dueTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_time'])!,
      expectedCompletionTimeInMinutes: $TasksTable
          .$converterexpectedCompletionTimeInMinutes
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int,
              data['${effectivePrefix}expected_completion_time_in_minutes'])!),
      notificationSetting: $TasksTable.$converternotificationSettingn.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}notification_setting'])),
      notificationHistory: $TasksTable.$converternotificationHistoryn.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}notification_history'])),
      submittedFiles: $TasksTable.$convertersubmittedFilesn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}submitted_files'])),
      completionTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}completion_time']),
      evaluationTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}evaluation_time']),
      evaluator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}evaluator']),
      attachmentRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}attachment_required'])!,
      submissionRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}submission_required'])!,
      cancelled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cancelled'])!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, Object?> $convertertags =
      stringListConverter;
  static JsonTypeConverter2<List<String>?, String?, Object?> $convertertagsn =
      JsonTypeConverter2.asNullable($convertertags);
  static JsonTypeConverter2<List<String>, String, Object?>
      $converterassignedUsers = stringListConverter;
  static TypeConverter<RewardInfo, String> $converterrewards =
      const RewardInfoConverter();
  static TypeConverter<RewardInfo?, String?> $converterrewardsn =
      NullAwareTypeConverter.wrap($converterrewards);
  static JsonTypeConverter2<Duration, int, Object?>
      $converterexpectedCompletionTimeInMinutes = const DurationConverter();
  static JsonTypeConverter2<NotificationSetting, String, Object?>
      $converternotificationSetting = notificationSettingConverter;
  static JsonTypeConverter2<NotificationSetting?, String?, Object?>
      $converternotificationSettingn =
      JsonTypeConverter2.asNullable($converternotificationSetting);
  static JsonTypeConverter2<NotificationHistory, String, Object?>
      $converternotificationHistory = notificationHistoryConverter;
  static JsonTypeConverter2<NotificationHistory?, String?, Object?>
      $converternotificationHistoryn =
      JsonTypeConverter2.asNullable($converternotificationHistory);
  static JsonTypeConverter2<List<String>, String, Object?>
      $convertersubmittedFiles = stringListConverter;
  static JsonTypeConverter2<List<String>?, String?, Object?>
      $convertersubmittedFilesn =
      JsonTypeConverter2.asNullable($convertersubmittedFiles);
}

class Task extends DataClass implements Insertable<Task> {
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

  /// Reward information (max points, description, etc.)
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

  /// Requires the user to submit the task or not
  final bool submissionRequired;

  /// Requires the user to submit the task or not
  final bool cancelled;
  const Task(
      {required this.id,
      required this.templateId,
      required this.title,
      this.description,
      this.tags,
      required this.remind,
      required this.assignedUsers,
      this.rewards,
      this.penalty,
      required this.startTime,
      required this.dueTime,
      required this.expectedCompletionTimeInMinutes,
      this.notificationSetting,
      this.notificationHistory,
      this.submittedFiles,
      this.completionTime,
      this.evaluationTime,
      this.evaluator,
      required this.attachmentRequired,
      required this.submissionRequired,
      required this.cancelled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>($TasksTable.$convertertagsn.toSql(tags));
    }
    map['remind'] = Variable<int>(remind);
    {
      map['assigned_users'] = Variable<String>(
          $TasksTable.$converterassignedUsers.toSql(assignedUsers));
    }
    if (!nullToAbsent || rewards != null) {
      map['rewards'] =
          Variable<String>($TasksTable.$converterrewardsn.toSql(rewards));
    }
    if (!nullToAbsent || penalty != null) {
      map['penalty'] = Variable<String>(penalty);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    map['due_time'] = Variable<DateTime>(dueTime);
    {
      map['expected_completion_time_in_minutes'] = Variable<int>($TasksTable
          .$converterexpectedCompletionTimeInMinutes
          .toSql(expectedCompletionTimeInMinutes));
    }
    if (!nullToAbsent || notificationSetting != null) {
      map['notification_setting'] = Variable<String>($TasksTable
          .$converternotificationSettingn
          .toSql(notificationSetting));
    }
    if (!nullToAbsent || notificationHistory != null) {
      map['notification_history'] = Variable<String>($TasksTable
          .$converternotificationHistoryn
          .toSql(notificationHistory));
    }
    if (!nullToAbsent || submittedFiles != null) {
      map['submitted_files'] = Variable<String>(
          $TasksTable.$convertersubmittedFilesn.toSql(submittedFiles));
    }
    if (!nullToAbsent || completionTime != null) {
      map['completion_time'] = Variable<DateTime>(completionTime);
    }
    if (!nullToAbsent || evaluationTime != null) {
      map['evaluation_time'] = Variable<DateTime>(evaluationTime);
    }
    if (!nullToAbsent || evaluator != null) {
      map['evaluator'] = Variable<String>(evaluator);
    }
    map['attachment_required'] = Variable<bool>(attachmentRequired);
    map['submission_required'] = Variable<bool>(submissionRequired);
    map['cancelled'] = Variable<bool>(cancelled);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      templateId: Value(templateId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      remind: Value(remind),
      assignedUsers: Value(assignedUsers),
      rewards: rewards == null && nullToAbsent
          ? const Value.absent()
          : Value(rewards),
      penalty: penalty == null && nullToAbsent
          ? const Value.absent()
          : Value(penalty),
      startTime: Value(startTime),
      dueTime: Value(dueTime),
      expectedCompletionTimeInMinutes: Value(expectedCompletionTimeInMinutes),
      notificationSetting: notificationSetting == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationSetting),
      notificationHistory: notificationHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationHistory),
      submittedFiles: submittedFiles == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedFiles),
      completionTime: completionTime == null && nullToAbsent
          ? const Value.absent()
          : Value(completionTime),
      evaluationTime: evaluationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluationTime),
      evaluator: evaluator == null && nullToAbsent
          ? const Value.absent()
          : Value(evaluator),
      attachmentRequired: Value(attachmentRequired),
      submissionRequired: Value(submissionRequired),
      cancelled: Value(cancelled),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      tags: $TasksTable.$convertertagsn
          .fromJson(serializer.fromJson<Object?>(json['tags'])),
      remind: serializer.fromJson<int>(json['remind']),
      assignedUsers: $TasksTable.$converterassignedUsers
          .fromJson(serializer.fromJson<Object?>(json['assignedUsers'])),
      rewards: serializer.fromJson<RewardInfo?>(json['rewards']),
      penalty: serializer.fromJson<String?>(json['penalty']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      dueTime: serializer.fromJson<DateTime>(json['dueTime']),
      expectedCompletionTimeInMinutes: $TasksTable
          .$converterexpectedCompletionTimeInMinutes
          .fromJson(serializer
              .fromJson<Object?>(json['expectedCompletionTimeInMinutes'])),
      notificationSetting: $TasksTable.$converternotificationSettingn
          .fromJson(serializer.fromJson<Object?>(json['notificationSetting'])),
      notificationHistory: $TasksTable.$converternotificationHistoryn
          .fromJson(serializer.fromJson<Object?>(json['notificationHistory'])),
      submittedFiles: $TasksTable.$convertersubmittedFilesn
          .fromJson(serializer.fromJson<Object?>(json['submittedFiles'])),
      completionTime: serializer.fromJson<DateTime?>(json['completionTime']),
      evaluationTime: serializer.fromJson<DateTime?>(json['evaluationTime']),
      evaluator: serializer.fromJson<String?>(json['evaluator']),
      attachmentRequired: serializer.fromJson<bool>(json['attachmentRequired']),
      submissionRequired: serializer.fromJson<bool>(json['submissionRequired']),
      cancelled: serializer.fromJson<bool>(json['cancelled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'tags':
          serializer.toJson<Object?>($TasksTable.$convertertagsn.toJson(tags)),
      'remind': serializer.toJson<int>(remind),
      'assignedUsers': serializer.toJson<Object?>(
          $TasksTable.$converterassignedUsers.toJson(assignedUsers)),
      'rewards': serializer.toJson<RewardInfo?>(rewards),
      'penalty': serializer.toJson<String?>(penalty),
      'startTime': serializer.toJson<DateTime>(startTime),
      'dueTime': serializer.toJson<DateTime>(dueTime),
      'expectedCompletionTimeInMinutes': serializer.toJson<Object?>($TasksTable
          .$converterexpectedCompletionTimeInMinutes
          .toJson(expectedCompletionTimeInMinutes)),
      'notificationSetting': serializer.toJson<Object?>($TasksTable
          .$converternotificationSettingn
          .toJson(notificationSetting)),
      'notificationHistory': serializer.toJson<Object?>($TasksTable
          .$converternotificationHistoryn
          .toJson(notificationHistory)),
      'submittedFiles': serializer.toJson<Object?>(
          $TasksTable.$convertersubmittedFilesn.toJson(submittedFiles)),
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
          bool? submissionRequired,
          bool? cancelled}) =>
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
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      tags: data.tags.present ? data.tags.value : this.tags,
      remind: data.remind.present ? data.remind.value : this.remind,
      assignedUsers: data.assignedUsers.present
          ? data.assignedUsers.value
          : this.assignedUsers,
      rewards: data.rewards.present ? data.rewards.value : this.rewards,
      penalty: data.penalty.present ? data.penalty.value : this.penalty,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      expectedCompletionTimeInMinutes:
          data.expectedCompletionTimeInMinutes.present
              ? data.expectedCompletionTimeInMinutes.value
              : this.expectedCompletionTimeInMinutes,
      notificationSetting: data.notificationSetting.present
          ? data.notificationSetting.value
          : this.notificationSetting,
      notificationHistory: data.notificationHistory.present
          ? data.notificationHistory.value
          : this.notificationHistory,
      submittedFiles: data.submittedFiles.present
          ? data.submittedFiles.value
          : this.submittedFiles,
      completionTime: data.completionTime.present
          ? data.completionTime.value
          : this.completionTime,
      evaluationTime: data.evaluationTime.present
          ? data.evaluationTime.value
          : this.evaluationTime,
      evaluator: data.evaluator.present ? data.evaluator.value : this.evaluator,
      attachmentRequired: data.attachmentRequired.present
          ? data.attachmentRequired.value
          : this.attachmentRequired,
      submissionRequired: data.submissionRequired.present
          ? data.submissionRequired.value
          : this.submissionRequired,
      cancelled: data.cancelled.present ? data.cancelled.value : this.cancelled,
    );
  }

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
          ..write('submissionRequired: $submissionRequired, ')
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
        cancelled
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

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<String> title;
  final Value<String?> description;
  final Value<List<String>?> tags;
  final Value<int> remind;
  final Value<List<String>> assignedUsers;
  final Value<RewardInfo?> rewards;
  final Value<String?> penalty;
  final Value<DateTime> startTime;
  final Value<DateTime> dueTime;
  final Value<Duration> expectedCompletionTimeInMinutes;
  final Value<NotificationSetting?> notificationSetting;
  final Value<NotificationHistory?> notificationHistory;
  final Value<List<String>?> submittedFiles;
  final Value<DateTime?> completionTime;
  final Value<DateTime?> evaluationTime;
  final Value<String?> evaluator;
  final Value<bool> attachmentRequired;
  final Value<bool> submissionRequired;
  final Value<bool> cancelled;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.remind = const Value.absent(),
    this.assignedUsers = const Value.absent(),
    this.rewards = const Value.absent(),
    this.penalty = const Value.absent(),
    this.startTime = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.expectedCompletionTimeInMinutes = const Value.absent(),
    this.notificationSetting = const Value.absent(),
    this.notificationHistory = const Value.absent(),
    this.submittedFiles = const Value.absent(),
    this.completionTime = const Value.absent(),
    this.evaluationTime = const Value.absent(),
    this.evaluator = const Value.absent(),
    this.attachmentRequired = const Value.absent(),
    this.submissionRequired = const Value.absent(),
    this.cancelled = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    required String title,
    this.description = const Value.absent(),
    this.tags = const Value.absent(),
    this.remind = const Value.absent(),
    required List<String> assignedUsers,
    this.rewards = const Value.absent(),
    this.penalty = const Value.absent(),
    required DateTime startTime,
    required DateTime dueTime,
    required Duration expectedCompletionTimeInMinutes,
    this.notificationSetting = const Value.absent(),
    this.notificationHistory = const Value.absent(),
    this.submittedFiles = const Value.absent(),
    this.completionTime = const Value.absent(),
    this.evaluationTime = const Value.absent(),
    this.evaluator = const Value.absent(),
    this.attachmentRequired = const Value.absent(),
    this.submissionRequired = const Value.absent(),
    this.cancelled = const Value.absent(),
  })  : templateId = Value(templateId),
        title = Value(title),
        assignedUsers = Value(assignedUsers),
        startTime = Value(startTime),
        dueTime = Value(dueTime),
        expectedCompletionTimeInMinutes =
            Value(expectedCompletionTimeInMinutes);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? tags,
    Expression<int>? remind,
    Expression<String>? assignedUsers,
    Expression<String>? rewards,
    Expression<String>? penalty,
    Expression<DateTime>? startTime,
    Expression<DateTime>? dueTime,
    Expression<int>? expectedCompletionTimeInMinutes,
    Expression<String>? notificationSetting,
    Expression<String>? notificationHistory,
    Expression<String>? submittedFiles,
    Expression<DateTime>? completionTime,
    Expression<DateTime>? evaluationTime,
    Expression<String>? evaluator,
    Expression<bool>? attachmentRequired,
    Expression<bool>? submissionRequired,
    Expression<bool>? cancelled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      if (remind != null) 'remind': remind,
      if (assignedUsers != null) 'assigned_users': assignedUsers,
      if (rewards != null) 'rewards': rewards,
      if (penalty != null) 'penalty': penalty,
      if (startTime != null) 'start_time': startTime,
      if (dueTime != null) 'due_time': dueTime,
      if (expectedCompletionTimeInMinutes != null)
        'expected_completion_time_in_minutes': expectedCompletionTimeInMinutes,
      if (notificationSetting != null)
        'notification_setting': notificationSetting,
      if (notificationHistory != null)
        'notification_history': notificationHistory,
      if (submittedFiles != null) 'submitted_files': submittedFiles,
      if (completionTime != null) 'completion_time': completionTime,
      if (evaluationTime != null) 'evaluation_time': evaluationTime,
      if (evaluator != null) 'evaluator': evaluator,
      if (attachmentRequired != null) 'attachment_required': attachmentRequired,
      if (submissionRequired != null) 'submission_required': submissionRequired,
      if (cancelled != null) 'cancelled': cancelled,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<int>? templateId,
      Value<String>? title,
      Value<String?>? description,
      Value<List<String>?>? tags,
      Value<int>? remind,
      Value<List<String>>? assignedUsers,
      Value<RewardInfo?>? rewards,
      Value<String?>? penalty,
      Value<DateTime>? startTime,
      Value<DateTime>? dueTime,
      Value<Duration>? expectedCompletionTimeInMinutes,
      Value<NotificationSetting?>? notificationSetting,
      Value<NotificationHistory?>? notificationHistory,
      Value<List<String>?>? submittedFiles,
      Value<DateTime?>? completionTime,
      Value<DateTime?>? evaluationTime,
      Value<String?>? evaluator,
      Value<bool>? attachmentRequired,
      Value<bool>? submissionRequired,
      Value<bool>? cancelled}) {
    return TasksCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      remind: remind ?? this.remind,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      rewards: rewards ?? this.rewards,
      penalty: penalty ?? this.penalty,
      startTime: startTime ?? this.startTime,
      dueTime: dueTime ?? this.dueTime,
      expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes ??
          this.expectedCompletionTimeInMinutes,
      notificationSetting: notificationSetting ?? this.notificationSetting,
      notificationHistory: notificationHistory ?? this.notificationHistory,
      submittedFiles: submittedFiles ?? this.submittedFiles,
      completionTime: completionTime ?? this.completionTime,
      evaluationTime: evaluationTime ?? this.evaluationTime,
      evaluator: evaluator ?? this.evaluator,
      attachmentRequired: attachmentRequired ?? this.attachmentRequired,
      submissionRequired: submissionRequired ?? this.submissionRequired,
      cancelled: cancelled ?? this.cancelled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($TasksTable.$convertertagsn.toSql(tags.value));
    }
    if (remind.present) {
      map['remind'] = Variable<int>(remind.value);
    }
    if (assignedUsers.present) {
      map['assigned_users'] = Variable<String>(
          $TasksTable.$converterassignedUsers.toSql(assignedUsers.value));
    }
    if (rewards.present) {
      map['rewards'] =
          Variable<String>($TasksTable.$converterrewardsn.toSql(rewards.value));
    }
    if (penalty.present) {
      map['penalty'] = Variable<String>(penalty.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<DateTime>(dueTime.value);
    }
    if (expectedCompletionTimeInMinutes.present) {
      map['expected_completion_time_in_minutes'] = Variable<int>($TasksTable
          .$converterexpectedCompletionTimeInMinutes
          .toSql(expectedCompletionTimeInMinutes.value));
    }
    if (notificationSetting.present) {
      map['notification_setting'] = Variable<String>($TasksTable
          .$converternotificationSettingn
          .toSql(notificationSetting.value));
    }
    if (notificationHistory.present) {
      map['notification_history'] = Variable<String>($TasksTable
          .$converternotificationHistoryn
          .toSql(notificationHistory.value));
    }
    if (submittedFiles.present) {
      map['submitted_files'] = Variable<String>(
          $TasksTable.$convertersubmittedFilesn.toSql(submittedFiles.value));
    }
    if (completionTime.present) {
      map['completion_time'] = Variable<DateTime>(completionTime.value);
    }
    if (evaluationTime.present) {
      map['evaluation_time'] = Variable<DateTime>(evaluationTime.value);
    }
    if (evaluator.present) {
      map['evaluator'] = Variable<String>(evaluator.value);
    }
    if (attachmentRequired.present) {
      map['attachment_required'] = Variable<bool>(attachmentRequired.value);
    }
    if (submissionRequired.present) {
      map['submission_required'] = Variable<bool>(submissionRequired.value);
    }
    if (cancelled.present) {
      map['cancelled'] = Variable<bool>(cancelled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
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
          ..write('submissionRequired: $submissionRequired, ')
          ..write('cancelled: $cancelled')
          ..write(')'))
        .toString();
  }
}

class $ShopItemsTable extends ShopItems
    with TableInfo<$ShopItemsTable, ShopItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 256),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _creatorIdMeta =
      const VerificationMeta('creatorId');
  @override
  late final GeneratedColumn<int> creatorId = GeneratedColumn<int>(
      'creator_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, imageUrl, cost, isAvailable, creatorId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_items';
  @override
  VerificationContext validateIntegrity(Insertable<ShopItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('creator_id')) {
      context.handle(_creatorIdMeta,
          creatorId.isAcceptableOrUnknown(data['creator_id']!, _creatorIdMeta));
    } else if (isInserting) {
      context.missing(_creatorIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      creatorId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}creator_id'])!,
    );
  }

  @override
  $ShopItemsTable createAlias(String alias) {
    return $ShopItemsTable(attachedDatabase, alias);
  }
}

class ShopItem extends DataClass implements Insertable<ShopItem> {
  /// The unique identifier for the shop item
  final int id;

  /// The title of the item
  final String title;

  /// The description of the item
  final String? description;

  /// The URL of the image
  final String? imageUrl;

  /// The cost of the item in points
  final int cost;

  /// Whether the item is available for redemption
  final bool isAvailable;

  /// The ID of the creator (parent)
  final int creatorId;
  const ShopItem(
      {required this.id,
      required this.title,
      this.description,
      this.imageUrl,
      required this.cost,
      required this.isAvailable,
      required this.creatorId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['cost'] = Variable<int>(cost);
    map['is_available'] = Variable<bool>(isAvailable);
    map['creator_id'] = Variable<int>(creatorId);
    return map;
  }

  ShopItemsCompanion toCompanion(bool nullToAbsent) {
    return ShopItemsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      cost: Value(cost),
      isAvailable: Value(isAvailable),
      creatorId: Value(creatorId),
    );
  }

  factory ShopItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopItem(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      cost: serializer.fromJson<int>(json['cost']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      creatorId: serializer.fromJson<int>(json['creatorId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'cost': serializer.toJson<int>(cost),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'creatorId': serializer.toJson<int>(creatorId),
    };
  }

  ShopItem copyWith(
          {int? id,
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> imageUrl = const Value.absent(),
          int? cost,
          bool? isAvailable,
          int? creatorId}) =>
      ShopItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        cost: cost ?? this.cost,
        isAvailable: isAvailable ?? this.isAvailable,
        creatorId: creatorId ?? this.creatorId,
      );
  ShopItem copyWithCompanion(ShopItemsCompanion data) {
    return ShopItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      cost: data.cost.present ? data.cost.value : this.cost,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      creatorId: data.creatorId.present ? data.creatorId.value : this.creatorId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cost: $cost, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('creatorId: $creatorId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, description, imageUrl, cost, isAvailable, creatorId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.cost == this.cost &&
          other.isAvailable == this.isAvailable &&
          other.creatorId == this.creatorId);
}

class ShopItemsCompanion extends UpdateCompanion<ShopItem> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<int> cost;
  final Value<bool> isAvailable;
  final Value<int> creatorId;
  const ShopItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.cost = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.creatorId = const Value.absent(),
  });
  ShopItemsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required int cost,
    this.isAvailable = const Value.absent(),
    required int creatorId,
  })  : title = Value(title),
        cost = Value(cost),
        creatorId = Value(creatorId);
  static Insertable<ShopItem> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<int>? cost,
    Expression<bool>? isAvailable,
    Expression<int>? creatorId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (cost != null) 'cost': cost,
      if (isAvailable != null) 'is_available': isAvailable,
      if (creatorId != null) 'creator_id': creatorId,
    });
  }

  ShopItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? imageUrl,
      Value<int>? cost,
      Value<bool>? isAvailable,
      Value<int>? creatorId}) {
    return ShopItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      cost: cost ?? this.cost,
      isAvailable: isAvailable ?? this.isAvailable,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (creatorId.present) {
      map['creator_id'] = Variable<int>(creatorId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('cost: $cost, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('creatorId: $creatorId')
          ..write(')'))
        .toString();
  }
}

class $RedemptionsTable extends Redemptions
    with TableInfo<$RedemptionsTable, Redemption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RedemptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _itemTitleMeta =
      const VerificationMeta('itemTitle');
  @override
  late final GeneratedColumn<String> itemTitle = GeneratedColumn<String>(
      'item_title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itemImageUrlMeta =
      const VerificationMeta('itemImageUrl');
  @override
  late final GeneratedColumn<String> itemImageUrl = GeneratedColumn<String>(
      'item_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
      'cost', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _redeemedAtMeta =
      const VerificationMeta('redeemedAt');
  @override
  late final GeneratedColumn<DateTime> redeemedAt = GeneratedColumn<DateTime>(
      'redeemed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, itemTitle, itemImageUrl, cost, redeemedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'redemptions';
  @override
  VerificationContext validateIntegrity(Insertable<Redemption> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_title')) {
      context.handle(_itemTitleMeta,
          itemTitle.isAcceptableOrUnknown(data['item_title']!, _itemTitleMeta));
    } else if (isInserting) {
      context.missing(_itemTitleMeta);
    }
    if (data.containsKey('item_image_url')) {
      context.handle(
          _itemImageUrlMeta,
          itemImageUrl.isAcceptableOrUnknown(
              data['item_image_url']!, _itemImageUrlMeta));
    }
    if (data.containsKey('cost')) {
      context.handle(
          _costMeta, cost.isAcceptableOrUnknown(data['cost']!, _costMeta));
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('redeemed_at')) {
      context.handle(
          _redeemedAtMeta,
          redeemedAt.isAcceptableOrUnknown(
              data['redeemed_at']!, _redeemedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Redemption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Redemption(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      itemTitle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_title'])!,
      itemImageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}item_image_url']),
      cost: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost'])!,
      redeemedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}redeemed_at'])!,
    );
  }

  @override
  $RedemptionsTable createAlias(String alias) {
    return $RedemptionsTable(attachedDatabase, alias);
  }
}

class Redemption extends DataClass implements Insertable<Redemption> {
  /// The unique identifier for the redemption
  final int id;

  /// The ID of the user who redeemed the item
  final int userId;

  /// The title of the redeemed item (snapshot at redemption time)
  final String itemTitle;

  /// The image URL of the redeemed item (snapshot at redemption time)
  final String? itemImageUrl;

  /// The cost of the item at the time of redemption
  final int cost;

  /// The date and time of redemption
  final DateTime redeemedAt;
  const Redemption(
      {required this.id,
      required this.userId,
      required this.itemTitle,
      this.itemImageUrl,
      required this.cost,
      required this.redeemedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['item_title'] = Variable<String>(itemTitle);
    if (!nullToAbsent || itemImageUrl != null) {
      map['item_image_url'] = Variable<String>(itemImageUrl);
    }
    map['cost'] = Variable<int>(cost);
    map['redeemed_at'] = Variable<DateTime>(redeemedAt);
    return map;
  }

  RedemptionsCompanion toCompanion(bool nullToAbsent) {
    return RedemptionsCompanion(
      id: Value(id),
      userId: Value(userId),
      itemTitle: Value(itemTitle),
      itemImageUrl: itemImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(itemImageUrl),
      cost: Value(cost),
      redeemedAt: Value(redeemedAt),
    );
  }

  factory Redemption.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Redemption(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      itemTitle: serializer.fromJson<String>(json['itemTitle']),
      itemImageUrl: serializer.fromJson<String?>(json['itemImageUrl']),
      cost: serializer.fromJson<int>(json['cost']),
      redeemedAt: serializer.fromJson<DateTime>(json['redeemedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'itemTitle': serializer.toJson<String>(itemTitle),
      'itemImageUrl': serializer.toJson<String?>(itemImageUrl),
      'cost': serializer.toJson<int>(cost),
      'redeemedAt': serializer.toJson<DateTime>(redeemedAt),
    };
  }

  Redemption copyWith(
          {int? id,
          int? userId,
          String? itemTitle,
          Value<String?> itemImageUrl = const Value.absent(),
          int? cost,
          DateTime? redeemedAt}) =>
      Redemption(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        itemTitle: itemTitle ?? this.itemTitle,
        itemImageUrl:
            itemImageUrl.present ? itemImageUrl.value : this.itemImageUrl,
        cost: cost ?? this.cost,
        redeemedAt: redeemedAt ?? this.redeemedAt,
      );
  Redemption copyWithCompanion(RedemptionsCompanion data) {
    return Redemption(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      itemTitle: data.itemTitle.present ? data.itemTitle.value : this.itemTitle,
      itemImageUrl: data.itemImageUrl.present
          ? data.itemImageUrl.value
          : this.itemImageUrl,
      cost: data.cost.present ? data.cost.value : this.cost,
      redeemedAt:
          data.redeemedAt.present ? data.redeemedAt.value : this.redeemedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Redemption(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemTitle: $itemTitle, ')
          ..write('itemImageUrl: $itemImageUrl, ')
          ..write('cost: $cost, ')
          ..write('redeemedAt: $redeemedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, itemTitle, itemImageUrl, cost, redeemedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Redemption &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.itemTitle == this.itemTitle &&
          other.itemImageUrl == this.itemImageUrl &&
          other.cost == this.cost &&
          other.redeemedAt == this.redeemedAt);
}

class RedemptionsCompanion extends UpdateCompanion<Redemption> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> itemTitle;
  final Value<String?> itemImageUrl;
  final Value<int> cost;
  final Value<DateTime> redeemedAt;
  const RedemptionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.itemTitle = const Value.absent(),
    this.itemImageUrl = const Value.absent(),
    this.cost = const Value.absent(),
    this.redeemedAt = const Value.absent(),
  });
  RedemptionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String itemTitle,
    this.itemImageUrl = const Value.absent(),
    required int cost,
    this.redeemedAt = const Value.absent(),
  })  : userId = Value(userId),
        itemTitle = Value(itemTitle),
        cost = Value(cost);
  static Insertable<Redemption> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? itemTitle,
    Expression<String>? itemImageUrl,
    Expression<int>? cost,
    Expression<DateTime>? redeemedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (itemTitle != null) 'item_title': itemTitle,
      if (itemImageUrl != null) 'item_image_url': itemImageUrl,
      if (cost != null) 'cost': cost,
      if (redeemedAt != null) 'redeemed_at': redeemedAt,
    });
  }

  RedemptionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<String>? itemTitle,
      Value<String?>? itemImageUrl,
      Value<int>? cost,
      Value<DateTime>? redeemedAt}) {
    return RedemptionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemTitle: itemTitle ?? this.itemTitle,
      itemImageUrl: itemImageUrl ?? this.itemImageUrl,
      cost: cost ?? this.cost,
      redeemedAt: redeemedAt ?? this.redeemedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (itemTitle.present) {
      map['item_title'] = Variable<String>(itemTitle.value);
    }
    if (itemImageUrl.present) {
      map['item_image_url'] = Variable<String>(itemImageUrl.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (redeemedAt.present) {
      map['redeemed_at'] = Variable<DateTime>(redeemedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RedemptionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemTitle: $itemTitle, ')
          ..write('itemImageUrl: $itemImageUrl, ')
          ..write('cost: $cost, ')
          ..write('redeemedAt: $redeemedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $TaskTemplatesTable taskTemplates = $TaskTemplatesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ShopItemsTable shopItems = $ShopItemsTable(this);
  late final $RedemptionsTable redemptions = $RedemptionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, taskTemplates, tasks, shopItems, redemptions];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String username,
  Value<String?> nickname,
  required String password,
  Value<bool> isParent,
  Value<bool> allowSelfHomeworkManagement,
  Value<NotificationSetting?> notificationSettings,
  Value<String?> pointSystemId,
  Value<int> totalPoints,
  Value<int> redeemedPoints,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> username,
  Value<String?> nickname,
  Value<String> password,
  Value<bool> isParent,
  Value<bool> allowSelfHomeworkManagement,
  Value<NotificationSetting?> notificationSettings,
  Value<String?> pointSystemId,
  Value<int> totalPoints,
  Value<int> redeemedPoints,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isParent => $composableBuilder(
      column: $table.isParent, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allowSelfHomeworkManagement => $composableBuilder(
      column: $table.allowSelfHomeworkManagement,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<NotificationSetting?, NotificationSetting,
          String>
      get notificationSettings => $composableBuilder(
          column: $table.notificationSettings,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get pointSystemId => $composableBuilder(
      column: $table.pointSystemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalPoints => $composableBuilder(
      column: $table.totalPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get redeemedPoints => $composableBuilder(
      column: $table.redeemedPoints,
      builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickname => $composableBuilder(
      column: $table.nickname, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isParent => $composableBuilder(
      column: $table.isParent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowSelfHomeworkManagement => $composableBuilder(
      column: $table.allowSelfHomeworkManagement,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationSettings => $composableBuilder(
      column: $table.notificationSettings,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pointSystemId => $composableBuilder(
      column: $table.pointSystemId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalPoints => $composableBuilder(
      column: $table.totalPoints, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get redeemedPoints => $composableBuilder(
      column: $table.redeemedPoints,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<bool> get isParent =>
      $composableBuilder(column: $table.isParent, builder: (column) => column);

  GeneratedColumn<bool> get allowSelfHomeworkManagement => $composableBuilder(
      column: $table.allowSelfHomeworkManagement, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      get notificationSettings => $composableBuilder(
          column: $table.notificationSettings, builder: (column) => column);

  GeneratedColumn<String> get pointSystemId => $composableBuilder(
      column: $table.pointSystemId, builder: (column) => column);

  GeneratedColumn<int> get totalPoints => $composableBuilder(
      column: $table.totalPoints, builder: (column) => column);

  GeneratedColumn<int> get redeemedPoints => $composableBuilder(
      column: $table.redeemedPoints, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String?> nickname = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<bool> isParent = const Value.absent(),
            Value<bool> allowSelfHomeworkManagement = const Value.absent(),
            Value<NotificationSetting?> notificationSettings =
                const Value.absent(),
            Value<String?> pointSystemId = const Value.absent(),
            Value<int> totalPoints = const Value.absent(),
            Value<int> redeemedPoints = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            nickname: nickname,
            password: password,
            isParent: isParent,
            allowSelfHomeworkManagement: allowSelfHomeworkManagement,
            notificationSettings: notificationSettings,
            pointSystemId: pointSystemId,
            totalPoints: totalPoints,
            redeemedPoints: redeemedPoints,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String username,
            Value<String?> nickname = const Value.absent(),
            required String password,
            Value<bool> isParent = const Value.absent(),
            Value<bool> allowSelfHomeworkManagement = const Value.absent(),
            Value<NotificationSetting?> notificationSettings =
                const Value.absent(),
            Value<String?> pointSystemId = const Value.absent(),
            Value<int> totalPoints = const Value.absent(),
            Value<int> redeemedPoints = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            nickname: nickname,
            password: password,
            isParent: isParent,
            allowSelfHomeworkManagement: allowSelfHomeworkManagement,
            notificationSettings: notificationSettings,
            pointSystemId: pointSystemId,
            totalPoints: totalPoints,
            redeemedPoints: redeemedPoints,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$TaskTemplatesTableCreateCompanionBuilder = TaskTemplatesCompanion
    Function({
  Value<int> id,
  required String title,
  required String creator,
  required List<String> assignedUsers,
  Value<List<String>?> tags,
  Value<int> priority,
  Value<int> remind,
  Value<String?> description,
  required RecurrencePattern recurrence,
  Value<RewardInfo?> rewards,
  Value<String?> penalty,
  Value<bool> attachmentRequired,
  Value<bool> submissionRequired,
  required DateTime creationTime,
  required Duration expectedCompletionTimeInMinutes,
  Value<NotificationSetting?> notificationSetting,
});
typedef $$TaskTemplatesTableUpdateCompanionBuilder = TaskTemplatesCompanion
    Function({
  Value<int> id,
  Value<String> title,
  Value<String> creator,
  Value<List<String>> assignedUsers,
  Value<List<String>?> tags,
  Value<int> priority,
  Value<int> remind,
  Value<String?> description,
  Value<RecurrencePattern> recurrence,
  Value<RewardInfo?> rewards,
  Value<String?> penalty,
  Value<bool> attachmentRequired,
  Value<bool> submissionRequired,
  Value<DateTime> creationTime,
  Value<Duration> expectedCompletionTimeInMinutes,
  Value<NotificationSetting?> notificationSetting,
});

class $$TaskTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get assignedUsers => $composableBuilder(
          column: $table.assignedUsers,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get tags => $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remind => $composableBuilder(
      column: $table.remind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<RecurrencePattern, RecurrencePattern, String>
      get recurrence => $composableBuilder(
          column: $table.recurrence,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<RewardInfo?, RewardInfo, String> get rewards =>
      $composableBuilder(
          column: $table.rewards,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get penalty => $composableBuilder(
      column: $table.penalty, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Duration, Duration, int>
      get expectedCompletionTimeInMinutes => $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<NotificationSetting?, NotificationSetting,
          String>
      get notificationSetting => $composableBuilder(
          column: $table.notificationSetting,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$TaskTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get creator => $composableBuilder(
      column: $table.creator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedUsers => $composableBuilder(
      column: $table.assignedUsers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remind => $composableBuilder(
      column: $table.remind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recurrence => $composableBuilder(
      column: $table.recurrence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rewards => $composableBuilder(
      column: $table.rewards, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get penalty => $composableBuilder(
      column: $table.penalty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedCompletionTimeInMinutes =>
      $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationSetting => $composableBuilder(
      column: $table.notificationSetting,
      builder: (column) => ColumnOrderings(column));
}

class $$TaskTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskTemplatesTable> {
  $$TaskTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get creator =>
      $composableBuilder(column: $table.creator, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get assignedUsers =>
      $composableBuilder(
          column: $table.assignedUsers, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get remind =>
      $composableBuilder(column: $table.remind, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurrencePattern, String> get recurrence =>
      $composableBuilder(
          column: $table.recurrence, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RewardInfo?, String> get rewards =>
      $composableBuilder(column: $table.rewards, builder: (column) => column);

  GeneratedColumn<String> get penalty =>
      $composableBuilder(column: $table.penalty, builder: (column) => column);

  GeneratedColumn<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired, builder: (column) => column);

  GeneratedColumn<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired, builder: (column) => column);

  GeneratedColumn<DateTime> get creationTime => $composableBuilder(
      column: $table.creationTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration, int>
      get expectedCompletionTimeInMinutes => $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      get notificationSetting => $composableBuilder(
          column: $table.notificationSetting, builder: (column) => column);
}

class $$TaskTemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaskTemplatesTable,
    TaskTemplate,
    $$TaskTemplatesTableFilterComposer,
    $$TaskTemplatesTableOrderingComposer,
    $$TaskTemplatesTableAnnotationComposer,
    $$TaskTemplatesTableCreateCompanionBuilder,
    $$TaskTemplatesTableUpdateCompanionBuilder,
    (
      TaskTemplate,
      BaseReferences<_$AppDatabase, $TaskTemplatesTable, TaskTemplate>
    ),
    TaskTemplate,
    PrefetchHooks Function()> {
  $$TaskTemplatesTableTableManager(_$AppDatabase db, $TaskTemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> creator = const Value.absent(),
            Value<List<String>> assignedUsers = const Value.absent(),
            Value<List<String>?> tags = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> remind = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<RecurrencePattern> recurrence = const Value.absent(),
            Value<RewardInfo?> rewards = const Value.absent(),
            Value<String?> penalty = const Value.absent(),
            Value<bool> attachmentRequired = const Value.absent(),
            Value<bool> submissionRequired = const Value.absent(),
            Value<DateTime> creationTime = const Value.absent(),
            Value<Duration> expectedCompletionTimeInMinutes =
                const Value.absent(),
            Value<NotificationSetting?> notificationSetting =
                const Value.absent(),
          }) =>
              TaskTemplatesCompanion(
            id: id,
            title: title,
            creator: creator,
            assignedUsers: assignedUsers,
            tags: tags,
            priority: priority,
            remind: remind,
            description: description,
            recurrence: recurrence,
            rewards: rewards,
            penalty: penalty,
            attachmentRequired: attachmentRequired,
            submissionRequired: submissionRequired,
            creationTime: creationTime,
            expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes,
            notificationSetting: notificationSetting,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String creator,
            required List<String> assignedUsers,
            Value<List<String>?> tags = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> remind = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required RecurrencePattern recurrence,
            Value<RewardInfo?> rewards = const Value.absent(),
            Value<String?> penalty = const Value.absent(),
            Value<bool> attachmentRequired = const Value.absent(),
            Value<bool> submissionRequired = const Value.absent(),
            required DateTime creationTime,
            required Duration expectedCompletionTimeInMinutes,
            Value<NotificationSetting?> notificationSetting =
                const Value.absent(),
          }) =>
              TaskTemplatesCompanion.insert(
            id: id,
            title: title,
            creator: creator,
            assignedUsers: assignedUsers,
            tags: tags,
            priority: priority,
            remind: remind,
            description: description,
            recurrence: recurrence,
            rewards: rewards,
            penalty: penalty,
            attachmentRequired: attachmentRequired,
            submissionRequired: submissionRequired,
            creationTime: creationTime,
            expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes,
            notificationSetting: notificationSetting,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskTemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaskTemplatesTable,
    TaskTemplate,
    $$TaskTemplatesTableFilterComposer,
    $$TaskTemplatesTableOrderingComposer,
    $$TaskTemplatesTableAnnotationComposer,
    $$TaskTemplatesTableCreateCompanionBuilder,
    $$TaskTemplatesTableUpdateCompanionBuilder,
    (
      TaskTemplate,
      BaseReferences<_$AppDatabase, $TaskTemplatesTable, TaskTemplate>
    ),
    TaskTemplate,
    PrefetchHooks Function()>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required int templateId,
  required String title,
  Value<String?> description,
  Value<List<String>?> tags,
  Value<int> remind,
  required List<String> assignedUsers,
  Value<RewardInfo?> rewards,
  Value<String?> penalty,
  required DateTime startTime,
  required DateTime dueTime,
  required Duration expectedCompletionTimeInMinutes,
  Value<NotificationSetting?> notificationSetting,
  Value<NotificationHistory?> notificationHistory,
  Value<List<String>?> submittedFiles,
  Value<DateTime?> completionTime,
  Value<DateTime?> evaluationTime,
  Value<String?> evaluator,
  Value<bool> attachmentRequired,
  Value<bool> submissionRequired,
  Value<bool> cancelled,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<int> templateId,
  Value<String> title,
  Value<String?> description,
  Value<List<String>?> tags,
  Value<int> remind,
  Value<List<String>> assignedUsers,
  Value<RewardInfo?> rewards,
  Value<String?> penalty,
  Value<DateTime> startTime,
  Value<DateTime> dueTime,
  Value<Duration> expectedCompletionTimeInMinutes,
  Value<NotificationSetting?> notificationSetting,
  Value<NotificationHistory?> notificationHistory,
  Value<List<String>?> submittedFiles,
  Value<DateTime?> completionTime,
  Value<DateTime?> evaluationTime,
  Value<String?> evaluator,
  Value<bool> attachmentRequired,
  Value<bool> submissionRequired,
  Value<bool> cancelled,
});

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get tags => $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get remind => $composableBuilder(
      column: $table.remind, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get assignedUsers => $composableBuilder(
          column: $table.assignedUsers,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<RewardInfo?, RewardInfo, String> get rewards =>
      $composableBuilder(
          column: $table.rewards,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get penalty => $composableBuilder(
      column: $table.penalty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueTime => $composableBuilder(
      column: $table.dueTime, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Duration, Duration, int>
      get expectedCompletionTimeInMinutes => $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<NotificationSetting?, NotificationSetting,
          String>
      get notificationSetting => $composableBuilder(
          column: $table.notificationSetting,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<NotificationHistory?, NotificationHistory,
          String>
      get notificationHistory => $composableBuilder(
          column: $table.notificationHistory,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>?, List<String>, String>
      get submittedFiles => $composableBuilder(
          column: $table.submittedFiles,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get completionTime => $composableBuilder(
      column: $table.completionTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get evaluationTime => $composableBuilder(
      column: $table.evaluationTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get evaluator => $composableBuilder(
      column: $table.evaluator, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cancelled => $composableBuilder(
      column: $table.cancelled, builder: (column) => ColumnFilters(column));
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remind => $composableBuilder(
      column: $table.remind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignedUsers => $composableBuilder(
      column: $table.assignedUsers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rewards => $composableBuilder(
      column: $table.rewards, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get penalty => $composableBuilder(
      column: $table.penalty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueTime => $composableBuilder(
      column: $table.dueTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedCompletionTimeInMinutes =>
      $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationSetting => $composableBuilder(
      column: $table.notificationSetting,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationHistory => $composableBuilder(
      column: $table.notificationHistory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get submittedFiles => $composableBuilder(
      column: $table.submittedFiles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completionTime => $composableBuilder(
      column: $table.completionTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get evaluationTime => $composableBuilder(
      column: $table.evaluationTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get evaluator => $composableBuilder(
      column: $table.evaluator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cancelled => $composableBuilder(
      column: $table.cancelled, builder: (column) => ColumnOrderings(column));
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get remind =>
      $composableBuilder(column: $table.remind, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get assignedUsers =>
      $composableBuilder(
          column: $table.assignedUsers, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RewardInfo?, String> get rewards =>
      $composableBuilder(column: $table.rewards, builder: (column) => column);

  GeneratedColumn<String> get penalty =>
      $composableBuilder(column: $table.penalty, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Duration, int>
      get expectedCompletionTimeInMinutes => $composableBuilder(
          column: $table.expectedCompletionTimeInMinutes,
          builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationSetting?, String>
      get notificationSetting => $composableBuilder(
          column: $table.notificationSetting, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationHistory?, String>
      get notificationHistory => $composableBuilder(
          column: $table.notificationHistory, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>?, String> get submittedFiles =>
      $composableBuilder(
          column: $table.submittedFiles, builder: (column) => column);

  GeneratedColumn<DateTime> get completionTime => $composableBuilder(
      column: $table.completionTime, builder: (column) => column);

  GeneratedColumn<DateTime> get evaluationTime => $composableBuilder(
      column: $table.evaluationTime, builder: (column) => column);

  GeneratedColumn<String> get evaluator =>
      $composableBuilder(column: $table.evaluator, builder: (column) => column);

  GeneratedColumn<bool> get attachmentRequired => $composableBuilder(
      column: $table.attachmentRequired, builder: (column) => column);

  GeneratedColumn<bool> get submissionRequired => $composableBuilder(
      column: $table.submissionRequired, builder: (column) => column);

  GeneratedColumn<bool> get cancelled =>
      $composableBuilder(column: $table.cancelled, builder: (column) => column);
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> templateId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<List<String>?> tags = const Value.absent(),
            Value<int> remind = const Value.absent(),
            Value<List<String>> assignedUsers = const Value.absent(),
            Value<RewardInfo?> rewards = const Value.absent(),
            Value<String?> penalty = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> dueTime = const Value.absent(),
            Value<Duration> expectedCompletionTimeInMinutes =
                const Value.absent(),
            Value<NotificationSetting?> notificationSetting =
                const Value.absent(),
            Value<NotificationHistory?> notificationHistory =
                const Value.absent(),
            Value<List<String>?> submittedFiles = const Value.absent(),
            Value<DateTime?> completionTime = const Value.absent(),
            Value<DateTime?> evaluationTime = const Value.absent(),
            Value<String?> evaluator = const Value.absent(),
            Value<bool> attachmentRequired = const Value.absent(),
            Value<bool> submissionRequired = const Value.absent(),
            Value<bool> cancelled = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            templateId: templateId,
            title: title,
            description: description,
            tags: tags,
            remind: remind,
            assignedUsers: assignedUsers,
            rewards: rewards,
            penalty: penalty,
            startTime: startTime,
            dueTime: dueTime,
            expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes,
            notificationSetting: notificationSetting,
            notificationHistory: notificationHistory,
            submittedFiles: submittedFiles,
            completionTime: completionTime,
            evaluationTime: evaluationTime,
            evaluator: evaluator,
            attachmentRequired: attachmentRequired,
            submissionRequired: submissionRequired,
            cancelled: cancelled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int templateId,
            required String title,
            Value<String?> description = const Value.absent(),
            Value<List<String>?> tags = const Value.absent(),
            Value<int> remind = const Value.absent(),
            required List<String> assignedUsers,
            Value<RewardInfo?> rewards = const Value.absent(),
            Value<String?> penalty = const Value.absent(),
            required DateTime startTime,
            required DateTime dueTime,
            required Duration expectedCompletionTimeInMinutes,
            Value<NotificationSetting?> notificationSetting =
                const Value.absent(),
            Value<NotificationHistory?> notificationHistory =
                const Value.absent(),
            Value<List<String>?> submittedFiles = const Value.absent(),
            Value<DateTime?> completionTime = const Value.absent(),
            Value<DateTime?> evaluationTime = const Value.absent(),
            Value<String?> evaluator = const Value.absent(),
            Value<bool> attachmentRequired = const Value.absent(),
            Value<bool> submissionRequired = const Value.absent(),
            Value<bool> cancelled = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            templateId: templateId,
            title: title,
            description: description,
            tags: tags,
            remind: remind,
            assignedUsers: assignedUsers,
            rewards: rewards,
            penalty: penalty,
            startTime: startTime,
            dueTime: dueTime,
            expectedCompletionTimeInMinutes: expectedCompletionTimeInMinutes,
            notificationSetting: notificationSetting,
            notificationHistory: notificationHistory,
            submittedFiles: submittedFiles,
            completionTime: completionTime,
            evaluationTime: evaluationTime,
            evaluator: evaluator,
            attachmentRequired: attachmentRequired,
            submissionRequired: submissionRequired,
            cancelled: cancelled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
    Task,
    PrefetchHooks Function()>;
typedef $$ShopItemsTableCreateCompanionBuilder = ShopItemsCompanion Function({
  Value<int> id,
  required String title,
  Value<String?> description,
  Value<String?> imageUrl,
  required int cost,
  Value<bool> isAvailable,
  required int creatorId,
});
typedef $$ShopItemsTableUpdateCompanionBuilder = ShopItemsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String?> description,
  Value<String?> imageUrl,
  Value<int> cost,
  Value<bool> isAvailable,
  Value<int> creatorId,
});

class $$ShopItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShopItemsTable> {
  $$ShopItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnFilters(column));
}

class $$ShopItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopItemsTable> {
  $$ShopItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get creatorId => $composableBuilder(
      column: $table.creatorId, builder: (column) => ColumnOrderings(column));
}

class $$ShopItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopItemsTable> {
  $$ShopItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<int> get creatorId =>
      $composableBuilder(column: $table.creatorId, builder: (column) => column);
}

class $$ShopItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShopItemsTable,
    ShopItem,
    $$ShopItemsTableFilterComposer,
    $$ShopItemsTableOrderingComposer,
    $$ShopItemsTableAnnotationComposer,
    $$ShopItemsTableCreateCompanionBuilder,
    $$ShopItemsTableUpdateCompanionBuilder,
    (ShopItem, BaseReferences<_$AppDatabase, $ShopItemsTable, ShopItem>),
    ShopItem,
    PrefetchHooks Function()> {
  $$ShopItemsTableTableManager(_$AppDatabase db, $ShopItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<int> cost = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<int> creatorId = const Value.absent(),
          }) =>
              ShopItemsCompanion(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            cost: cost,
            isAvailable: isAvailable,
            creatorId: creatorId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            required int cost,
            Value<bool> isAvailable = const Value.absent(),
            required int creatorId,
          }) =>
              ShopItemsCompanion.insert(
            id: id,
            title: title,
            description: description,
            imageUrl: imageUrl,
            cost: cost,
            isAvailable: isAvailable,
            creatorId: creatorId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShopItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShopItemsTable,
    ShopItem,
    $$ShopItemsTableFilterComposer,
    $$ShopItemsTableOrderingComposer,
    $$ShopItemsTableAnnotationComposer,
    $$ShopItemsTableCreateCompanionBuilder,
    $$ShopItemsTableUpdateCompanionBuilder,
    (ShopItem, BaseReferences<_$AppDatabase, $ShopItemsTable, ShopItem>),
    ShopItem,
    PrefetchHooks Function()>;
typedef $$RedemptionsTableCreateCompanionBuilder = RedemptionsCompanion
    Function({
  Value<int> id,
  required int userId,
  required String itemTitle,
  Value<String?> itemImageUrl,
  required int cost,
  Value<DateTime> redeemedAt,
});
typedef $$RedemptionsTableUpdateCompanionBuilder = RedemptionsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<String> itemTitle,
  Value<String?> itemImageUrl,
  Value<int> cost,
  Value<DateTime> redeemedAt,
});

class $$RedemptionsTableFilterComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemTitle => $composableBuilder(
      column: $table.itemTitle, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemImageUrl => $composableBuilder(
      column: $table.itemImageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get redeemedAt => $composableBuilder(
      column: $table.redeemedAt, builder: (column) => ColumnFilters(column));
}

class $$RedemptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemTitle => $composableBuilder(
      column: $table.itemTitle, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemImageUrl => $composableBuilder(
      column: $table.itemImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cost => $composableBuilder(
      column: $table.cost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get redeemedAt => $composableBuilder(
      column: $table.redeemedAt, builder: (column) => ColumnOrderings(column));
}

class $$RedemptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemTitle =>
      $composableBuilder(column: $table.itemTitle, builder: (column) => column);

  GeneratedColumn<String> get itemImageUrl => $composableBuilder(
      column: $table.itemImageUrl, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<DateTime> get redeemedAt => $composableBuilder(
      column: $table.redeemedAt, builder: (column) => column);
}

class $$RedemptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RedemptionsTable,
    Redemption,
    $$RedemptionsTableFilterComposer,
    $$RedemptionsTableOrderingComposer,
    $$RedemptionsTableAnnotationComposer,
    $$RedemptionsTableCreateCompanionBuilder,
    $$RedemptionsTableUpdateCompanionBuilder,
    (Redemption, BaseReferences<_$AppDatabase, $RedemptionsTable, Redemption>),
    Redemption,
    PrefetchHooks Function()> {
  $$RedemptionsTableTableManager(_$AppDatabase db, $RedemptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RedemptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RedemptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RedemptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<String> itemTitle = const Value.absent(),
            Value<String?> itemImageUrl = const Value.absent(),
            Value<int> cost = const Value.absent(),
            Value<DateTime> redeemedAt = const Value.absent(),
          }) =>
              RedemptionsCompanion(
            id: id,
            userId: userId,
            itemTitle: itemTitle,
            itemImageUrl: itemImageUrl,
            cost: cost,
            redeemedAt: redeemedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required String itemTitle,
            Value<String?> itemImageUrl = const Value.absent(),
            required int cost,
            Value<DateTime> redeemedAt = const Value.absent(),
          }) =>
              RedemptionsCompanion.insert(
            id: id,
            userId: userId,
            itemTitle: itemTitle,
            itemImageUrl: itemImageUrl,
            cost: cost,
            redeemedAt: redeemedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RedemptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RedemptionsTable,
    Redemption,
    $$RedemptionsTableFilterComposer,
    $$RedemptionsTableOrderingComposer,
    $$RedemptionsTableAnnotationComposer,
    $$RedemptionsTableCreateCompanionBuilder,
    $$RedemptionsTableUpdateCompanionBuilder,
    (Redemption, BaseReferences<_$AppDatabase, $RedemptionsTable, Redemption>),
    Redemption,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$TaskTemplatesTableTableManager get taskTemplates =>
      $$TaskTemplatesTableTableManager(_db, _db.taskTemplates);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ShopItemsTableTableManager get shopItems =>
      $$ShopItemsTableTableManager(_db, _db.shopItems);
  $$RedemptionsTableTableManager get redemptions =>
      $$RedemptionsTableTableManager(_db, _db.redemptions);
}
