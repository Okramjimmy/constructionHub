import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Reusable top navigation bar matching the design template.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.title,
    this.breadcrumb,
    this.onBack,
    this.trailing,
    this.backgroundColor = AppColors.navy,
  });

  final String title;
  final String? breadcrumb;
  final VoidCallback? onBack;
  final Widget? trailing;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ),
          if (onBack != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                    letterSpacing: 0.01,
                  ),
                ),
                if (breadcrumb != null)
                  Text(
                    breadcrumb!,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
