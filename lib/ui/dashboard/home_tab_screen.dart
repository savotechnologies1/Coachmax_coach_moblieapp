import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../core/theme/brand_colors.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/bloc/home/home_cubit.dart';
import 'package:coachmax_coach/bloc/home/home_state.dart';
import 'package:coachmax_coach/ui/dashboard/assigned_classes_screen.dart';
import 'package:coachmax_coach/ui/dashboard/class_details_screen.dart';
import 'package:coachmax_coach/bloc/profile/profile_cubit.dart';
import 'package:coachmax_coach/bloc/profile/profile_state.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/ui/dashboard/dashboard_screen.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({Key? key}) : super(key: key);

  @override
  _HomeTabScreenState createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial || state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return Center(
            child: AppStateView(
              title: 'Unable to load your sessions',
              message: state.message,
              icon: Icons.wifi_off_rounded,
              actionLabel: 'Try again',
              onAction: () => context.read<HomeCubit>().fetchClasses(),
            ),
          );
        } else if (state is HomeLoaded) {
          final classes = state.classes;
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      if (classes.isNotEmpty)
                        _buildNextSessionCard(classes.first),
                      const SizedBox(height: 32),
                      _buildTodayScheduleSection(classes, context),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE, d MMM');

    String greeting = 'Morning';
    if (now.hour >= 12 && now.hour < 17) {
      greeting = 'Afternoon';
    } else if (now.hour >= 17) {
      greeting = 'Evening';
    }

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        String name = 'Coach';
        String? profileImage;
        if (profileState is ProfileLoaded) {
          name = profileState.profile.name?.split(' ').first ?? 'Coach';
          profileImage = profileState.profile.profileImage;
        } else if (profileState is ProfileUpdateLoading) {
          name = profileState.currentProfile.name?.split(' ').first ?? 'Coach';
          profileImage = profileState.currentProfile.profileImage;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatter.format(now),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$greeting, $name',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              tooltip: 'Open profile',
              onPressed: () => context
                  .findAncestorStateOfType<DashboardScreenState>()
                  ?.changeTab(3),
              icon: CircleAvatar(
                radius: 22,
                backgroundColor: BrandColors.primarySoft,
                foregroundColor: BrandColors.primary,
                backgroundImage: profileImage != null && profileImage.isNotEmpty
                    ? NetworkImage(Constants.baseurlImg + profileImage)
                    : null,
                child: profileImage == null || profileImage.isEmpty
                    ? const Icon(Icons.person_outline_rounded)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNextSessionCard(ClassDataDto classData) {
    // classData is of type ClassDataDto, but leaving dynamic for short code if needed
    final className = classData.className ?? "Unknown Class";
    final startTimeStr = classData.startTime ?? "";
    final location = classData.location ?? "Others";
    final players = classData.totalPlayers?.toString() ?? "0";
    final capacity = classData.capacity?.toString() ?? "0";

    // Format time and calculate starts in
    String startsIn = 'Starts soon';
    String timeFormatted = startTimeStr;
    try {
      final now = DateTime.now();
      final format = DateFormat("h:mm a");
      final startParsed = format.parse(startTimeStr);
      final startTime = DateTime(
        now.year,
        now.month,
        now.day,
        startParsed.hour,
        startParsed.minute,
      );

      timeFormatted = DateFormat("HH:mm").format(startTime);

      if (startTime.isAfter(now)) {
        final diff = startTime.difference(now);
        if (diff.inHours > 0) {
          startsIn =
              'Starts in ${diff.inHours} h ${diff.inMinutes.remainder(60)} min';
        } else {
          startsIn = 'Starts in ${diff.inMinutes} min';
        }
      } else {
        startsIn = 'Started';
      }
    } catch (e) {
      // ignore
    }

    String getSessionDate(ClassDataDto classData) {
      if (classData.sessions != null && classData.sessions!.isNotEmpty) {
        final now = DateTime.now();
        for (var session in classData.sessions!) {
          if (session.date != null) {
            try {
              final parsedDate = DateTime.parse(session.date!);
              if (parsedDate.year == now.year &&
                  parsedDate.month == now.month &&
                  parsedDate.day == now.day) {
                return session.date!.split('T')[0];
              }
            } catch (_) {}
          }
        }
        if (classData.sessions!.first.date != null) {
          return classData.sessions!.first.date!.split('T')[0];
        }
      }
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    return Material(
      color: BrandColors.navy,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClassDetailsScreen(
              classData: classData,
              targetDateStr: getSessionDate(classData),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'SESSION SPOTLIGHT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: BrandColors.onNavyAccent,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    startsIn,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: BrandColors.onNavyMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                className,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: BrandColors.onNavy),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: BrandColors.onNavyMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      location,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: BrandColors.onNavyMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Wrap(
                spacing: 32,
                runSpacing: 16,
                children: [
                  _sessionMetric('PLAYERS', '$players / $capacity'),
                  _sessionMetric('START TIME', timeFormatted),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(color: BrandColors.onNavyMuted, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Open session',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: BrandColors.onNavy,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: BrandColors.onNavy,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sessionMetric(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: BrandColors.onNavyMuted,
          letterSpacing: .8,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: BrandColors.onNavy),
      ),
    ],
  );

  Widget _buildTodayScheduleSection(List classes, BuildContext context) {
    final now = DateTime.now();
    final todayStr = DateFormat(
      'EEEE',
    ).format(now).toUpperCase(); // e.g. "MONDAY"

    // Filter only today's classes
    var todaysClasses = classes
        .where((cls) => cls.dayOfWeek == todayStr)
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Today’s schedule',
                style: TextStyle(
                  fontSize: AppTypography.title,
                  fontWeight: FontWeight.bold,
                  color: BrandColors.navy,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AssignedClassesScreen(),
                  ),
                );
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                  color: BrandColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (todaysClasses.isEmpty)
          const AppStateView(
            title: 'A little room to prepare',
            message:
                'No sessions scheduled for today. Your assigned classes are available in View all.',
          ),
        ...todaysClasses.map((cls) {
          final timeStr = cls.startTime ?? "";
          final endTimeStr = cls.endTime ?? "";

          bool isLive = false;
          bool isCompleted = false;
          double progress = 0.0;
          String timeFormatted = timeStr;

          try {
            // Parse "4:15 PM" strings into DateTimes for today
            final format = DateFormat("h:mm a");
            final startParsed = format.parse(timeStr);
            final endParsed = format.parse(endTimeStr);

            final startTime = DateTime(
              now.year,
              now.month,
              now.day,
              startParsed.hour,
              startParsed.minute,
            );
            final endTime = DateTime(
              now.year,
              now.month,
              now.day,
              endParsed.hour,
              endParsed.minute,
            );

            timeFormatted = DateFormat("HH:mm").format(startTime);

            if (now.isAfter(startTime) && now.isBefore(endTime)) {
              isLive = true;
              final totalDuration = endTime.difference(startTime).inMinutes;
              final elapsed = now.difference(startTime).inMinutes;
              if (totalDuration > 0) {
                progress = elapsed / totalDuration;
              }
            } else if (now.isAfter(endTime)) {
              isCompleted = true;
            }
          } catch (e) {
            // Ignore parse errors, fallback to UPCOMING
          }

          String getSessionDate(ClassDataDto classData) {
            if (classData.sessions != null && classData.sessions!.isNotEmpty) {
              final today = DateTime.now();
              for (var session in classData.sessions!) {
                if (session.date != null) {
                  try {
                    final parsedDate = DateTime.parse(session.date!);
                    if (parsedDate.year == today.year &&
                        parsedDate.month == today.month &&
                        parsedDate.day == today.day) {
                      return session.date!.split('T')[0];
                    }
                  } catch (_) {}
                }
              }
              if (classData.sessions!.first.date != null) {
                return classData.sessions!.first.date!.split('T')[0];
              }
            }
            return DateFormat('yyyy-MM-dd').format(DateTime.now());
          }

          String statusText = isLive
              ? 'LIVE'
              : (isCompleted ? 'COMPLETED' : 'UPCOMING');
          Color statusColor = isLive
              ? BrandColors.successText
              : (isCompleted
                    ? BrandColors.textMuted
                    : BrandColors
                          .error); // Use red for upcoming, green for live
          Color statusBgColor = isLive
              ? BrandColors.successText.withOpacity(0.2)
              : (isCompleted ? BrandColors.background : BrandColors.errorSoft);

          if (statusText == 'UPCOMING') {
            statusColor = BrandColors.textMuted;
            statusBgColor = BrandColors.background;
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailsScreen(
                    classData: cls,
                    targetDateStr: getSessionDate(cls),
                  ),
                ),
              );
            },
            child: Column(
              children: [
                _buildScheduleItem(
                  time: timeFormatted,
                  title: cls.className ?? "Unknown Class",
                  location: cls.location ?? "Others",
                  status: statusText,
                  statusColor: statusColor,
                  statusBgColor: statusBgColor,
                  progress: progress,
                  progressText: '${(progress * 100).toInt()}%',
                  timeBgColor: isLive
                      ? BrandColors.navy
                      : BrandColors.background,
                  timeTextColor: isLive ? Colors.white : BrandColors.textMuted,
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildScheduleItem({
    required String time,
    required String title,
    required String location,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required double progress,
    required String progressText,
    required Color timeBgColor,
    required Color timeTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: BrandColors.divider)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: timeBgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: timeTextColor,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: BrandColors.navy,
                          fontSize: AppTypography.bodyLarge,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: AppTypography.caption,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: BrandColors.textMuted,
                    fontSize: AppTypography.caption,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                if (status == 'LIVE')
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: BrandColors
                                .background, // Grey background for empty part
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              BrandColors.primary,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        progressText,
                        style: const TextStyle(
                          color: BrandColors.textMuted,
                          fontSize: AppTypography.caption,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
