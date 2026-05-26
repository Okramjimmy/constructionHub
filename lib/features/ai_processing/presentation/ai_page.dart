import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import '../providers/ai_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/nav_bar.dart';

class AiPage extends ConsumerWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiProvider);
    final notifier = ref.read(aiProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: Column(
        children: [
          // ── Navy Header ─────────────────────────────────────
          Container(
            color: AppColors.navy,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 8),
                AppNavBar(
                  title: 'AI Image Processing',
                  breadcrumb: 'CONSTRUCTIONHUB · DEFECT ENGINE',
                  onBack: () => context.goNamed('home'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          // ── Body ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Upload zone
                  _UploadZone(state: state, notifier: notifier),
                  const SizedBox(height: 16),

                  // Pipeline steps
                  _PipelineCard(step: state.step),
                  const SizedBox(height: 16),

                  // Stats card
                  _StatsCard(state: state),
                  const SizedBox(height: 16),

                  // CTA
                  ElevatedButton.icon(
                    onPressed: state.step == AiProcessingStep.processing
                        ? null
                        : () async {
                            final picker = ImagePicker();
                            final img = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (img != null) {
                              await notifier.uploadAndProcess(img.path);
                            } else {
                              // Demo: run without actual image
                              await notifier.uploadAndProcess('demo.jpg');
                            }
                          },
                    icon: const Icon(Icons.psychology_outlined, size: 18),
                    label: Text(
                      state.step == AiProcessingStep.processing
                          ? 'Analyzing...'
                          : 'Run AI Diagnosis',
                      style: GoogleFonts.sora(
                          fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Upload Zone ─────────────────────────────────────────────────────────────

class _UploadZone extends StatelessWidget {
  const _UploadZone({required this.state, required this.notifier});
  final AiState state;
  final AiNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final uploaded = state.imagePath != null;

    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final img = await picker.pickImage(source: ImageSource.gallery);
        if (img != null) await notifier.uploadAndProcess(img.path);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: uploaded ? AppColors.green : AppColors.border,
            width: uploaded ? 2 : 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              uploaded
                  ? Icons.check_circle_outline
                  : Icons.add_photo_alternate_outlined,
              size: 40,
              color: uploaded ? AppColors.green : AppColors.slate,
            ),
            const SizedBox(height: 12),
            Text(
              uploaded ? 'Photo Ready for Analysis' : 'Upload Site Photo for Analysis',
              style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text),
            ),
            const SizedBox(height: 6),
            Text(
              'AI Crack & Honeycombing Detection\nSupports JPG, PNG, HEIC · Max 25MB',
              textAlign: TextAlign.center,
              style: GoogleFonts.sora(
                  fontSize: 12,
                  color: AppColors.muted,
                  height: 1.5),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                uploaded ? '✓ PHOTO CHOSEN' : '+ CHOOSE PHOTO',
                style: GoogleFonts.ibmPlexMono(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pipeline Card ───────────────────────────────────────────────────────────

class _PipelineCard extends StatelessWidget {
  const _PipelineCard({required this.step});
  final AiProcessingStep step;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Image\nIngestion',
      'Cloud ML\nDetection',
      'Defect\nReport',
    ];

    int activeIdx = switch (step) {
      AiProcessingStep.idle => -1,
      AiProcessingStep.uploaded => 0,
      AiProcessingStep.processing => 1,
      AiProcessingStep.complete => 2,
      AiProcessingStep.error => -1,
    };

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROCESSING PIPELINE',
            style: GoogleFonts.ibmPlexMono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
                letterSpacing: 0.06),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (int i = 0; i < steps.length; i++) ...[
                _StepDot(
                    label: steps[i],
                    number: i + 1,
                    isDone: i < activeIdx,
                    isActive: i == activeIdx),
                if (i < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 24),
                      color: i < activeIdx
                          ? AppColors.navy
                          : AppColors.border,
                    ),
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.label,
    required this.number,
    required this.isDone,
    required this.isActive,
  });
  final String label;
  final int number;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    if (isDone) {
      bg = AppColors.navy;
      fg = AppColors.white;
    } else if (isActive) {
      bg = AppColors.orange;
      fg = AppColors.white;
    } else {
      bg = AppColors.light;
      fg = AppColors.muted;
    }

    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: (!isDone && !isActive)
                ? Border.all(color: AppColors.border, width: 2)
                : null,
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, color: fg, size: 16)
                : isActive
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(fg)))
                    : Text(
                        '$number',
                        style: GoogleFonts.ibmPlexMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: fg),
                      ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(
                fontSize: 10,
                color: AppColors.muted,
                height: 1.3),
          ),
        ),
      ],
    );
  }
}

// ── Stats Card ──────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.state});
  final AiState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REAL-TIME AI PERFORMANCE',
            style: GoogleFonts.ibmPlexMono(
                fontSize: 11, color: AppColors.slate),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Accuracy ring
              _AccuracyRing(
                  value: state.overallAccuracy / 100),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DEFECT IDENTIFICATION ACCURACY',
                      style: GoogleFonts.ibmPlexMono(
                          fontSize: 10, color: AppColors.slate),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${state.overallAccuracy}%',
                      style: GoogleFonts.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${state.imagesProcessed} images · ${state.avgMs}ms avg',
                      style: GoogleFonts.ibmPlexMono(
                          fontSize: 11, color: AppColors.slate),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _StatMini(
                    label: 'CRACKS',
                    value: '${state.crackAccuracy}%'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatMini(
                    label: 'HONEYCOMB',
                    value: '${state.honeycombAccuracy}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AccuracyRing extends StatelessWidget {
  const _AccuracyRing({required this.value});
  final double value; // 0.0–1.0

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(
        painter: _RingPainter(value: value),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (value * 100).toStringAsFixed(1),
                style: GoogleFonts.sora(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    height: 1),
              ),
              Text(
                '%',
                style: GoogleFonts.ibmPlexMono(
                    fontSize: 9, color: AppColors.slate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.value});
  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 8.0;

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = AppColors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.value != value;
}

class _StatMini extends StatelessWidget {
  const _StatMini({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(
                fontSize: 10, color: AppColors.slate),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.sora(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
