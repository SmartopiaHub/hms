// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

/// Represents MQTT broker configuration.
class MqttConfig {
  /// The MQTT broker host, e.g. "mqtt.example.com".
  final String host;

  /// The MQTT broker port, e.g. 1883.
  final int port;

  /// Optional username for broker authentication.
  final String? username;

  /// Optional password for broker authentication.
  final String? password;

  /// Topic prefix to use when publishing/subscribing.
  final String topicPrefix;

  /// Client ID to use for MQTT connections.
  final String clientId;

  const MqttConfig({
    required this.host,
    required this.port,
    this.username,
    this.password,
    required this.topicPrefix,
    required this.clientId,
  });

  /// Creates a new config from a JSON map.
  factory MqttConfig.fromJson(Map<String, dynamic> json) {
    return MqttConfig(
      host: json['host'] as String,
      port: json['port'] as int,
      username: json['username'] as String?,
      password: json['password'] as String?,
      topicPrefix: json['topicPrefix'] as String,
      clientId: json['clientId'] as String? ?? 'hms_server',
    );
  }

  /// Converts this config into a JSON map.
  Map<String, dynamic> toJson() => {
        'host': host,
        'port': port,
        if (username != null) 'username': username,
        if (password != null) 'password': password,
        'topicPrefix': topicPrefix,
        'clientId': clientId,
      };

  @override
  String toString() {
    return 'MqttConfig(host: $host, port: $port, '
        'username: ${username ?? "<none>"}, '
        'topicPrefix: $topicPrefix'
        ' clientId: $clientId)';
  }
}
