import 'package:flutter/material.dart';

class Responsive {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 650 &&
        MediaQuery.of(context).size.width < 1100;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  static T responsiveValue<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
      }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  static double fontSize(BuildContext context, double size) {
    double scaleFactor = isMobile(context)
        ? 1.0
        : isTablet(context)
        ? 1.2
        : 1.3;
    return size * scaleFactor;
  }

  static EdgeInsets padding(BuildContext context, {
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    double value = responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2,
    );
    return EdgeInsets.all(value);
  }

  static EdgeInsets horizontalPadding(BuildContext context, {
    double mobile = 16.0,
    double? tablet,
    double? desktop,
  }) {
    double value = responsiveValue(
      context,
      mobile: mobile,
      tablet: tablet ?? mobile * 1.5,
      desktop: desktop ?? mobile * 2,
    );
    return EdgeInsets.symmetric(horizontal: value);
  }

  static double spacing(BuildContext context, double size) {
    return responsiveValue(
      context,
      mobile: size,
      tablet: size * 1.5,
      desktop: size * 2,
    );
  }

  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double maxContentWidth(BuildContext context) {
    return responsiveValue(
      context,
      mobile: width(context),
      tablet: 800,
      desktop: 1200,
    );
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1100) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 650) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}