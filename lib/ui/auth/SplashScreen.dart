import 'package:flutter/material.dart';
import '../../core/theme/brand_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../utils/component/Appassets.dart';
import '../../utils/shared_prefs_helper.dart';
import '../dashboard/dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openWorkspace();
  }

  Future<void> _openWorkspace() async {
    final token = await SharedPrefsHelper.getToken();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => token == null || token.isEmpty
            ? const LoginScreen()
            : const DashboardScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BrandColors.navy,
    body: Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.standard,
        builder: (_, value, child) => Opacity(opacity: value, child: child),
        child: Image.asset(
          AppAssets.logo,
          width: 180,
          semanticLabel: 'CoachMax Football Academy',
        ),
      ),
    ),
  );
}
