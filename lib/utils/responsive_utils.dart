import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Responsive breakpoints
  static bool isSmallPhone(BuildContext context) {
    return getScreenWidth(context) < 360;
  }

  static bool isMediumPhone(BuildContext context) {
    return getScreenWidth(context) >= 360 && getScreenWidth(context) < 414;
  }

  static bool isLargePhone(BuildContext context) {
    return getScreenWidth(context) >= 414 && getScreenWidth(context) < 768;
  }

  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) >= 768;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseSize * 0.85;
    if (screenWidth < 414) return baseSize * 0.9;
    if (screenWidth < 768) return baseSize;
    return baseSize * 1.1;
  }

  // Responsive padding
  static double getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return basePadding * 0.8;
    if (screenWidth < 414) return basePadding * 0.9;
    if (screenWidth < 768) return basePadding;
    return basePadding * 1.2;
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseSpacing * 0.8;
    if (screenWidth < 414) return baseSpacing * 0.9;
    if (screenWidth < 768) return baseSpacing;
    return baseSpacing * 1.1;
  }

  // Responsive height for components
  static double getResponsiveHeight(BuildContext context, double baseHeight) {
    final screenHeight = getScreenHeight(context);
    if (screenHeight < 600) return baseHeight * 0.9;
    if (screenHeight < 800) return baseHeight;
    return baseHeight * 1.1;
  }

  static double getModalHeight(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    if (screenHeight < 600) return 0.95; // Use more screen on small devices
    if (screenHeight < 800) return 0.85;
    return 0.8; // Use less on larger devices
  }

  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseSize * 0.85;
    if (screenWidth < 414) return baseSize * 0.9;
    if (screenWidth < 768) return baseSize;
    return baseSize * 1.1;
  }

  static double getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseRadius * 0.8;
    if (screenWidth < 768) return baseRadius;
    return baseRadius * 1.2;
  }

  // Responsive margin
  static double getResponsiveMargin(BuildContext context, double baseMargin) {
    final screenWidth = getScreenWidth(context);
    if (screenWidth < 360) return baseMargin * 0.8;
    if (screenWidth < 414) return baseMargin * 0.9;
    if (screenWidth < 768) return baseMargin;
    return baseMargin * 1.2;
  }

  static double getCardWidth(BuildContext context, {int columnsOnTablet = 2}) {
    final screenWidth = getScreenWidth(context);
    if (isTablet(context)) {
      final padding = getResponsivePadding(context, 32); // Total horizontal padding
      final spacing = getResponsiveSpacing(context, 16); // Spacing between cards
      return (screenWidth - padding - (spacing * (columnsOnTablet - 1))) / columnsOnTablet;
    }
    return screenWidth - getResponsivePadding(context, 32);
  }

  static double getButtonHeight(BuildContext context) {
    if (isSmallPhone(context)) return 44;
    if (isMediumPhone(context)) return 48;
    if (isLargePhone(context)) return 52;
    return 56; // Tablet
  }

  static double getInputFieldHeight(BuildContext context) {
    if (isSmallPhone(context)) return 40;
    if (isMediumPhone(context)) return 44;
    if (isLargePhone(context)) return 48;
    return 52; // Tablet
  }

  static double getAppBarHeight(BuildContext context) {
    if (isSmallPhone(context)) return 48;
    if (isMediumPhone(context)) return 52;
    if (isLargePhone(context)) return 56;
    return 60; // Tablet
  }

  static int getGridColumns(BuildContext context, {int maxColumns = 3}) {
    if (isSmallPhone(context)) return 1;
    if (isMediumPhone(context)) return 1;
    if (isLargePhone(context)) return 2;
    return maxColumns; // Tablet
  }

  // Safe area padding
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      top: safePadding.top,
      bottom: safePadding.bottom,
      left: getResponsivePadding(context, 16),
      right: getResponsivePadding(context, 16),
    );
  }

  // Responsive dialog width
  static double getDialogWidth(BuildContext context) {
    final screenWidth = getScreenWidth(context);
    if (isTablet(context)) {
      return screenWidth * 0.6; // 60% on tablets
    }
    return screenWidth * 0.9; // 90% on phones
  }

  // Responsive bottom sheet height
  static double getBottomSheetHeight(BuildContext context, {bool isFullHeight = false}) {
    if (isFullHeight) return getModalHeight(context);
    
    final screenHeight = getScreenHeight(context);
    if (screenHeight < 600) return 0.85;
    if (screenHeight < 800) return 0.75;
    return 0.7;
  }
}
