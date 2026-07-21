import 'package:flutter/material.dart';
import 'package:signallens/widgets/sl_loader.dart';
import 'package:signallens/widgets/sl_text.dart';

class SlButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color textColor;

  const SlButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(height: 22, width: 22, child: slButtonLoader(context))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  SlText(
                    label,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                    color: textColor,
                  ),
                ],
              ),
      ),
    );
  }
}

class SlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final String? tooltip;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isTransparentOverlay;

  const SlIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onLongPress,
    this.tooltip,
    this.size = 48.0,
    this.backgroundColor,
    this.iconColor,
    this.isTransparentOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final defaultBg = isTransparentOverlay
        ? Colors.black.withOpacity(0.55)
        : Theme.of(context).colorScheme.surface;

    final defaultIconColor = isTransparentOverlay
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).primaryColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? defaultBg,
        border: isTransparentOverlay
            ? Border.all(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          tooltip: tooltip,
          icon: Icon(
            icon,
            size: size * 0.48,
            color: iconColor ?? defaultIconColor,
          ),
          onPressed: onPressed,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
