import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// A collection of responsive widgets that should be used for new pages

class ResponsiveScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const ResponsiveScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar as PreferredSizeWidget?,
      backgroundColor: backgroundColor ?? const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: padding ?? ResponsiveUtils.getSafeAreaPadding(context),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final double? width;
  final double? height;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding != null 
          ? EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, padding!.top))
          : EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 16)),
      margin: margin != null 
          ? EdgeInsets.all(ResponsiveUtils.getResponsiveMargin(context, margin!.top))
          : null,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(
          ResponsiveUtils.getResponsiveBorderRadius(context, 8),
        ),
        border: border,
      ),
      child: child,
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ResponsiveText(
    this.text, {
    super.key,
    required this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, fontSize),
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? side;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  const ResponsiveButton({
    super.key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = ResponsiveUtils.getButtonHeight(context);
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 8);

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: buttonHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: onPressed == null ? Colors.grey.shade600 : foregroundColor,
            backgroundColor: Colors.white,
            side: side ?? BorderSide(
              color: onPressed == null ? Colors.grey.shade300 : (foregroundColor ?? Colors.blue)
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: ResponsiveUtils.getResponsiveIconSize(context, 16),
                  height: ResponsiveUtils.getResponsiveIconSize(context, 16),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : child,
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: isLoading ? 0 : 2,
        ),
        child: isLoading
            ? SizedBox(
                width: ResponsiveUtils.getResponsiveIconSize(context, 16),
                height: ResponsiveUtils.getResponsiveIconSize(context, 16),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : child,
      ),
    );
  }
}

class ResponsiveTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final int? maxLines;

  const ResponsiveTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.keyboardType,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final inputHeight = ResponsiveUtils.getInputFieldHeight(context);
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Row(
            children: [
              ResponsiveText(
                labelText!,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              if (isRequired) ...[
                SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 4)),
                ResponsiveText(
                  '*',
                  fontSize: 16,
                  color: Colors.red,
                ),
              ],
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
        ],
        SizedBox(
          height: maxLines == 1 ? inputHeight : null,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            enabled: enabled,
            onTap: onTap,
            onChanged: onChanged,
            obscureText: obscureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFF4CAF50),
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsivePadding(context, 16),
                vertical: ResponsiveUtils.getResponsivePadding(context, 12),
              ),
            ),
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: enabled ? Colors.black87 : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 8);

    return Container(
      margin: margin ?? EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 8),
      ),
      child: Material(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Container(
            padding: padding ?? EdgeInsets.all(
              ResponsiveUtils.getResponsivePadding(context, 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ResponsiveBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool isFullHeight;
  final EdgeInsets? padding;

  const ResponsiveBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.isFullHeight = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final height = ResponsiveUtils.getBottomSheetHeight(context, isFullHeight: isFullHeight);
    final borderRadius = ResponsiveUtils.getResponsiveBorderRadius(context, 20);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          children: [
            if (title != null) ...[
              Container(
                padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveText(
                      title!,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE91E63),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: padding ?? EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context, 20)),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;

  const ResponsiveIcon(
    this.icon, {
    super.key,
    required this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: ResponsiveUtils.getResponsiveIconSize(context, size),
      color: color,
    );
  }
}

class ResponsiveSpacing extends StatelessWidget {
  final double height;
  final double? width;

  const ResponsiveSpacing.vertical(this.height, {super.key}) : width = null;
  const ResponsiveSpacing.horizontal(this.width, {super.key}) : height = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height > 0 ? ResponsiveUtils.getResponsiveSpacing(context, height) : null,
      width: width != null ? ResponsiveUtils.getResponsiveSpacing(context, width!) : null,
    );
  }
}
