import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/profile/profile_cubit.dart';
import 'package:coachmax_coach/bloc/profile/profile_state.dart';
import 'package:coachmax_coach/dto/my_profile_response_dto.dart';
import 'package:coachmax_coach/ui/dashboard/edit_profile_screen.dart';
import 'package:coachmax_coach/ui/dashboard/temporary_players_screen.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/ui/auth/login_screen.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final isLoading =
            state is ProfileLoading || state is ProfileUpdateLoading;
        ProfileDataDto? profile;
        if (state is ProfileLoaded) {
          profile = state.profile;
        } else if (state is ProfileUpdateLoading) {
          profile = state.currentProfile;
        } else if (state is ProfileUpdateError) {
          profile = state.currentProfile;
        }

        return Scaffold(
          backgroundColor: BrandColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<ProfileCubit>().fetchMyProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        const Text(
                          'Coach profile',
                          style: TextStyle(
                            fontSize: AppTypography.pageTitle,
                            fontWeight: FontWeight.bold,
                            color: BrandColors.text,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (profile != null) {
                              final cubit = context.read<ProfileCubit>();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (routeContext) => EditProfileScreen(
                                    profile: profile!,
                                    cubit: cubit,
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Edit profile',
                            style: TextStyle(
                              fontSize: AppTypography.body,
                              fontWeight: FontWeight.w600,
                              color: BrandColors.error, // Red color
                              decoration: TextDecoration.underline,
                              decorationColor: BrandColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Profile Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: BrandColors.navy,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image:
                                        (profile != null &&
                                            profile.profileImage != null)
                                        ? NetworkImage(
                                            '${Constants.baseurlImg}${profile.profileImage}',
                                          )
                                        : const NetworkImage(
                                                'https://i.pravatar.cc/150?img=11',
                                              )
                                              as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile?.name ?? 'Loading...',
                                      style: const TextStyle(
                                        fontSize: AppTypography.section,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profile?.mobile ?? 'Loading...',
                                      style: TextStyle(
                                        fontSize: AppTypography.body,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      profile?.email ?? 'Loading...',
                                      style: TextStyle(
                                        fontSize: AppTypography.caption,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                '${profile?.assignedClassesCount ?? 0}',
                                'Classes',
                              ),
                              _buildStatItem(
                                '${profile?.uniquePlayersCount ?? 0}',
                                'Players',
                              ),
                              _buildStatItem(
                                '${profile?.overallAttendancePercentage?.toInt() ?? 0}%',
                                'Attendance',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Performance Overview Title
                    const Text(
                      'Performance overview',
                      style: TextStyle(
                        fontSize: AppTypography.title,
                        fontWeight: FontWeight.bold,
                        color: BrandColors.text,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Overview Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Player Assign',
                                  style: TextStyle(
                                    color: BrandColors.textMuted,
                                    fontSize: AppTypography.caption,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${profile?.uniquePlayersCount ?? 0}',
                                      style: const TextStyle(
                                        fontSize: AppTypography.pageTitle,
                                        fontWeight: FontWeight.bold,
                                        color: BrandColors.text,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TemporaryPlayersScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        '${profile?.temporaryPlayersThisMonthCount ?? 0} Temporary',
                                        style: const TextStyle(
                                          color: BrandColors.primary,
                                          fontSize: AppTypography.caption,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          decorationColor: BrandColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0.8,
                                    backgroundColor: BrandColors.background,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          BrandColors.navy,
                                        ),
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'THIS MONTH',
                                  style: TextStyle(
                                    color: BrandColors.textMuted,
                                    fontSize: AppTypography.caption,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '${profile?.sessionsToBeDeliveredThisMonthCount ?? 0}',
                                  style: const TextStyle(
                                    fontSize: AppTypography.pageTitle,
                                    fontWeight: FontWeight.bold,
                                    color: BrandColors.text,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Sessions delivered',
                                  style: const TextStyle(
                                    color: BrandColors.textMuted,
                                    fontSize: AppTypography.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48), // Spacing before logout button
                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to log out?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await SharedPrefsHelper.clearToken();
                                      if (context.mounted) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: BrandColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: BrandColors
                              .errorSoft, // Very light red/pink background
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Log out',
                          style: TextStyle(
                            color: BrandColors.error, // Red text
                            fontSize: AppTypography.bodyLarge,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: AppTypography.section,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: AppTypography.caption,
          ),
        ),
      ],
    );
  }
}
