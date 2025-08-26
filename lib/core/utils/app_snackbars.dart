import 'package:flutter/material.dart';

class AppSnackbars {
  // Private constructor to prevent instantiation
  AppSnackbars._();

  /// Shows a custom styled SnackBar.
  ///
  /// [context]: The BuildContext from which to show the SnackBar.
  /// [message]: The text message to display in the SnackBar.
  /// [duration]: How long the SnackBar should be visible. Defaults to 4 seconds.
  /// [action]: An optional SnackBarAction to display, e.g., an 'Undo' button.
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
  }) {
    // Ensure there's a ScaffoldMessenger available in the widget tree.
    // Calling hideCurrentSnackBar before showing a new one can prevent
    // multiple Snackbars from stacking up or showing on top of each other.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white), // Consistent text style
        ),
        duration: duration,
        action: action,
        backgroundColor: Colors.blueGrey[800], // Consistent background color
        behavior: SnackBarBehavior.floating, // Example behavior: floating
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: const EdgeInsets.all(16), // Margin around the floating snackbar
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 12), // Inner padding
        elevation: 6, // Shadow effect
      ),
    );
  }

  /// Shows a simple success SnackBar.
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 6,
      ),
    );
  }

  /// Shows a simple error SnackBar.
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red[700],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 6,
      ),
    );
  }
}
