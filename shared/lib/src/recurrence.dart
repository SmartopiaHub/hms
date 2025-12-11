// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

/// Utility function to get the number of days in a given month/year.
int _daysInMonth(int year, int month) {
  final nextMonth = month < 12 ? month + 1 : 1;
  final nextYear = month < 12 ? year : year + 1;
  return DateTime(nextYear, nextMonth, 1).subtract(Duration(days: 1)).day;
}

DateTime get startOfToday {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

DateTime endOfDate(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59);
}

DateTime startOfDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime startOfHour(DateTime date) {
  return DateTime(date.year, date.month, date.day, date.hour);
}

DateTime startOfYear(DateTime date) {
  return DateTime(date.year, 1, 1);
}

/// Returns the [DayOfWeek] for a given [DateTime].
DayOfWeek dayOfWeek(DateTime date) {
  return DayOfWeek.fromInt(date.weekday);
}

/// Enum representing days of the week, with Monday as 1.
enum DayOfWeek {
  
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Returns the integer value of the day, where Monday is 1, ..., Saturday is 7.
  int get value => index+1;

  /// Creates a [DayOfWeek] from an integer (1 = Monday, 7 = Saturday).
  factory DayOfWeek.fromInt(int day) {
    if (day < 1 || day > 7) {
      throw ArgumentError('Day must be in range 1 (Monday) to 7 (Sunday)');
    }
    return DayOfWeek.values[day-1];
  }
}

class TimeOfDay implements Comparable<TimeOfDay> {
  final int hour;
  final int minute;

  TimeOfDay({required this.hour, required this.minute}): assert(hour >= 0 && hour <= 23),
        assert(minute >= 0 && minute <= 59);

  @override
  String toString() => '$hour:$minute';

  /// Converts a TimeOfDay to a DateTime object.
  DateTime toDateTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  /// Converts a DateTime object to a TimeOfDay.
  static TimeOfDay fromDateTime(DateTime date) {
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  factory TimeOfDay.fromString(String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      throw ArgumentError('Invalid time format: $time');
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw ArgumentError('Invalid time: $time');
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is TimeOfDay && runtimeType == other.runtimeType && hour == other.hour && minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;

  bool operator <(TimeOfDay other) {
    if (hour != other.hour) return hour < other.hour;
    return minute < other.minute;
  }

  bool operator >(TimeOfDay other) {
    if (hour != other.hour) return hour > other.hour;
    return minute > other.minute;
  }

  bool operator <=(TimeOfDay other) => this < other || this == other;

  bool operator >=(TimeOfDay other) => this > other || this == other;
  
  @override
  int compareTo(TimeOfDay other) {
    if (hour != other.hour) return hour.compareTo(other.hour);
    return minute.compareTo(other.minute);
  }
  
}

/// Enum representing all recurrence pattern types.
enum RecurrencePatternType {
  once,
  hourly,
  daily,
  weekly,
  monthly,
  yearly,
  custom;

  /// Creates a [RecurrencePatternType] from a string.
  /// Throws an [ArgumentError] if the string does not match any type.
  factory RecurrencePatternType.fromString(String type) {
    switch (type) {
      case 'once':
        return RecurrencePatternType.once;
      case 'hourly':
        return RecurrencePatternType.hourly;
      case 'daily':
        return RecurrencePatternType.daily;
      case 'weekly':
        return RecurrencePatternType.weekly;
      case 'monthly':
        return RecurrencePatternType.monthly;
      case 'yearly':
        return RecurrencePatternType.yearly;
      case 'custom':
        return RecurrencePatternType.custom;
      default:
        throw ArgumentError('Unknown recurrence pattern type: $type');
    }
  }
}

/// Abstract base class for all recurrence patterns.
///
/// Each pattern represents how an event recurs over time, with a mandatory
/// [startDateTime] and an optional [stopRecurrenceAfter] DateTime (null means no end).
/// An optional [dueDateTime] can be set for the first occurrence. For recurrent patterns, 
/// the due time for an occurrence is the start time of the occurrence plus the [duration].
/// Subclasses must implement [type], indicating the recurrence type, [next], returning the 
/// next occurrence after an optional DateTime (defaults to now),
/// and JSON serialization methods [toJson] and [fromJson].
abstract class RecurrencePattern {
  /// The start date and time of the recurrence, which is also the first occurrence.
  DateTime startDateTime;

  /// The optional due date and time for the first recurrence.
  /// For recurrent patterns, the due time for an occurrence is the start time of the occurrence plus the [duration].
  DateTime? dueDateTime;

  /// Stop date and time for recurrence.
  /// If null, the pattern recurs indefinitely.
  DateTime? stopRecurrenceAfter;

  /// Constructs a recurrence pattern with [startDateTime] and optional [dueDateTime] and [stopRecurrenceAfter].
  RecurrencePattern({required this.startDateTime, this.dueDateTime, this.stopRecurrenceAfter});

  /// Returns true if there is no next occurrence.
  bool get hasNext => next() != null;

  /// Duration of the recurrence, when [dueDateTime] is set.
  Duration? get duration => dueDateTime?.difference(startDateTime);

  /// Returns the type of this recurrence pattern.
  RecurrencePatternType get type;

  /// Computes the next occurrence strictly after [after].
  /// If [after] is null, defaults to now.
  /// Returns null if there is no next occurrence.
  DateTime? next([DateTime? after]);

  /// Return the occurrences of this pattern strictly after [after] and on/before [beforeOrOn].
  /// If [after] is null, defaults to now.
  /// If [beforeOrOn] is null, there is no upper limit.
  /// If [count] is provided, limits the number of the nearest (with reference to [after]) occurrences returned.
  /// Throw exception if neither [beforeOrOn] nor [count] is provided.
  List<DateTime> occurrences({DateTime? after, DateTime? beforeOrOn, int? count}) {
    if (beforeOrOn == null && count == null) {
      throw ArgumentError('At least one of beforeOrOn or count must be provided');
    }
    final occurrences = <DateTime>[];
    after ??= DateTime.now();
    DateTime? nextOccurrence = next(after);
    while (nextOccurrence != null) {
      if (beforeOrOn != null && nextOccurrence.isAfter(beforeOrOn)) {
        break;
      }
      if (count != null && occurrences.length >= count) {
        break;
      }
      occurrences.add(nextOccurrence);
      nextOccurrence = next(nextOccurrence);
    }
    return occurrences;
  }

  /// Serializes this pattern to JSON.
  Map<String, dynamic> toJson();

  Map<String, dynamic> _toJson() {
    return {
      'type': type.name,
      'startDateTime': startDateTime.toIso8601String(),
      'dueDateTime': dueDateTime?.toIso8601String(),
      'stopRecurrenceAfter': stopRecurrenceAfter?.toIso8601String(),
    };
  }

  

  /// Deserializes a pattern from JSON.
  factory RecurrencePattern.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'once':
        return OncePattern.fromJson(json);
      case 'hourly':
        return HourlyPattern.fromJson(json);
      case 'daily':
        return DailyPattern.fromJson(json);
      case 'weekly':
        return WeeklyPattern.fromJson(json);
      case 'monthly':
        return MonthlyPattern.fromJson(json);
      case 'yearly':
        return YearlyPattern.fromJson(json);
      case 'custom':
        return CustomPattern.fromJson(json);
      default:
        throw ArgumentError('Unknown recurrence type: ${json['type']}');
    }
  }

  factory RecurrencePattern.defaultPattern(RecurrencePatternType type) {
    final now = startOfHour(DateTime.now()..add(Duration(hours: 1)));
    switch (type) {
      case RecurrencePatternType.once:
        return OncePattern(startDateTime: now, dueDateTime: now.add(const Duration(hours: 1)));
      case RecurrencePatternType.hourly:
        return HourlyPattern(startDateTime: now, minutes: [0]);
      case RecurrencePatternType.daily:
        return DailyPattern(startDateTime: now, times: [TimeOfDay(hour: now.hour, minute: 0)]);
      case RecurrencePatternType.weekly:
        return WeeklyPattern(startDateTime: now, weekdays: [now.weekday], times: [TimeOfDay(hour: 0, minute: 0)]);
      case RecurrencePatternType.monthly:
        return MonthlyPattern(startDateTime: now, daysOfMonth: [now.day], times: [TimeOfDay(hour: now.hour, minute: 0)]);
      case RecurrencePatternType.yearly:
        return YearlyPattern(startDateTime: now, monthDays: [MonthDay(month: now.month, day: now.day)], times: [TimeOfDay(hour: now.hour, minute: 0)]);
      case RecurrencePatternType.custom:
        return CustomPattern(startDateTime: now, intervalMinutes: 60);
    }
  }
}

DateTime readStartDateTime(Map<String, dynamic> json) {
    final start = json['startDateTime'] as String?;
    if (start == null) {
      throw ArgumentError('startDateTime is required');
    }
    return DateTime.parse(start);
}

DateTime? readDueDateTime(Map<String, dynamic> json) {
    final due = json['dueDateTime'] as String?;
    if (due == null) {
      return null;
    }
    return DateTime.parse(due);
}
  
DateTime? readStopRecurrenceAfter(Map<String, dynamic> json) {
    final stop = json['stopRecurrenceAfter'] as String?;
    if (stop == null) {
      return null;
    }
    return DateTime.parse(stop);
}

/// A one-time occurrence (no recurrence beyond the start).
class OncePattern extends RecurrencePattern {
  OncePattern({required super.startDateTime, super.dueDateTime})
      : assert(dueDateTime == null || dueDateTime.isAfter(startDateTime));

  @override
  RecurrencePatternType get type => RecurrencePatternType.once;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    if (startDateTime.isAfter(after)){ 
      return startDateTime;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson();

  static OncePattern fromJson(Map<String, dynamic> json) => OncePattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
      );
}

/// Recurs every hour at specified [minutes] within each hour.
class HourlyPattern extends RecurrencePattern {
  final List<int> minutes;

  HourlyPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.minutes})
      : assert(minutes.every((m) => m >= 0 && m <= 59));

  @override
  RecurrencePatternType get type => RecurrencePatternType.hourly;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    final pivot = startOfHour(after.isAfter(startDateTime) ? after : startDateTime);
    for (int i = 0; i < 3; i++) {
      final candidate = pivot.add(Duration(hours: i));
      final year = candidate.year;
      final month = candidate.month;
      final day = candidate.day;
      final hour = candidate.hour;
      for (final m in minutes..sort()) {
        final dt = DateTime(year, month, day, hour, m);
        if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
          return dt;
        }
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll({
        'minutes': minutes,
      });

  static HourlyPattern fromJson(Map<String, dynamic> json) => HourlyPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        minutes: List<int>.from(json['minutes'] as List),
      );
}

/// Recurs at each of specified [times] within each day, starting from [startDateTime].
class DailyPattern extends RecurrencePattern {
  final List<TimeOfDay> times;

  DailyPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.times});

  @override
  RecurrencePatternType get type => RecurrencePatternType.daily;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    var pivot = startOfDate(after.isAfter(startDateTime) ? after : startDateTime); 
    var candidates = <DateTime>[];
    for (final h in times) {
      final dt = DateTime(pivot.year, pivot.month, pivot.day, h.hour, h.minute);
      if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
        candidates.add(dt);
      }
    }
    
    if (candidates.isEmpty) {
      // If no candidates today, check tomorrow
      pivot = pivot.add(const Duration(days: 1));
      for (final h in times) {
        final dt = DateTime(pivot.year, pivot.month, pivot.day, h.hour, h.minute);
        if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
          candidates.add(dt);
        }
      }
    } 

    if (candidates.isNotEmpty) {
      candidates.sort();
      return candidates.first;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll({
        'times': times.map((h) => h.toString()).toList(),
      });

  static DailyPattern fromJson(Map<String, dynamic> json) => DailyPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        times: List<TimeOfDay>.from((json['times']).map((h)=>TimeOfDay.fromString(h))),
      );
}

/// Recurs weekly at each time in [times] on specified [weekdays].
class WeeklyPattern extends RecurrencePattern {
  final List<int> weekdays;

  final List<TimeOfDay> times;

  WeeklyPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.weekdays, required this.times})
      : assert(weekdays.every(((d) => d >= 1 && d <= 7)));

  @override
  RecurrencePatternType get type => RecurrencePatternType.weekly;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    final pivot = startOfDate(after.isAfter(startDateTime) ? after : startDateTime);
    final candidates = <DateTime>[];
    
    for (int i = 0; i < 7; i++) {
      var candidateDay = pivot.add(Duration(days: i));
      if (weekdays.contains(candidateDay.weekday)) {
        for (final h in times) {
          final dt = DateTime(candidateDay.year, candidateDay.month, candidateDay.day, h.hour, h.minute);
          if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
            candidates.add(dt);
          }
        }
      }
    }
    if (candidates.isNotEmpty) {
      candidates.sort();
      return candidates.first;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll(
  {
        'weekdays': weekdays,
        'times': times.map((h) => h.toString()).toList(),
  });

  static WeeklyPattern fromJson(Map<String, dynamic> json) => WeeklyPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        weekdays: List<int>.from(json['weekdays'] as List),
        times: List<TimeOfDay>.from((json['times'] as List<dynamic>).map((h)=>TimeOfDay.fromString(h))),
      );
}

/// Recurs monthly at each time of [times] on specified [daysOfMonth].
class MonthlyPattern extends RecurrencePattern {
  final List<int> daysOfMonth;

  final List<TimeOfDay> times;

  /// The [daysOfMonth] list must contain integers between 1 and 32.
  /// 32 means the last day of the month. For example, if the month has 30 days,
  /// the 32nd day will be the 30th.
  MonthlyPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.daysOfMonth, required this.times})
      : assert(daysOfMonth.every(((d) => d >= 1 && d <= 32)));

  static const int lastDayOfMonth = 32;

  @override
  RecurrencePatternType get type => RecurrencePatternType.monthly;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    final pivot = startOfDate(after.isAfter(startDateTime) ? after :startDateTime); 
    
    final candidates = <DateTime>[];
    for (int i = 0; i < 32; i++) {
      final candidateDay= pivot.add(Duration(days: i));
      if (daysOfMonth.contains(candidateDay.day)) {
        for (final h in times) {
          final dt = DateTime(candidateDay.year, candidateDay.month, candidateDay.day, h.hour, h.minute);
          if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
            candidates.add(dt);
          }
        }
      }
      
    }

    if (daysOfMonth.contains(lastDayOfMonth)) {
      final lastDay = _daysInMonth(pivot.year, pivot.month);
      for (final h in times) {
          final dt = DateTime(pivot.year, pivot.month, lastDay, h.hour, h.minute);
          if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
            candidates.add(dt);
          }
        }
    }

    if (candidates.isNotEmpty) {
      candidates.sort();
      return candidates.first;
    }

    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll(
    {
        'daysOfMonth': daysOfMonth,
        'times': times.map((h) => h.toString()).toList(),
      });

  static MonthlyPattern fromJson(Map<String, dynamic> json) => MonthlyPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        daysOfMonth: List<int>.from(json['daysOfMonth'] as List),
        times: List<TimeOfDay>.from((json['times'] as List<dynamic>).map((h)=>TimeOfDay.fromString(h))),
      );
}

class MonthDay {
  final int month; // 1 = January, ..., 12 = December
  final int day; // 1 = 1st, ..., 31 = 31st (32 means last day of the month)

  MonthDay({required this.month, required this.day})
      : assert(month >= 1 && month <= 12),
        assert(day >= 1 && day <= 32);

  factory MonthDay.fromString(String str) {
    final parts = str.split('/');
    if (parts.length != 2) {
      throw ArgumentError('Invalid month/day format: $str');
    }
    final month = int.parse(parts[0]);
    final day = int.parse(parts[1]);
    return MonthDay(month: month, day: day);
  }

  @override
  String toString() => '$month/$day';
}

/// Recurs yearly on specified month/day pairs.
class YearlyPattern extends RecurrencePattern {
  

  final List<TimeOfDay> times;

  final List<MonthDay> monthDays;

  YearlyPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.monthDays, required this.times});

  @override
  RecurrencePatternType get type => RecurrencePatternType.yearly;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    var pivot = startOfYear(after.isAfter(startDateTime) ? after : startDateTime);
    final List<DateTime> candidates = [];
    for (int y = 0; y < 2; y++) {
      final year = pivot.year + y; 
      for (final md in monthDays) {
        late DateTime date;
        if (md.day == MonthlyPattern.lastDayOfMonth){
          date = DateTime(pivot.year, md.month, _daysInMonth(pivot.year, md.month));
        }
        if (md.day > _daysInMonth(pivot.year, md.month)) {
          continue;
        } else{
          date = DateTime(pivot.year, md.month, md.day);
        }
        for (final h in times) {
          final dt = DateTime(year, date.month, date.day, h.hour, h.minute);
          if (dt.isAfter(after) && (stopRecurrenceAfter == null || !dt.isAfter(stopRecurrenceAfter!))) {
            candidates.add(dt);
          }
        }
      }
    }

    if (candidates.isNotEmpty) {
      candidates.sort();
      return candidates.first;
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll(
  {
        'monthDays': monthDays.map((md) => md.toString()).toList(),
        'times': times.map((h) => h.toString()).toList(),
      });

  static YearlyPattern fromJson(Map<String, dynamic> json) => YearlyPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        monthDays: List<MonthDay>.from((json['monthDays'] as List<dynamic>).map((md) => MonthDay.fromString(md as String))),
        times: List<TimeOfDay>.from((json['times'] as List<dynamic>).map((h)=>TimeOfDay.fromString(h))),
      );
}

/// Recurs at a custom interval in minutes.
class CustomPattern extends RecurrencePattern {
  final int intervalMinutes;

  CustomPattern({required super.startDateTime, super.dueDateTime, super.stopRecurrenceAfter, required this.intervalMinutes})
      : assert(intervalMinutes > 0);

  @override
  RecurrencePatternType get type => RecurrencePatternType.custom;

  @override
  DateTime? next([DateTime? after]) {
    after ??= DateTime.now();
    final diffInMinutes = startDateTime.difference(after).inMinutes;
    if (diffInMinutes < 0) {
      // If the start time is in the past, calculate the next occurrence
      final nextOccurrence = startDateTime.add(Duration(minutes: ((-diffInMinutes + intervalMinutes - 1) ~/ intervalMinutes) * intervalMinutes));
      if (stopRecurrenceAfter == null || !nextOccurrence.isAfter(stopRecurrenceAfter!)) {
        return nextOccurrence;
      }
    } else { // If the start time is in the future, return it directly
      return startDateTime;
    }

    return null;
  }

  @override
  Map<String, dynamic> toJson() => _toJson()..addAll(
    {
        'intervalMinutes': intervalMinutes,
      });

  static CustomPattern fromJson(Map<String, dynamic> json) => CustomPattern(
        startDateTime: readStartDateTime(json),
        dueDateTime: readDueDateTime(json),
        stopRecurrenceAfter: readStopRecurrenceAfter(json),
        intervalMinutes: json['intervalMinutes'] as int,
      );
}
