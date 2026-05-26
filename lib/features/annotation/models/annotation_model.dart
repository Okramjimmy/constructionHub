import 'package:flutter/material.dart';

enum AnnotationTool { cursor, boundingBox, freehand, text }
enum AnnotationType { boundingBox, freehand, textTag }

class AnnotationItem {
  const AnnotationItem({
    required this.id,
    required this.type,
    required this.points,
    required this.color,
    this.label,
  });

  final String id;
  final AnnotationType type;
  final List<Offset> points; // For box: [topLeft, bottomRight]; freehand: list of points
  final Color color;
  final String? label;

  // For bounding box convenience
  Rect? get rect {
    if (type == AnnotationType.boundingBox && points.length == 2) {
      return Rect.fromPoints(points[0], points[1]);
    }
    return null;
  }
}
