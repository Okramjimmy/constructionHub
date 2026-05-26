import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/project_model.dart';
import '../providers/projects_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/nav_bar.dart';
import '../../../core/widgets/status_tag.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});

  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsListProvider);
    final filtered = projects
        .where((p) =>
            p.name.toLowerCase().contains(_query.toLowerCase()) ||
            p.address.toLowerCase().contains(_query.toLowerCase()))
        .toList();

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
                  title: 'Active Sites',
                  breadcrumb:
                  'CONSTRUCTIONHUB · ${projects.length} PROJECTS',
                  onBack: () => context.goNamed('home'),
                ),
                // Search bar
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppColors.slate, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (v) =>
                                setState(() => _query = v),
                            style: GoogleFonts.sora(
                                fontSize: 14,
                                color: AppColors.white),
                            decoration: InputDecoration(
                              hintText: 'Search projects...',
                              hintStyle: GoogleFonts.sora(
                                  fontSize: 14,
                                  color: AppColors.slate),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.tune,
                              color: AppColors.white, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Project Cards ────────────────────────────────────
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, i) =>
                  _ProjectCard(project: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed('subtypes',
          extra: {
            'projectId': project.id,
            'projectName': project.name,
          }),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: GoogleFonts.sora(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text),
                  ),
                ),
                const SizedBox(width: 8),
                StatusTag(
                    label: project.statusLabel,
                    type: project.tagType),
              ],
            ),
            const SizedBox(height: 8),
            // Address
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.slate, size: 13),
                const SizedBox(width: 5),
                Text(
                  '${project.address} · ${project.zone}',
                  style: GoogleFonts.sora(
                      fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Map thumbnail
            _MapThumbnail(project: project),
            const SizedBox(height: 12),
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${project.updatedAgo} · ${project.checklistCount} checklists',
                  style: GoogleFonts.ibmPlexMono(
                      fontSize: 11, color: AppColors.muted),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: AppColors.light,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right,
                      size: 14, color: AppColors.navy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MapThumbnail extends StatelessWidget {
  const _MapThumbnail({required this.project});
  final ProjectModel project;

  Color get _pinColor => switch (project.status) {
        ProjectStatus.inProgress => AppColors.orange,
        ProjectStatus.paused => AppColors.yellow,
        ProjectStatus.critical => AppColors.red,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(project.mapGradientStart),
            Color(project.mapGradientEnd),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Grid overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomPaint(
              painter: _GridPainter(),
              size: Size.infinite,
            ),
          ),
          // Map pin
          Center(
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _pinColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.location_on,
                  color: Colors.white, size: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x336482B4)
      ..strokeWidth = 1;
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
