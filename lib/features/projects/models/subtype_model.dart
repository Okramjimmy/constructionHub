import 'package:flutter/material.dart';

class SubtypeModel {
  const SubtypeModel({
    required this.id,
    required this.name,
    required this.tags,
    required this.iconData,
    required this.iconColor,
    required this.bgColor,
    required this.checklistCount,
  });

  final String id;
  final String name;
  final String tags;
  final IconData iconData;
  final Color iconColor;
  final Color bgColor;
  final int checklistCount;
}
