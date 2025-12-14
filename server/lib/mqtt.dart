// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smartopia_hms_server/logger.dart';
import 'package:smartopia_hms_server/notification.dart';
import 'package:smartopia_hms_shared/shared.dart';

/// A singleton service for managing MQTT connections and publishing messages.
class MqttService {
  MqttService._();

  /// The singleton instance of [MqttService].
  static final MqttService instance = MqttService._();

  MqttServerClient? _client;

  /// Returns the current connection state of the MQTT client.
  Future<MqttConnectionState> get connectionState async {
    if (_client == null || _client?.connectionStatus == null) {
      try {
        final config = loadConfig();
        if (config != null) {
          await connect(config);
        }
      } catch (e, s) {
        logError('Error checking MQTT connection state', e, s);
      }
    }
    if (_client == null || _client!.connectionStatus == null) {
      return MqttConnectionState.disconnected;
    }
    return _client!.connectionStatus!.state;
  }

  /// Loads the MQTT configuration from a JSON file in the `./data` directory.
  /// If the file does not exist or is invalid, returns null.
  MqttConfig? loadConfig() {
    try {
      final configStr = File('./data/config/mqtt.json').readAsStringSync();
      if (configStr.isEmpty) {
        throw Exception('MQTT configuration file is empty');
      }
      final config = json.decode(configStr) as Map<String, dynamic>;
      if (config['host'] == null || config['port'] == null) {
        throw Exception('MQTT configuration is incomplete');
      }
      return MqttConfig(
        host: config['host'] as String,
        port: config['port'] as int,
        clientId: config['clientId'] as String? ?? 'hms_server',
        username: config['username'] as String?,
        password: config['password'] as String?,
        topicPrefix: config['topicPrefix'] as String? ?? 'hms/task',
      );
    } catch (e, s) {
      logError('Failed to load MQTT configuration', e, s);
      return null;
    }
  }

  /// Sets the MQTT configuration and initializes the client.
  /// Returns true if successful, false otherwise.
  bool saveConfig(MqttConfig config) {
    try {
      final configStr = json.encode(config.toJson());
      File('./data/config/mqtt.json').writeAsStringSync(configStr);
      logInfo('MQTT configuration saved: $config');
      return true;
    } catch (e, s) {
      logError('Failed to set MQTT configuration', e, s);
      return false;
    }
  }

  /// Initializes the MQTT client and connects to the specified host.
  Future<void> connect(MqttConfig config,) async {
    try{

      _client = MqttServerClient(config.host, config.clientId)
        ..port = config.port
        ..logging(on: false)
        ..keepAlivePeriod = 20
        ..autoReconnect = true;
      final connMess = MqttConnectMessage().withClientIdentifier(config.clientId);
      _client!.connectionMessage = connMess;


      await _client!.connect(config.username, config.password);
      if (_client!.connectionStatus?.state != MqttConnectionState.connected) {
        throw Exception(
            'MQTT connect failed: ${_client!.connectionStatus}');
      }
      logInfo('MQTT connected to ${config.host}:${config.port}');
    } 
    // catch only socket‐level errors
    on SocketException catch (e, s) {
      logError('MQTT SocketException connecting to ${config.host}:${config.port}', e, s);
      _client?.disconnect();
      _client = null;
    }
    catch (e, s) {
      logError('MQTT connection error', e, s);
      _client?.disconnect();
      _client = null;
    }
  }

  /// publishes a message to the specified topic.
  void publish(String topic, String payload) {
    if (_client == null || _client!.connectionStatus?.state != MqttConnectionState.connected) {
        logWarning('MQTT client is not connected, cannot publish message');
        return;
      }
    try{
      final builder = MqttClientPayloadBuilder()
      ..addUTF8String(payload);
      _client?.publishMessage(
        topic,
        MqttQos.atLeastOnce,
        builder.payload!,
      );
    } catch (e, s) {
      logError('Failed to publish message to $topic', e, s);
    }
  }
}

class MqttNotifier extends Notifier {
  
  @override
  Future<void> notify(Notification notification) async {
    MqttService.instance.publish(notification.topic!, notification.ttsText!);
  }
}