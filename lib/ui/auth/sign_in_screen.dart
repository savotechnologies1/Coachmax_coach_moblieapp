import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/brand_colors.dart';
import '../../repository/auth_repository.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../utils/utility.dart';
import '../dashboard/dashboard_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthCubit _authCubit = AuthCubit(AuthRepository());
  bool _obscureText = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authCubit.close();
    super.dispose();
  }

  void _performLogin() {
    if (_authCubit.state is ResponseStateLoading) return;
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _error = null);
    _authCubit.loginApi({
      'email': _emailController.text.trim(),
      'password': _passwordController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return BlocProvider.value(
      value: _authCubit,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.page),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              color: BrandColors.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'COACHMAX / COACH',
                              style: text.labelSmall?.copyWith(
                                color: BrandColors.navy,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text('Welcome back.', style: text.headlineLarge),
                        const SizedBox(height: 12),
                        Text(
                          'A great session starts with you.',
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to manage your sessions, support your players and stay connected.',
                          style: text.bodyMedium?.copyWith(
                            color: BrandColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 36),
                        AppTextField(
                          label: 'Email address',
                          controller: _emailController,
                          hint: 'you@academy.com',
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty) {
                              return 'Enter your email address.';
                            }
                            if (!RegExp(
                              r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                            ).hasMatch(email)) {
                              return 'Enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _obscureText,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          autofillHints: const [AutofillHints.password],
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _performLogin(),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Enter your password.'
                              : null,
                          suffixIcon: IconButton(
                            tooltip: _obscureText
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        BlocConsumer<AuthCubit, ResponseState>(
                          listener: (context, state) {
                            if (state is ResponseStateSuccess) {
                              Utility().showFlushBar(
                                context: context,
                                message: 'Welcome back!',
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const DashboardScreen(),
                                ),
                              );
                            } else {
                              final message = switch (state) {
                                ResponseStateError() => state.errorMessage,
                                ResponseStateEmpty() => state.message,
                                ResponseStateNoInternet() => state.message,
                                _ => null,
                              };
                              if (message != null) {
                                setState(() => _error = message);
                              }
                            }
                          },
                          builder: (context, state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_error != null) ...[
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    _error!,
                                    style: text.bodyMedium?.copyWith(
                                      color: BrandColors.error,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                              ],
                              AppButton(
                                label: 'Sign in',
                                onPressed: _performLogin,
                                isLoading: state is ResponseStateLoading,
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 18,
                              color: BrandColors.textMuted,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Your coaching workspace. Access is limited to your assigned sessions and players.',
                                style: text.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
