// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:ui';
import 'package:flutter/material.dart';

enum ToastType { info, success, warning, error }

class GlassToast extends StatelessWidget {
  final String title;
  final String? subtitle;
  final ToastType type;
  final bool darkGlass; // true: 深色玻璃；false: 浅色玻璃

  const GlassToast({
    super.key,
    required this.title,
    this.subtitle,
    this.type = ToastType.info,
    this.darkGlass = true,
  });

  Color get _accent {
    switch (type) {
      case ToastType.success: return const Color(0xFF3CCB7F);
      case ToastType.warning: return const Color(0xFFFFC24B);
      case ToastType.error:   return const Color(0xFFFF6B6B);
      case ToastType.info:    return const Color(0xFF4DA1FF);
    }
  }

  IconData get _icon {
    switch (type) {
      case ToastType.success: return Icons.check_circle_rounded;
      case ToastType.warning: return Icons.warning_rounded;
      case ToastType.error:   return Icons.error_rounded;
      case ToastType.info:    return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseTextColor = darkGlass ? const Color(0xFFF8FAFF) : const Color(0xFF1F2A44);
    final subTextColor  = darkGlass ? const Color(0xFFD6E6FF) : const Color(0xFF5B6B86);
    final glassTint     = darkGlass ? const Color(0xFF0F1B2D) : const Color(0xFFFFFFFF);
    final opacity       = darkGlass ? 0.55 : 0.28;

    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.topCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 560),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: glassTint.withOpacity(opacity),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.28), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧语义色图标/条
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(_icon, color: _accent, size: 22),
                  const SizedBox(width: 12),
                  // 文案
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                          style: TextStyle(
                            color: baseTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(subtitle!,
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 14,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // 关闭
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Icon(Icons.close_rounded,
                      color: baseTextColor.withAlpha(175), size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
