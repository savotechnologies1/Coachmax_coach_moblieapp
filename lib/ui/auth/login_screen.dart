import '../../core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../core/theme/brand_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../utils/component/Appassets.dart';
import 'sign_in_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BrandColors.navy,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset(
                          AppAssets.logo,
                          height: 160,
                          semanticLabel: 'CoachMax Football Academy',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'THE COACHING WORKSPACE',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: BrandColors.onNavyAccent,
                                  letterSpacing: 1.6,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bring out\ntheir best.',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontSize: AppTypography.hero,
                                  color: BrandColors.onNavy,
                                ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Every player. Every session.\nEverything you need to coach with confidence.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: BrandColors.onNavyMuted),
                          ),
                          const SizedBox(height: 36),
                          AppButton(
                            label: 'Get started',
                            icon: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
