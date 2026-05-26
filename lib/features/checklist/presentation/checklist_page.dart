import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/checklist_provider.dart';
import '../widgets/checklist_item_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/nav_bar.dart';

class ChecklistPage extends ConsumerWidget {
  const ChecklistPage({
    super.key,
    required this.formTypeId,
    required this.checklistName,
    required this.subtypeName,
  });

  final String formTypeId;
  final String checklistName;
  final String subtypeName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checklistProvider(formTypeId));
    final notifier = ref.read(checklistProvider(formTypeId).notifier);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Navy Header ─────────────────────────────────
              Container(
                color: AppColors.navy,
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).padding.top + 8),
                    AppNavBar(
                      title: checklistName,
                      breadcrumb:
                          '${subtypeName.toUpperCase()} › CHECKLIST',
                      onBack: () => context.goNamed('subtypes',
                          extra: 'Skyline Towers — Block A'),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
              // ── Scrollable Body ─────────────────────────────
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: AppColors.navy),
                      )
                    : state.errorMessage != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: AppColors.red, size: 40),
                                  const SizedBox(height: 12),
                                  Text(
                                    state.errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.sora(
                                        color: AppColors.text,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.navy,
                                      foregroundColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => notifier.reset(),
                                    child: Text('Retry', style: GoogleFonts.sora()),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                            children: [
                              // Progress card
                              _buildProgressCard(state.completedCount,
                                  state.items.length, state.progress),
                              const SizedBox(height: 16),
                              // Checklist items
                              ...state.items.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: ChecklistItemCard(
                                      formTypeId: formTypeId,
                                      item: item,
                                    ),
                                  )),
                              // Remarks
                              _RemarksField(),
                              const SizedBox(height: 12),
                            ],
                          ),
              ),
            ],
          ),
          // ── Sticky Actions Footer ──────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 16, 16, MediaQuery.of(context).padding.bottom + 16),
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                    top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  // ── Save Draft Button ──
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: state.isSubmitting || state.isSavingDraft
                          ? null
                          : () async {
                              final success = await notifier.saveDraft();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.green,
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Draft saved successfully!',
                                          style: GoogleFonts.sora(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                      icon: state.isSavingDraft
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      AppColors.navy)),
                            )
                          : const Icon(Icons.save_outlined, size: 16),
                      label: Text(
                        state.isSavingDraft ? 'Saving...' : 'Save Draft',
                        style: GoogleFonts.sora(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.navy,
                        side: const BorderSide(color: AppColors.navy, width: 1.5),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // ── Submit Button ──
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: state.isSubmitting || state.isSavingDraft
                          ? null
                          : () async {
                              final success = await notifier.submit();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.green,
                                    content: Row(
                                      children: [
                                        const Icon(Icons.verified_user,
                                            color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Inspection submitted & locked!',
                                          style: GoogleFonts.sora(
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                notifier.reset();
                              }
                            },
                      icon: state.isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                      Colors.white)),
                            )
                          : const Icon(Icons.send_rounded, size: 16),
                      label: Text(
                        state.isSubmitting ? 'Submitting...' : 'Submit Form',
                        style: GoogleFonts.sora(
                            fontSize: 13, fontWeight: FontWeight.w700),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(int done, int total, double progress) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Completion',
                style: GoogleFonts.sora(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text),
              ),
              Text(
                '$done of $total done',
                style: GoogleFonts.sora(
                    fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.light,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class _RemarksField extends ConsumerStatefulWidget {
  @override
  ConsumerState<_RemarksField> createState() => _RemarksFieldState();
}

class _RemarksFieldState extends ConsumerState<_RemarksField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: TextField(
        controller: _ctrl,
        maxLines: 4,
        style: GoogleFonts.sora(fontSize: 13, color: AppColors.text),
        decoration: InputDecoration(
          hintText: 'Site Engineer Remarks...',
          hintStyle:
              GoogleFonts.sora(fontSize: 13, color: AppColors.muted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }
}
