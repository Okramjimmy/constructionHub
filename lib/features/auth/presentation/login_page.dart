import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = ref.read(authProvider.notifier);
    final success = await auth.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) {
      context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.light,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            // ── Navy Header ───────────────────────────────────
            _buildHeader(),
            // ── Login Card Body ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
                child: _buildLoginCard(isLoading, authState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(28, 56, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo mark
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.domain, color: AppColors.white, size: 30),
          ),
          const SizedBox(height: 16),
          Text(
            'ConstructionHub',
            style: GoogleFonts.sora(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'CONSTRUCTION QUALITY CONTROL',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 12,
              color: AppColors.slate,
              letterSpacing: 0.08,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isLoading, AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back',
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Sign in to your enterprise account',
            style: GoogleFonts.sora(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 28),

          // Username field
          _fieldLabel('Username'),
          const SizedBox(height: 8),
          _buildField(
            controller: _usernameController,
            hint: 'Enter your username',
            icon: Icons.person_outline_rounded,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 20),

          // Password field
          _fieldLabel('Password'),
          const SizedBox(height: 8),
          _buildField(
            controller: _passwordController,
            hint: '••••••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            suffix: GestureDetector(
              onTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.slate,
                size: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Forgot Password?',
                  style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.orange)),
            ),
          ),

          // Error message
          if (authState.status == AuthStatus.error)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.tagRedBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authState.errorMessage ?? '',
                        style: GoogleFonts.sora(
                            fontSize: 12, color: AppColors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 28),
          PrimaryButton(
            label: 'Secure Login',
            icon: Icons.shield_outlined,
            onPressed: _handleLogin,
            isLoading: isLoading,
          ),
          const SizedBox(height: 20),

          // Biometric hint
          Center(
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Biometric auth — coming in next release!')),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fingerprint, color: AppColors.navy, size: 20),
                  const SizedBox(width: 6),
                  Text('Use Biometrics',
                      style: GoogleFonts.sora(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.navy)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text.rich(
              TextSpan(
                text: 'Protected by enterprise SSO · ',
                style:
                    GoogleFonts.sora(fontSize: 11, color: AppColors.muted),
                children: [
                  TextSpan(
                    text: 'v2.4.1',
                    style: GoogleFonts.sora(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.sora(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.muted,
        letterSpacing: 0.06,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.slate, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: GoogleFonts.sora(fontSize: 14, color: AppColors.text),
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                hintStyle:
                    GoogleFonts.sora(fontSize: 14, color: AppColors.muted),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }
}
