import 'package:flutter/material.dart';
import '../../core/theme/toledo_colors.dart';

enum BadgeVariant { free, tour, price, warn, neutral }

class ToledoBadge extends StatelessWidget {
  final String text;
  final BadgeVariant variant;
  final IconData? icon;

  const ToledoBadge({
    super.key,
    required this.text,
    this.variant = BadgeVariant.neutral,
    this.icon,
  });

  factory ToledoBadge.fromType(String type, String text) {
    switch (type.toLowerCase()) {
      case 'free':
        return ToledoBadge(text: text, variant: BadgeVariant.free, icon: Icons.check_circle_outline);
      case 'tour':
        return ToledoBadge(text: text, variant: BadgeVariant.tour, icon: Icons.explore_outlined);
      case 'price':
        return ToledoBadge(text: text, variant: BadgeVariant.price, icon: Icons.euro_symbol);
      case 'warn':
        return ToledoBadge(text: text, variant: BadgeVariant.warn, icon: Icons.info_outline);
      default:
        return ToledoBadge(text: text, variant: BadgeVariant.neutral);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color textColor;

    switch (variant) {
      case BadgeVariant.free:
        bg = ToledoColors.badgeFreeBg;
        border = ToledoColors.badgeFreeBorder;
        textColor = ToledoColors.badgeFreeText;
        break;
      case BadgeVariant.tour:
        bg = ToledoColors.badgeTourBg;
        border = ToledoColors.badgeTourBorder;
        textColor = ToledoColors.badgeTourText;
        break;
      case BadgeVariant.price:
        bg = ToledoColors.badgePriceBg;
        border = ToledoColors.badgePriceBorder;
        textColor = ToledoColors.badgePriceText;
        break;
      case BadgeVariant.warn:
        bg = ToledoColors.badgeWarnBg;
        border = ToledoColors.badgeWarnBorder;
        textColor = ToledoColors.badgeWarnText;
        break;
      case BadgeVariant.neutral:
        bg = ToledoColors.surfaceAlt;
        border = ToledoColors.border;
        textColor = ToledoColors.textMuted;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11.5, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
