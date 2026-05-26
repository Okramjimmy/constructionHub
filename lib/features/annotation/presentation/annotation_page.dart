import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../models/annotation_model.dart';
import '../providers/annotation_provider.dart';
import '../widgets/annotation_canvas.dart';
import '../../../core/theme/app_colors.dart';

class AnnotationPage extends ConsumerWidget {
  const AnnotationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(annotationProvider);
    final notifier = ref.read(annotationProvider.notifier);
    final defectCount = state.annotations.length;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Column(
        children: [
          // ── Navy Header ─────────────────────────────────────
          Container(
            color: AppColors.navy,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: Row(
                    children: [
                      // Back
                      GestureDetector(
                        onTap: () => context.goNamed('home'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.chevron_left_rounded,
                              color: AppColors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Image Annotation',
                              style: GoogleFonts.sora(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white),
                            ),
                            Text(
                              'CONSTRUCTIONHUB · COLUMN C-4',
                              style: GoogleFonts.ibmPlexMono(
                                  fontSize: 11,
                                  color:
                                      Colors.white.withValues(alpha: 0.55)),
                            ),
                          ],
                        ),
                      ),
                      // Upload button
                      GestureDetector(
                        onTap: () async {
                          final picker = ImagePicker();
                          final img = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (img != null) {
                            notifier.setImagePath(img.path);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.orange.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined,
                                  color: AppColors.orange, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'UPLOAD',
                                style: GoogleFonts.ibmPlexMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.orange),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Undo button
                      GestureDetector(
                        onTap: notifier.undo,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'UNDO',
                            style: GoogleFonts.ibmPlexMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Canvas Area ─────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                const AnnotationCanvas(),
                // Defect count badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color:
                              const Color(0xFFEF4444).withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      '$defectCount DEFECT${defectCount == 1 ? '' : 'S'} TAGGED',
                      style: GoogleFonts.ibmPlexMono(
                          fontSize: 10,
                          color: const Color(0xFFEF4444)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Toolbar ─────────────────────────────────────────
          Container(
            color: const Color(0xFF0F172A),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                _ToolButton(
                  icon: Icons.near_me_outlined,
                  isActive:
                      state.activeTool == AnnotationTool.cursor,
                  onTap: () => notifier.setTool(AnnotationTool.cursor),
                ),
                _ToolButton(
                  icon: Icons.crop_square_outlined,
                  isActive:
                      state.activeTool == AnnotationTool.boundingBox,
                  onTap: () =>
                      notifier.setTool(AnnotationTool.boundingBox),
                ),
                _ToolButton(
                  icon: Icons.gesture,
                  isActive:
                      state.activeTool == AnnotationTool.freehand,
                  onTap: () =>
                      notifier.setTool(AnnotationTool.freehand),
                ),
                _ToolButton(
                  icon: Icons.text_fields_outlined,
                  isActive:
                      state.activeTool == AnnotationTool.text,
                  onTap: () =>
                      notifier.setTool(AnnotationTool.text),
                ),
                // Color picker
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showColorPicker(
                        context, notifier, state.activeColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: state.activeColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Save Bar ────────────────────────────────────────
          Container(
            color: const Color(0xFF0F172A),
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.green,
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'Canvas saved & exported!',
                          style: GoogleFonts.sora(
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.save_outlined, size: 16),
              label: Text(
                'Save & Export Canvas',
                style: GoogleFonts.sora(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker(
      BuildContext context, AnnotationNotifier notifier, Color current) {
    const colors = [
      Color(0xFFEF4444), // red
      Color(0xFFFF6B00), // orange
      Color(0xFF1A9E5C), // green
      Color(0xFF3B82F6), // blue
      Color(0xFFFACC15), // yellow
      Color(0xFFFFFFFF), // white
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Annotation Color',
              style: GoogleFonts.sora(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors
                  .map((c) => GestureDetector(
                        onTap: () {
                          notifier.setColor(c);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: c == current
                                ? Border.all(
                                    color: Colors.white, width: 3)
                                : null,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.orange.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? AppColors.orange : AppColors.slate,
          ),
        ),
      ),
    );
  }
}
