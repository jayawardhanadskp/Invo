import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppSnackbars {
  static void showSucessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Center(child: Text(message)), backgroundColor: const Color.fromARGB(255, 147, 211, 150),));
  }
}
