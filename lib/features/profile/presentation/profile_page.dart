import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/nav_bar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final email = authState.userEmail ?? 'engineer@company.com';
    final name = authState.userName ?? 'Project Manager';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

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
                  title: 'User Profile',
                  breadcrumb: 'CONSTRUCTIONHUB · ACCOUNT SERVICES',
                  onBack: () => context.goNamed('home'),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          // ── Body Scrollable ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile Detail Card
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Large Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              initials.isNotEmpty ? initials : 'PM',
                              style: GoogleFonts.sora(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // User Name
                        Text(
                          name,
                          style: GoogleFonts.sora(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text),
                        ),
                        const SizedBox(height: 4),
                        // Email
                        Text(
                          email,
                          style: GoogleFonts.sora(
                              fontSize: 13, color: AppColors.muted),
                        ),
                        const SizedBox(height: 24),
                        // Stats / Metadata Row
                        Row(
                          children: [
                            _metaField('ROLE', 'Lead Inspector'),
                            _metaDivider(),
                            _metaField('DEPT', 'Quality Control'),
                            _metaDivider(),
                            _metaField('EMP ID', 'CH-9482'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Settings options list
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _tileItem(
                          icon: Icons.manage_accounts_outlined,
                          title: 'Account Settings',
                          sub: 'Update personal profile details',
                        ),
                        _tileDivider(),
                        _tileItem(
                          icon: Icons.security_outlined,
                          title: 'SSO & Security',
                          sub: 'Manage enterprise authentication',
                        ),
                        _tileDivider(),
                        _tileItem(
                          icon: Icons.cloud_done_outlined,
                          title: 'Offline Syncing',
                          sub: 'All audits synced successfully',
                          showGreenBadge: true,
                        ),
                        _tileDivider(),
                        _tileItem(
                          icon: Icons.help_outline_rounded,
                          title: 'Enterprise Support',
                          sub: 'Contact organization tech desk',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  ElevatedButton.icon(
                    onPressed: () {
                      authNotifier.logout();
                      context.go('/');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.navy,
                          content: Text(
                            'Logged out of ConstructionHub SSO.',
                            style: GoogleFonts.sora(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: Text(
                      'Disconnect Session (Logout)',
                      style: GoogleFonts.sora(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaField(String label, String val) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.ibmPlexMono(fontSize: 10, color: AppColors.slate),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: GoogleFonts.sora(
                fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.text),
          ),
        ],
      ),
    );
  }

  Widget _metaDivider() {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.border,
    );
  }

  Widget _tileItem({
    required IconData icon,
    required String title,
    required String sub,
    bool showGreenBadge = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.light,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.navy,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text),
                    ),
                    if (showGreenBadge) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.tagGreenBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ACTIVE',
                          style: GoogleFonts.ibmPlexMono(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.green),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  sub,
                  style: GoogleFonts.sora(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.slate),
        ],
      ),
    );
  }

  Widget _tileDivider() {
    return Container(
      height: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
