import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/annotation_model.dart';

class AnnotationState {
  const AnnotationState({
    this.annotations = const [],
    this.undoStack = const [],
    this.activeTool = AnnotationTool.cursor,
    this.activeColor = const Color(0xFFEF4444),
    this.currentPoints = const [],
    this.isDrawing = false,
    this.imagePath,
    this.selectedAnnotationId,
    this.activeResizeHandle,
    this.dragStartPoint,
    this.originalPoints,
  });

  final List<AnnotationItem> annotations;
  final List<List<AnnotationItem>> undoStack; // snapshots for undo
  final AnnotationTool activeTool;
  final Color activeColor;
  final List<Offset> currentPoints; // in-progress drawing
  final bool isDrawing;
  final String? imagePath;
  final String? selectedAnnotationId;
  final int? activeResizeHandle;
  final Offset? dragStartPoint;
  final List<Offset>? originalPoints;

  AnnotationState copyWith({
    List<AnnotationItem>? annotations,
    List<List<AnnotationItem>>? undoStack,
    AnnotationTool? activeTool,
    Color? activeColor,
    List<Offset>? currentPoints,
    bool? isDrawing,
    String? imagePath,
    String? selectedAnnotationId,
    bool clearSelected = false,
    int? activeResizeHandle,
    bool clearResize = false,
    Offset? dragStartPoint,
    bool clearDrag = false,
    List<Offset>? originalPoints,
  }) {
    return AnnotationState(
      annotations: annotations ?? this.annotations,
      undoStack: undoStack ?? this.undoStack,
      activeTool: activeTool ?? this.activeTool,
      activeColor: activeColor ?? this.activeColor,
      currentPoints: currentPoints ?? this.currentPoints,
      isDrawing: isDrawing ?? this.isDrawing,
      imagePath: imagePath ?? this.imagePath,
      selectedAnnotationId: clearSelected ? null : (selectedAnnotationId ?? this.selectedAnnotationId),
      activeResizeHandle: clearResize ? null : (activeResizeHandle ?? this.activeResizeHandle),
      dragStartPoint: clearDrag ? null : (dragStartPoint ?? this.dragStartPoint),
      originalPoints: originalPoints ?? this.originalPoints,
    );
  }
}

class AnnotationNotifier extends StateNotifier<AnnotationState> {
  AnnotationNotifier()
      : super(const AnnotationState(
          // Pre-load a defect annotation matching the design
          annotations: [
            AnnotationItem(
              id: 'default-defect',
              type: AnnotationType.boundingBox,
              points: [Offset(105, 60), Offset(205, 240)],
              color: Color(0xFFEF4444),
              label: '⚠ Concrete Honeycombing',
            ),
          ],
        ));

  void setImagePath(String? path) {
    state = state.copyWith(imagePath: path);
  }

  void setTool(AnnotationTool tool) {
    state = state.copyWith(activeTool: tool, currentPoints: []);
  }

  void setColor(Color color) {
    state = state.copyWith(activeColor: color);
  }

  void onPanStart(Offset position) {
    if (state.activeTool == AnnotationTool.cursor) return;
    state = state.copyWith(
      isDrawing: true,
      currentPoints: [position],
    );
  }

  void onPanUpdate(Offset position) {
    if (!state.isDrawing) return;
    if (state.activeTool == AnnotationTool.freehand) {
      state = state.copyWith(
        currentPoints: [...state.currentPoints, position],
      );
    } else if (state.activeTool == AnnotationTool.boundingBox) {
      // Keep only start + current end
      state = state.copyWith(
        currentPoints: [state.currentPoints.first, position],
      );
    }
  }

  void onPanEnd() {
    if (!state.isDrawing || state.currentPoints.isEmpty) return;

    final tool = state.activeTool;
    AnnotationType? type;
    if (tool == AnnotationTool.boundingBox) {
      type = AnnotationType.boundingBox;
    } else if (tool == AnnotationTool.freehand) {
      type = AnnotationType.freehand;
    }

    if (type != null && state.currentPoints.length >= 2) {
      final newItem = AnnotationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        points: List.from(state.currentPoints),
        color: state.activeColor,
        label: type == AnnotationType.boundingBox ? 'Defect' : null,
      );

      // Save undo snapshot
      final snapshot = List<AnnotationItem>.from(state.annotations);
      state = state.copyWith(
        annotations: [...state.annotations, newItem],
        undoStack: [...state.undoStack, snapshot],
        currentPoints: [],
        isDrawing: false,
      );
    } else {
      state = state.copyWith(currentPoints: [], isDrawing: false);
    }
  }

  void addTextAnnotation(Offset position, String text) {
    final newItem = AnnotationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: AnnotationType.textTag,
      points: [position],
      color: state.activeColor,
      label: text,
    );

    // Save undo snapshot
    final snapshot = List<AnnotationItem>.from(state.annotations);
    state = state.copyWith(
      annotations: [...state.annotations, newItem],
      undoStack: [...state.undoStack, snapshot],
    );
  }

  void selectAnnotation(String? id) {
    state = state.copyWith(selectedAnnotationId: id, clearSelected: id == null);
  }

  void removeAnnotation(String id) {
    // Save undo snapshot
    final snapshot = List<AnnotationItem>.from(state.annotations);
    state = state.copyWith(
      annotations: state.annotations.where((a) => a.id != id).toList(),
      undoStack: [...state.undoStack, snapshot],
      selectedAnnotationId: null,
      clearSelected: true,
    );
  }

  void onCursorDown(Offset position) {
    // 1. Check if we tapped close to any handle of the SELECTED bounding box annotation
    if (state.selectedAnnotationId != null) {
      final matches = state.annotations.where((a) => a.id == state.selectedAnnotationId);
      if (matches.isNotEmpty) {
        final selected = matches.first;
        if (selected.type == AnnotationType.boundingBox && selected.points.length == 2) {
          final pts = selected.points;
          final p1 = pts[0];
          final p2 = pts[1];
          
          final handles = [
            p1, // topLeft
            Offset(p2.dx, p1.dy), // topRight
            Offset(p1.dx, p2.dy), // bottomLeft
            p2, // bottomRight
          ];
          
          for (int i = 0; i < handles.length; i++) {
            if ((position - handles[i]).distance < 16.0) {
              // Found active resize handle!
              state = state.copyWith(
                activeResizeHandle: i,
                dragStartPoint: position,
                originalPoints: List.from(pts),
              );
              return;
            }
          }
        }
      }
    }
    
    // 2. Check if we tapped the delete button of the SELECTED annotation
    if (state.selectedAnnotationId != null) {
      final matches = state.annotations.where((a) => a.id == state.selectedAnnotationId);
      if (matches.isNotEmpty) {
        final selected = matches.first;
        final r = selected.rect;
        if (r != null) {
          final deleteBtnPos = Offset(r.center.dx, r.top - 20);
          if ((position - deleteBtnPos).distance < 18.0) {
            removeAnnotation(selected.id);
            return;
          }
        }
      }
    }

    // 3. Check if we tapped INSIDE any bounding box to select or drag it
    for (final ann in state.annotations.reversed) {
      if (ann.type == AnnotationType.boundingBox && ann.rect != null) {
        if (ann.rect!.contains(position)) {
          // Select it and start dragging
          state = state.copyWith(
            selectedAnnotationId: ann.id,
            dragStartPoint: position,
            originalPoints: List.from(ann.points),
          );
          return;
        }
      }
    }
    
    // 4. Tapped outside everything, clear selection
    state = state.copyWith(clearSelected: true, clearResize: true, clearDrag: true);
  }

  void onCursorMove(Offset position) {
    if (state.selectedAnnotationId == null || state.dragStartPoint == null || state.originalPoints == null) return;
    
    final matches = state.annotations.where((a) => a.id == state.selectedAnnotationId);
    if (matches.isEmpty) return;
    
    final delta = position - state.dragStartPoint!;
    final orig = state.originalPoints!;
    
    if (state.activeResizeHandle != null) {
      // Resizing box
      final p1 = orig[0];
      final p2 = orig[1];
      
      Offset newP1 = p1;
      Offset newP2 = p2;
      
      final h = state.activeResizeHandle!;
      if (h == 0) {
        newP1 = p1 + delta;
      } else if (h == 1) {
        newP1 = Offset(p1.dx, p1.dy + delta.dy);
        newP2 = Offset(p2.dx + delta.dx, p2.dy);
      } else if (h == 2) {
        newP1 = Offset(p1.dx + delta.dx, p1.dy);
        newP2 = Offset(p2.dx, p2.dy + delta.dy);
      } else if (h == 3) {
        newP2 = p2 + delta;
      }
      
      state = state.copyWith(
        annotations: state.annotations.map((a) {
          if (a.id == state.selectedAnnotationId) {
            return AnnotationItem(
              id: a.id,
              type: a.type,
              points: [newP1, newP2],
              color: a.color,
              label: a.label,
            );
          }
          return a;
        }).toList(),
      );
    } else {
      // Dragging/moving the whole box
      final newP1 = orig[0] + delta;
      final newP2 = orig[1] + delta;
      
      state = state.copyWith(
        annotations: state.annotations.map((a) {
          if (a.id == state.selectedAnnotationId) {
            return AnnotationItem(
              id: a.id,
              type: a.type,
              points: [newP1, newP2],
              color: a.color,
              label: a.label,
            );
          }
          return a;
        }).toList(),
      );
    }
  }

  void onCursorUp() {
    state = state.copyWith(clearResize: true, clearDrag: true);
  }

  void undo() {
    if (state.undoStack.isEmpty) return;
    final prev = state.undoStack.last;
    final newStack = state.undoStack.sublist(0, state.undoStack.length - 1);
    state = state.copyWith(
      annotations: prev,
      undoStack: newStack,
    );
  }

  void clear() {
    state = state.copyWith(
      annotations: [],
      undoStack: [],
      currentPoints: [],
    );
  }
}

final annotationProvider =
    StateNotifierProvider<AnnotationNotifier, AnnotationState>(
  (ref) => AnnotationNotifier(),
);
