// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

bool get useToastNotifications {
  if (kIsWeb) {
    return true; // Use toast notifications on web
  }
  return defaultTargetPlatform != TargetPlatform.android && defaultTargetPlatform != TargetPlatform.iOS;
}

void showErrorNotification( String message, {BuildContext? context,  String? title, Duration? autoCloseDuration=const Duration(seconds: 5)}) {
  if (useToastNotifications || context == null){
    toastification.show(
          title: title != null ? Text(title) : null,
          description : Text(message),
          type: ToastificationType.error,
          autoCloseDuration: autoCloseDuration,
          backgroundColor: const Color.fromARGB(255, 235, 189, 189)
        );
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 235, 189, 189),
        duration: autoCloseDuration ?? const Duration(seconds: 5),

      ),
    );
  }
}

void showInfoNotification(String message, {BuildContext? context,  String? title, Duration? autoCloseDuration=const Duration(seconds: 5)}) {
  if (useToastNotifications || context == null){
    toastification.show(
          title: title != null ? Text(title) : null,
          description : Text(message),
          type: ToastificationType.info,
          autoCloseDuration: autoCloseDuration,
          backgroundColor: const Color.fromARGB(255, 187, 218, 233)
        );
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 187, 218, 233),
        duration: autoCloseDuration ?? const Duration(seconds: 5),
      ),
    );
  }
}