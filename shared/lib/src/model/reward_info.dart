// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

class RewardInfo {
  final int? maxPoints;
  final int? pointsAwarded;
  final String? description;

  const RewardInfo({
    this.maxPoints,
    this.pointsAwarded,
    this.description,
  });

  factory RewardInfo.fromJson(Map<String, dynamic> json) {
    return RewardInfo(
      maxPoints: json['max_points'] as int?,
      pointsAwarded: json['points_awarded'] != null ? int.tryParse(json['points_awarded'].toString()) : null,
      description: json['others'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (maxPoints != null) 'max_points': maxPoints,
      if (pointsAwarded != null) 'points_awarded': pointsAwarded,
      if (description != null) 'others': description,
    };
  }
  
  RewardInfo copyWith({
    int? maxPoints,
    int? pointsAwarded,
    String? description,
  }) {
    return RewardInfo(
      maxPoints: maxPoints ?? this.maxPoints,
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'RewardInfo(maxPoints: $maxPoints, pointsAwarded: $pointsAwarded, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is RewardInfo &&
      other.maxPoints == maxPoints &&
      other.pointsAwarded == pointsAwarded &&
      other.description == description;
  }

  @override
  int get hashCode => maxPoints.hashCode ^ pointsAwarded.hashCode ^ description.hashCode;
}



class RewardPointInfo {
  final int totalPoints;
  final int redeemedPoints;

  int get availablePoints => totalPoints - redeemedPoints;

  const RewardPointInfo({
    required this.totalPoints,
    required this.redeemedPoints,
  });

  factory RewardPointInfo.fromJson(Map<String, dynamic> json) {
    return RewardPointInfo(
      totalPoints: json['total_points'] as int? ?? 0,
      redeemedPoints: json['redeemed_points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'redeemed_points': redeemedPoints,
    };
  }
}
