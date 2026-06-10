import 'package:flutter/material.dart';

class PrintDebugInfo {
  static void show(BuildContext context, String debugInfo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(debugInfo)),
    );
  }
}
