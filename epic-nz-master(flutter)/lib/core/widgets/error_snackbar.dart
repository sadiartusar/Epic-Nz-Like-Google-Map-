import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorSnackbar extends GetSnackBar {
  ErrorSnackbar({super.key, required String message})
    : super(
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 20,
        backgroundColor: Colors.red.withValues(alpha: 0.85),
        duration: const Duration(seconds: 3),
        shouldIconPulse: false,

        overlayBlur: 6,
        overlayColor: Colors.black.withValues(alpha: 0.25),

        icon: const Icon(Icons.error_outline, color: Colors.white, size: 26),

        titleText: const Text(
          "Error",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        messageText: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),

        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      );
}
