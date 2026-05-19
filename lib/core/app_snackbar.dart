import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract final class AppSnackbar {
  static const _animDuration = Duration(milliseconds: 150);
  static const _margin = EdgeInsets.fromLTRB(16, 0, 16, 28);

  static void _show({
    required String message,
    required IconData iconData,
    required Color color,
    Duration duration = const Duration(seconds: 2),
    bool dismissCurrent = false,
  }) {
    if (dismissCurrent) Get.closeCurrentSnackbar();
    Get.snackbar(
      '',
      '',
      titleText: const SizedBox.shrink(),
      messageText: Row(
        children: [
          Icon(iconData, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      snackPosition: SnackPosition.BOTTOM,
      margin: _margin,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      animationDuration: _animDuration,
      duration: duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static void error(String message) => _show(
        message: message,
        iconData: Icons.error_outline_rounded,
        color: const Color(0xFFD32F2F),
        duration: const Duration(seconds: 2),
      );

  static void success(String message) => _show(
        message: message,
        iconData: Icons.check_circle_outline_rounded,
        color: const Color(0xFF388E3C),
        duration: const Duration(seconds: 1),
        dismissCurrent: true,
      );

  static void info(String message) => _show(
        message: message,
        iconData: Icons.info_outline_rounded,
        color: const Color(0xFF1565C0),
        duration: const Duration(seconds: 1),
        dismissCurrent: true,
      );
}
