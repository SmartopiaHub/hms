// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.


import 'package:drift/drift.dart';
import 'recurrence.dart';
import 'notification.dart';

/// A converter to store and retrieve RecurrencePattern objects in the database.
JsonTypeConverter2<RecurrencePattern, String, Object?> recurrencePatternConverter =
    TypeConverter.json2(
  fromJson: (json) => RecurrencePattern.fromJson(json! as Map<String, Object?>),
  toJson: (pref) => pref.toJson(),
);

/// A converter to store and retrieve NotificationSetting objects in the database.
JsonTypeConverter2<NotificationSetting, String, Object?> notificationSettingConverter =
    TypeConverter.json2(
  fromJson: (json) => NotificationSetting.fromJson(json! as Map<String, Object?>),
  toJson: (pref) => pref.toJson(),
);

/// A converter to store and retrieve NotificationSetting objects in the database.
JsonTypeConverter2<NotificationHistory, String, Object?> notificationHistoryConverter =
    TypeConverter.json2(
  fromJson: (json) => NotificationHistory.fromJson(json! as Map<String, Object?>),
  toJson: (pref) => pref.toJson(),
);

/// A reusable converter that stores a `List<String>` as JSON text.
final JsonTypeConverter2<List<String>, String, Object?> stringListConverter =
  TypeConverter.json2(
    fromJson: (json) => (json! as List<dynamic>).map((e) => e.toString()).cast<String>().toList(),
    toJson: (list) => list,
  );

/// A reusable converter that stores a `List<int>` as JSON text.
final JsonTypeConverter2<List<int>, String, Object?> intListConverter =
  TypeConverter.json2(
    fromJson: (json) => (json! as List<dynamic>).map((e) => e as int).cast<int>().toList(),
    toJson: (list) => list,
  );



/// A converter to store and retrieve Duration objects in the database.
class DurationConverter extends TypeConverter<Duration, int> with
        JsonTypeConverter2<Duration, int, Object?>
{

  const DurationConverter();

  @override
  Duration fromJson(Object? json) {
    if (json is int) {
      return Duration(minutes: json);
    } else if (json is String) {
      return Duration(minutes: int.parse(json));
    } else {
      throw Exception('Invalid JSON format for Duration');
    }
  }

  @override
  Object? toJson(Duration value) {
    return value.inMinutes;
  }

  @override
  Duration fromSql(int fromDb) {
    return Duration(minutes: fromDb);
  }

  @override
  int toSql(Duration value) {
    return value.inMinutes;
  }
}