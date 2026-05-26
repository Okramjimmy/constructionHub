import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/annotation_model.dart';
import '../providers/annotation_provider.dart';

/// The annotation canvas — handles drawing, display, and gesture detection.
/// Uses CustomPainter inside GestureDetector + InteractiveViewer.
class AnnotationCanvas extends ConsumerWidget {
  const AnnotationCanvas({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotationProvider);
    final notifier = ref.read(annotationProvider.notifier);

    return ClipRect(
      child: Center(
        child: InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(80),
          minScale: 0.5,
          maxScale: 4.0,
          // Disable pan and scale — let raw Listener handle drawing without gesture collisions
          panEnabled: state.activeTool == AnnotationTool.cursor,
          scaleEnabled: state.activeTool == AnnotationTool.cursor,
          child: Listener(
            onPointerDown: (e) {
              if (state.activeTool == AnnotationTool.cursor) {
                notifier.onCursorDown(e.localPosition);
              } else if (state.activeTool == AnnotationTool.text) {
                _handleTextTap(context, notifier, e.localPosition);
              } else {
                notifier.onPanStart(e.localPosition);
              }
            },
            onPointerMove: (e) {
              if (state.activeTool == AnnotationTool.cursor) {
                notifier.onCursorMove(e.localPosition);
              } else if (state.activeTool != AnnotationTool.text) {
                notifier.onPanUpdate(e.localPosition);
              }
            },
            onPointerUp: (e) {
              if (state.activeTool == AnnotationTool.cursor) {
                notifier.onCursorUp();
              } else if (state.activeTool != AnnotationTool.text) {
                notifier.onPanEnd();
              }
            },
            child: SizedBox(
              width: 360,
              height: 520,
              child: CustomPaint(
                foregroundPainter: _AnnotationPainter(
                  annotations: state.annotations,
                  currentPoints: state.currentPoints,
                  currentTool: state.activeTool,
                  currentColor: state.activeColor,
                  selectedAnnotationId: state.selectedAnnotationId,
                ),
                child: _ConcreteColumnBackground(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTextTap(
      BuildContext context, AnnotationNotifier notifier, Offset position) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF334155), width: 1.5),
          ),
          title: Text(
            'Insert Text Annotation',
            style: GoogleFonts.sora(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'POSITION: (${position.dx.toInt()}, ${position.dy.toInt()})',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF475569)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: GoogleFonts.sora(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter tag description (e.g. Hairline Crack)',
                    hintStyle: GoogleFonts.sora(fontSize: 13, color: const Color(0xFF64748B)),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  notifier.addTextAnnotation(position, text);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                'Add Note',
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Renders the concrete column texture background.
class _ConcreteColumnBackground extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotationProvider);
    final hasImage = state.imagePath != null;

    return Stack(
      children: [
        // Dark background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
          ),
        ),
        // Grid overlay
        CustomPaint(painter: _CanvasGridPainter()),
        
        // Background photo or procedurally drawn column
        Center(
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 320,
                      maxHeight: 460,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: kIsWeb
                        ? Image.network(
                            state.imagePath!,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            io.File(state.imagePath!),
                            fit: BoxFit.contain,
                          ),
                  ),
                )
              : Container(
                  width: 90,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF4A5568),
                        Color(0xFF374151),
                        Color(0xFF2D3748),
                        Color(0xFF4A5568),
                        Color(0xFF374151),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
        ),
        
        // Crack SVG overlay (only show if no custom image is uploaded)
        if (!hasImage) Center(child: _CrackOverlay()),
        
        // Bottom label
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              hasImage ? 'CUSTOM INSPECTION PHOTO' : 'COLUMN C-4 · Level 3',
              style: GoogleFonts.ibmPlexMono(
                  fontSize: 10, color: const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CrackOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 220,
      child: CustomPaint(painter: _CrackPainter()),
    );
  }
}

class _CrackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6B7280).withValues(alpha: 0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Main crack
    final path = Path()
      ..moveTo(45, 40)
      ..lineTo(38, 70)
      ..lineTo(52, 90)
      ..lineTo(40, 120)
      ..lineTo(55, 145)
      ..lineTo(44, 170);
    canvas.drawPath(path, paint);

    // Branch 1
    paint.strokeWidth = 1;
    paint.color = const Color(0xFF6B7280).withValues(alpha: 0.3);
    final b1 = Path()
      ..moveTo(38, 70)
      ..lineTo(25, 80)
      ..lineTo(30, 95);
    canvas.drawPath(b1, paint);

    // Honeycombing patches
    final patchPaint = Paint()
      ..color = const Color(0xFF4B5563).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    final patch1 = Path()
      ..moveTo(35, 50)
      ..quadraticBezierTo(45, 55, 55, 50)
      ..quadraticBezierTo(50, 60, 55, 70)
      ..quadraticBezierTo(45, 65, 35, 70)
      ..quadraticBezierTo(40, 60, 35, 50)
      ..close();
    canvas.drawPath(patch1, patchPaint);
  }

  @override
  bool shouldRepaint(_CrackPainter old) => false;
}

class _CanvasGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_CanvasGridPainter old) => false;
}

/// Draws all completed annotations + the in-progress one.
class _AnnotationPainter extends CustomPainter {
  const _AnnotationPainter({
    required this.annotations,
    required this.currentPoints,
    required this.currentTool,
    required this.currentColor,
    this.selectedAnnotationId,
  });

  final List<AnnotationItem> annotations;
  final List<Offset> currentPoints;
  final AnnotationTool currentTool;
  final Color currentColor;
  final String? selectedAnnotationId;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw completed annotations
    for (final ann in annotations) {
      _drawAnnotation(canvas, ann);
    }

    // Draw selection highlights
    if (selectedAnnotationId != null) {
      try {
        final selected = annotations.firstWhere((a) => a.id == selectedAnnotationId);
        _drawSelectedHighlight(canvas, selected);
      } catch (_) {}
    }

    // Draw in-progress annotation
    if (currentPoints.length >= 2) {
      if (currentTool == AnnotationTool.boundingBox) {
        _drawBoundingBox(
          canvas,
          Rect.fromPoints(currentPoints.first, currentPoints.last),
          currentColor,
          null,
        );
      } else if (currentTool == AnnotationTool.freehand) {
        _drawFreehand(canvas, currentPoints, currentColor);
      }
    }
  }

  void _drawSelectedHighlight(Canvas canvas, AnnotationItem ann) {
    final r = ann.rect;
    if (r == null) return;

    // Draw selection bounding rectangle outline
    final selectionPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRect(r.inflate(2.0), selectionPaint);

    // Draw 4 resize handles
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final handleBorderPaint = Paint()
      ..color = ann.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final handles = [
      r.topLeft,
      r.topRight,
      r.bottomLeft,
      r.bottomRight,
    ];

    for (final h in handles) {
      canvas.drawCircle(h, 6.0, handlePaint);
      canvas.drawCircle(h, 6.0, handleBorderPaint);
    }

    // Draw a small floating Delete button centered above the rect
    final deleteCenter = Offset(r.center.dx, r.top - 20);
    final deleteBgPaint = Paint()
      ..color = const Color(0xFFEF4444)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(deleteCenter, 10.0, deleteBgPaint);

    // Draw white "X" icon on the delete button
    final xPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const size = 3.5;
    canvas.drawLine(
        Offset(deleteCenter.dx - size, deleteCenter.dy - size),
        Offset(deleteCenter.dx + size, deleteCenter.dy + size),
        xPaint);
    canvas.drawLine(
        Offset(deleteCenter.dx + size, deleteCenter.dy - size),
        Offset(deleteCenter.dx - size, deleteCenter.dy + size),
        xPaint);
  }

  void _drawAnnotation(Canvas canvas, AnnotationItem ann) {
    switch (ann.type) {
      case AnnotationType.boundingBox:
        if (ann.rect != null) {
          _drawBoundingBox(canvas, ann.rect!, ann.color, ann.label);
        }
      case AnnotationType.freehand:
        _drawFreehand(canvas, ann.points, ann.color);
      case AnnotationType.textTag:
        if (ann.points.isNotEmpty) {
          _drawTextTag(canvas, ann.points.first, ann.color, ann.label ?? 'Tag');
        }
    }
  }

  void _drawTextTag(Canvas canvas, Offset position, Color color, String text) {
    // 1. Anchor dot
    final anchorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(position, 4, anchorPaint);

    // 2. Connector line
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final boxOffset = Offset(position.dx + 16, position.dy - 16);
    canvas.drawLine(position, boxOffset, linePaint);

    // 3. Text Tag Box
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Sora',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 160);

    const padH = 10.0;
    const padV = 6.0;

    final tagRect = Rect.fromLTWH(
      boxOffset.dx,
      boxOffset.dy - tp.height / 2 - padV,
      tp.width + padH * 2,
      tp.height + padV * 2,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(tagRect, const Radius.circular(8)),
      Paint()..color = color.withValues(alpha: 0.85),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(tagRect, const Radius.circular(8)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );

    tp.paint(
      canvas,
      Offset(tagRect.left + padH, tagRect.top + padV),
    );
  }

  void _drawBoundingBox(
      Canvas canvas, Rect rect, Color color, String? label) {
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect, borderPaint);

    if (label != null) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 200);

      const padH = 8.0;
      const padV = 4.0;
      final labelRect = Rect.fromLTWH(
        rect.center.dx - tp.width / 2 - padH,
        rect.top - tp.height - padV * 2 - 4,
        tp.width + padH * 2,
        tp.height + padV * 2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(6)),
        Paint()..color = color,
      );
      tp.paint(
          canvas,
          Offset(labelRect.left + padH,
              labelRect.top + padV));
    }
  }

  void _drawFreehand(
      Canvas canvas, List<Offset> points, Color color) {
    if (points.length < 2) return;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_AnnotationPainter old) {
    return old.annotations != annotations ||
        old.currentPoints != currentPoints;
  }
}
