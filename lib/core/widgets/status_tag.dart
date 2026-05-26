import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Status tag pill matching the design: IN PROGRESS / PAUSED / CRITICAL
enum TagType { green, yellow, red }

class StatusTag extends StatelessWidget {
  const StatusTag({super.key, required this.label, required this.type});

  final String label;
  final TagType type;

  Color get _bg => switch (type) {
        TagType.green => AppColors.tagGreenBg,
        TagType.yellow => AppColors.tagYellowBg,
        TagType.red => AppColors.tagRedBg,
      };

  Color get _fg => switch (type) {
        TagType.green => AppColors.green,
        TagType.yellow => AppColors.yellow,
        TagType.red => AppColors.red,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _fg,
          fontFamily: 'IBMPlexMono',
        ),
      ),
    );
  }
}
