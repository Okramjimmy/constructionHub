import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/home_stats_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(homeStatsProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.light,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, stats, authState),
            _buildMenuGrid(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeStats stats, AuthState authState) {
    final name = authState.userName ?? 'Project Manager';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(24, 52, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top bar
          Row(
            children: [
              // Clickable Avatar
              GestureDetector(
                onTap: () => context.goNamed('profile'),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials.isNotEmpty ? initials : 'PM',
                      style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning,',
                      style: GoogleFonts.ibmPlexMono(
                          fontSize: 12, color: AppColors.slate),
                    ),
                    Text(
                      name,
                      style: GoogleFonts.sora(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white),
                    ),
                  ],
                ),
              ),
              // Bell
              Stack(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.navy, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Logo row
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.domain,
                    color: AppColors.white, size: 14),
              ),
              const SizedBox(width: 6),
              Text(
                'ConstructionHub',
                style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stat chips
          Row(
            children: [
              _statChip('${stats.activeSites}', 'ACTIVE SITES'),
              const SizedBox(width: 12),
              _statChip('${stats.inspections}', 'INSPECTIONS'),
              const SizedBox(width: 12),
              _statChip(stats.passRate, 'PASS RATE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: GoogleFonts.ibmPlexMono(
                  fontSize: 10, color: AppColors.slate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _menuCard(
                  context: context,
                  icon: Icons.folder_outlined,
                  label: 'Projects Portal',
                  sub: '12 active sites →',
                  onTap: () => context.goNamed('projects'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _menuCard(
                  context: context,
                  icon: Icons.assignment_outlined,
                  label: 'Daily Inspection Reports',
                  sub: '3 pending today →',
                  onTap: () => context.goNamed('checklist'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _menuCard(
                  context: context,
                  icon: Icons.memory_outlined,
                  label: 'AI Image Processing',
                  sub: '94.2% accuracy →',
                  isOrange: true,
                  onTap: () => context.goNamed('ai'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _menuCard(
                  context: context,
                  icon: Icons.image_outlined,
                  label: 'Image Annotation Tool',
                  sub: 'Open canvas →',
                  isOrange: true,
                  onTap: () => context.goNamed('annotation'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Quick Scan FAB
          GestureDetector(
            onTap: () => context.goNamed('checklist'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt, color: AppColors.orange, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    '⚡ Instant Quick Scan',
                    style: GoogleFonts.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String sub,
    bool isOrange = false,
    required VoidCallback onTap,
  }) {
    final bg = isOrange ? AppColors.orange : AppColors.white;
    final iconBg = isOrange
        ? Colors.white.withValues(alpha: 0.2)
        : AppColors.light;
    final iconColor = isOrange ? AppColors.white : AppColors.navy;
    final labelColor = isOrange ? AppColors.white : AppColors.text;
    final subColor =
        isOrange ? Colors.white.withValues(alpha: 0.7) : AppColors.slate;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 160,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOrange ? AppColors.orange2 : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.sora(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: labelColor,
                        height: 1.35)),
                const SizedBox(height: 4),
                Text(sub,
                    style: GoogleFonts.ibmPlexMono(
                        fontSize: 10, color: subColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
