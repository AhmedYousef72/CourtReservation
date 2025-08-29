import 'package:flutter/material.dart';

class NavigationHelper {
  static void pushNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  static void popUntil(BuildContext context, RoutePredicate predicate) {
    Navigator.popUntil(context, predicate);
  }

  static void popToFirst(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute<T>(builder: (context) => page),
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute<T>(builder: (context) => page),
    );
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute<T>(builder: (context) => page),
      (route) => false,
    );
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : null,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => child,
    );
  }
}
