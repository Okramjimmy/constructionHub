import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/subtype_model.dart';
import '../providers/projects_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/nav_bar.dart';

class SubtypesPage extends ConsumerWidget {
  const SubtypesPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  final String projectId;
  final String projectName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stagesWithFormsAsync = ref.watch(projectStagesAndFormsProvider(projectId));

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
                  title: 'Project Phases & Forms',
                  breadcrumb: projectName.toUpperCase(),
                  onBack: () => context.goNamed('projects'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          // ── Dynamic Collapsible Stages & Forms ──────────────
          Expanded(
            child: stagesWithFormsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.navy),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.red, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load stages & forms:',
                        style: GoogleFonts.sora(
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              data: (stagesWithForms) {
                if (stagesWithForms.isEmpty) {
                  return Center(
                    child: Text(
                      'No stages or forms found for this project.',
                      style: GoogleFonts.sora(color: AppColors.muted),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  itemCount: stagesWithForms.length,
                  itemBuilder: (context, index) {
                    final item = stagesWithForms[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CollapsibleStageCard(stageItem: item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleStageCard extends StatefulWidget {
  const _CollapsibleStageCard({required this.stageItem});
  final StageWithForms stageItem;

  @override
  State<_CollapsibleStageCard> createState() => _CollapsibleStageCardState();
}

class _CollapsibleStageCardState extends State<_CollapsibleStageCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = true;
  late AnimationController _animController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) {
      _animController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  IconData _getStageIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('civil') || lower.contains('concrete') || lower.contains('foundation') || lower.contains('rebar') || lower.contains('aac')) {
      return Icons.foundation_outlined;
    }
    if (lower.contains('electrical') || lower.contains('power') || lower.contains('mep')) {
      return Icons.electrical_services_outlined;
    }
    if (lower.contains('road') || lower.contains('pqc') || lower.contains('pavement') || lower.contains('grade')) {
      return Icons.edit_road_outlined;
    }
    if (lower.contains('water') || lower.contains('plumbing') || lower.contains('waterproofing') || lower.contains('wet')) {
      return Icons.water_drop_outlined;
    }
    if (lower.contains('finish') || lower.contains('plaster') || lower.contains('tile') || lower.contains('brick')) {
      return Icons.architecture_outlined;
    }
    if (lower.contains('safety') || lower.contains('hse') || lower.contains('compliance') || lower.contains('sign')) {
      return Icons.health_and_safety_outlined;
    }
    return Icons.layers_outlined;
  }

  Color _getStageColor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('civil') || lower.contains('concrete')) return AppColors.navy;
    if (lower.contains('electrical') || lower.contains('mep')) return AppColors.green;
    if (lower.contains('road') || lower.contains('pqc')) return AppColors.orange;
    if (lower.contains('water')) return Colors.blue;
    if (lower.contains('finish') || lower.contains('brick')) return Colors.teal;
    if (lower.contains('safety')) return AppColors.red;
    return AppColors.slate;
  }

  @override
  Widget build(BuildContext context) {
    final stage = widget.stageItem.stage;
    final forms = widget.stageItem.forms;
    final colorTheme = _getStageColor(stage.stageName);
    final totalForms = forms.length;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Stage Header ──────────────────────────────────────
          InkWell(
            onTap: _toggleExpand,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Animated thematic icon box
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colorTheme.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getStageIcon(stage.stageName),
                      color: colorTheme,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Stage Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stage.stageName,
                          style: GoogleFonts.sora(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        if (stage.stagePath != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            stage.stagePath!,
                            style: GoogleFonts.ibmPlexMono(
                              fontSize: 9,
                              color: AppColors.muted,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Meta Indicators
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: colorTheme.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${totalForms.toString().padLeft(2, '0')} FORMS',
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: colorTheme,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.25 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.slate,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ── Collapsible Forms Section ─────────────────────────
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              children: [
                const Divider(height: 1, color: AppColors.border),
                if (forms.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline_rounded, color: AppColors.slate, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'No forms linked to this construction phase.',
                          style: GoogleFonts.sora(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: forms.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final ft = forms[i];
                      final subtype = formTypeToSubtype(ft, i);
                      return _SubtypeCard(formTypeId: ft.formTypeId, subtype: subtype);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtypeCard extends StatelessWidget {
  const _SubtypeCard({required this.formTypeId, required this.subtype});
  final String formTypeId;
  final SubtypeModel subtype;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed('checklist', extra: {
        'formTypeId': formTypeId,
        'checklistName': '${subtype.name} Audit',
        'subtypeName': subtype.name,
      }),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.light,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: subtype.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(subtype.iconData, color: subtype.iconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtype.name,
                        style: GoogleFonts.sora(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtype.tags,
                        style: GoogleFonts.sora(
                          fontSize: 10,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, size: 12, color: AppColors.navy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
