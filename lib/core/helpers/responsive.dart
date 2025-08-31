import 'package:flutter/widgets.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 600 && w < 1024;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 48;
    if (w >= 1024) return 32;
    if (w >= 600) return 24;
    return 16;
  }

  static double verticalPadding(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    if (h >= 1000) return 32;
    if (h >= 800) return 24;
    return 16;
  }

  static int gridCrossAxisCount(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 5;
    if (w >= 1200) return 4;
    if (w >= 900) return 3;
    return 2;
  }

  static double maxContentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1600) return 1200;
    if (w >= 1400) return 1100;
    if (w >= 1200) return 1000;
    return double.infinity;
  }
}
