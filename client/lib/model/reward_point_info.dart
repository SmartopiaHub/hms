
// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.
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
      totalPoints: json['total_points'] as int,
      redeemedPoints: json['redeemed_points'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_points': totalPoints,
      'redeemed_points': redeemedPoints,
    };
  }
}
