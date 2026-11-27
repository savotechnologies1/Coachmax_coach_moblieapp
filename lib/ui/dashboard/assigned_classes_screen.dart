import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:coachmax_coach/bloc/home/home_cubit.dart';
import 'package:coachmax_coach/bloc/home/home_state.dart';
import 'package:coachmax_coach/ui/dashboard/class_details_screen.dart';
import 'package:coachmax_coach/ui/dashboard/chat_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/utils/utility.dart';
import 'package:coachmax_coach/bloc/class_details/class_details_state.dart';
import 'package:coachmax_coach/ui/dashboard/notifications_screen.dart';

class AssignedClassesScreen extends StatefulWidget {
  const AssignedClassesScreen({Key? key}) : super(key: key);

  @override
  _AssignedClassesScreenState createState() => _AssignedClassesScreenState();
}

class _AssignedClassesScreenState extends State<AssignedClassesScreen> {
  String _selectedTab = 'Today';
  List<ClassDataDto> _cachedClasses = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchClasses(),
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: SafeArea(
          child: BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeBroadcastSuccess) {
                Utility().showFlushBar(
                  context: context,
                  message: state.message,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      conversationId: state.conversationId,
                      name: state.conversationName,
                      isGroup: true,
                    ),
                  ),
                );
              } else if (state is HomeBroadcastError) {
                Utility().showFlushBar(
                  context: context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              bool isLoadingMore = false;
              if (state is HomeLoaded) {
                _cachedClasses = state.classes;
                isLoadingMore = state.isLoadingMore;
              }

              if (state is HomeInitial ||
                  (state is HomeLoading && _cachedClasses.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError && _cachedClasses.isEmpty) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: BrandColors.error),
                  ),
                );
              }

              return Stack(
                children: [
                  _buildContent(context, _cachedClasses, isLoadingMore),
                  if ((state is HomeLoading && !isLoadingMore) ||
                      state is HomeBroadcastLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _isClassCompleted(ClassDataDto cls) {
    final now = DateTime.now();
    final endTimeStr = cls.endTime ?? "";

    try {
      final format = DateFormat("h:mm a");
      final endParsed = format.parse(endTimeStr);

      if (cls.sessions != null && cls.sessions!.isNotEmpty) {
        // Check if all sessions returned in this class are completed
        bool allCompleted = true;
        bool hasPastSession = false;

        for (var session in cls.sessions!) {
          if (session.date != null) {
            final parsedDate = DateTime.parse(session.date!);
            final sessionEndTime = DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              endParsed.hour,
              endParsed.minute,
            );

            if (now.isAfter(sessionEndTime)) {
              hasPastSession = true;
            } else {
              allCompleted = false;
            }
          }
        }

        // If there's at least one past session and no future sessions in the list
        // Or if we just want to show it in completed if ANY session is completed,
        // returning hasPastSession is safer if the API filters to a specific week/day.
        // Let's use hasPastSession && allCompleted to be strict, or just allCompleted.
        return allCompleted && hasPastSession;
      }

      // Fallback if no sessions array is provided
      final dayOfWeek = cls.dayOfWeek ?? "";
      final endTime = DateTime(
        now.year,
        now.month,
        now.day,
        endParsed.hour,
        endParsed.minute,
      );
      final todayStr = DateFormat('EEEE').format(now).toUpperCase();

      if (dayOfWeek == todayStr && now.isAfter(endTime)) {
        return true;
      }

      List<String> days = [
        'MONDAY',
        'TUESDAY',
        'WEDNESDAY',
        'THURSDAY',
        'FRIDAY',
        'SATURDAY',
        'SUNDAY',
      ];
      int todayIdx = days.indexOf(todayStr);
      int classDayIdx = days.indexOf(dayOfWeek);
      if (classDayIdx != -1 && classDayIdx < todayIdx) {
        return true;
      }
    } catch (e) {}
    return false;
  }

  Widget _buildContent(
    BuildContext context,
    List<ClassDataDto> classes,
    bool isLoadingMore,
  ) {
    final now = DateTime.now();
    final todayStr = DateFormat('EEEE').format(now).toUpperCase();

    List<ClassDataDto> filteredClasses = classes;
    if (_selectedTab == 'Today') {
      filteredClasses = classes
          .where((cls) => cls.dayOfWeek == todayStr)
          .toList();
    } else if (_selectedTab == 'This week') {
      filteredClasses = classes
          .where((cls) => !_isClassCompleted(cls))
          .toList();
    } else if (_selectedTab == 'Completed') {
      filteredClasses = classes.where((cls) => _isClassCompleted(cls)).toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildHeader(classes.length)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchBar(context),
          const SizedBox(height: 24),
          _buildTabs(context),
          const SizedBox(height: 24),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  context.read<HomeCubit>().loadMoreClasses();
                }
                return false;
              },
              child: ListView.separated(
                itemCount: filteredClasses.length + (isLoadingMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index == filteredClasses.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return _buildClassCard(context, filteredClasses[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int totalClasses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$totalClasses allocated to you',
              style: const TextStyle(
                color: BrandColors.textMuted,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Assigned classes',
              style: TextStyle(
                color: BrandColors.text,
                fontSize: AppTypography.heading,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none, color: BrandColors.text),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search classes',
                hintStyle: const TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.body,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: BrandColors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 48,
          width: 48,
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
          child: IconButton(
            icon: const Icon(
              Icons.filter_alt_outlined,
              color: BrandColors.navy,
            ),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    final now = DateTime.now();
    final todayDate = DateFormat('yyyy-MM-dd').format(now);
    final todayWeekday = DateFormat('EEEE').format(now).toUpperCase();

    // Assuming Monday is the first day of the week
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));
    final startDateStr = DateFormat('yyyy-MM-dd').format(startOfWeek);
    final endDateStr = DateFormat('yyyy-MM-dd').format(endOfWeek);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Filters',
                style: TextStyle(
                  fontSize: AppTypography.title,
                  fontWeight: FontWeight.bold,
                  color: BrandColors.navy,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Day by date ($todayDate)'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  homeCubit.fetchClasses(filterType: 'day', date: todayDate);
                },
              ),
              ListTile(
                title: Text('Day by weekday ($todayWeekday)'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  homeCubit.fetchClasses(
                    filterType: 'day',
                    dayOfWeek: todayWeekday,
                  );
                },
              ),
              ListTile(
                title: Text('Week ($todayDate)'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  homeCubit.fetchClasses(
                    filterType: 'week',
                    weekDate: todayDate,
                  );
                },
              ),
              ListTile(
                title: Text('Custom week ($startDateStr to $endDateStr)'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  homeCubit.fetchClasses(
                    filterType: 'week',
                    startDate: startDateStr,
                    endDate: endDateStr,
                  );
                },
              ),
              ListTile(
                title: Text('Week + day ($todayDate, $todayWeekday)'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  homeCubit.fetchClasses(
                    filterType: 'week',
                    weekDate: todayDate,
                    dayOfWeek: todayWeekday,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(BuildContext context) {
    final tabs = ['Today', 'This week', 'Completed'];
    return Row(
      children: tabs.map((tab) {
        final isSelected = _selectedTab == tab;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: GestureDetector(
            onTap: () {
              if (_selectedTab != tab) {
                setState(() {
                  _selectedTab = tab;
                });
                final homeCubit = context.read<HomeCubit>();
                final now = DateTime.now();
                final todayDate = DateFormat('yyyy-MM-dd').format(now);

                if (tab == 'Today') {
                  homeCubit.fetchClasses(filterType: 'day', date: todayDate);
                } else if (tab == 'This week') {
                  final startOfWeek = now.subtract(
                    Duration(days: now.weekday - 1),
                  );
                  final endOfWeek = now.add(Duration(days: 7 - now.weekday));
                  homeCubit.fetchClasses(
                    filterType: 'week',
                    startDate: DateFormat('yyyy-MM-dd').format(startOfWeek),
                    endDate: DateFormat('yyyy-MM-dd').format(endOfWeek),
                  );
                } else if (tab == 'Completed') {
                  final startOfWeek = now.subtract(
                    Duration(days: now.weekday - 1),
                  );
                  final yesterday = now.subtract(const Duration(days: 1));
                  homeCubit.fetchClasses(
                    filterType: 'week',
                    startDate: DateFormat('yyyy-MM-dd').format(startOfWeek),
                    endDate: DateFormat('yyyy-MM-dd').format(yesterday),
                  );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? BrandColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isSelected ? Colors.white : BrandColors.text,
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassDataDto cls) {
    final now = DateTime.now();
    final timeStr = cls.startTime ?? "";
    final endTimeStr = cls.endTime ?? "";
    final dayOfWeek = cls.dayOfWeek ?? "";

    bool isLive = false;
    bool isCompleted = false;

    try {
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

      final todayStr = DateFormat('EEEE').format(now).toUpperCase();
      if (dayOfWeek == todayStr) {
        if (now.isAfter(startTime) && now.isBefore(endTime)) {
          isLive = true;
        } else if (now.isAfter(endTime)) {
          isCompleted = true;
        }
      }
    } catch (e) {
      // ignore
    }

    String badgeText = '';
    Color badgeColor = Colors.transparent;
    Color badgeBgColor = Colors.transparent;

    if (isLive) {
      badgeText = 'LIVE TODAY';
      badgeColor = BrandColors.successText;
      badgeBgColor = BrandColors.successSoft;
    } else if (dayOfWeek == DateFormat('EEEE').format(now).toUpperCase() &&
        !isCompleted) {
      badgeText = 'UPCOMING';
      badgeColor = BrandColors.navy;
      badgeBgColor = BrandColors.surfaceMuted;
    } else {
      badgeText = dayOfWeek.toUpperCase();
      badgeColor = BrandColors.navy;
      badgeBgColor = BrandColors.surfaceMuted;
    }

    final String timeRangeFormatted = _formatTimeRange(timeStr, endTimeStr);
    final DateTime targetDate = _getTargetDate(cls);
    final String targetDateStr = DateFormat('yyyy-MM-dd').format(targetDate);
    final String subtitleFormatted = _formatSubtitle(cls, targetDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassDetailsScreen(
              classData: cls,
              targetDateStr: targetDateStr,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: AppTypography.caption,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (cls.chatRoomId != null && cls.chatRoomId!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            conversationId: cls.chatRoomId!,
                            name: cls.className ?? "Class Chat",
                            isGroup: true,
                          ),
                        ),
                      );
                    } else if (cls.classId != null) {
                      _showBroadcastBottomSheet(
                        context,
                        cls.classId!,
                        cls.chatRoomId ?? "",
                        cls.className ?? "Class Chat",
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.more_horiz,
                      color: BrandColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              cls.className ?? "Unknown Class",
              style: const TextStyle(
                color: BrandColors.navy,
                fontSize: AppTypography.title,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitleFormatted,
              style: const TextStyle(
                color: BrandColors.textMuted,
                fontSize: AppTypography.body,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: BrandColors.textMuted.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(timeRangeFormatted),
                _buildInfoItem('Age ${cls.program?.ageGroup ?? "N/A"}'),
                if (isLive || isCompleted)
                  _buildInfoItem('${cls.totalPlayers ?? 0} players')
                else
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoItem('${cls.totalPlayers ?? 0} players'),
                        const Text(
                          'View class',
                          style: TextStyle(
                            color: BrandColors.primary,
                            fontSize: AppTypography.caption,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: BrandColors.text,
        fontSize: AppTypography.caption,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _formatTimeRange(String start, String end) {
    try {
      final format = DateFormat("h:mm a");
      final startParsed = format.parse(start);
      final endParsed = format.parse(end);
      return '${DateFormat("HH:mm").format(startParsed)}-${DateFormat("HH:mm").format(endParsed)}';
    } catch (e) {
      return '$start-$end';
    }
  }

  DateTime _getTargetDate(ClassDataDto cls) {
    final now = DateTime.now();
    if (_selectedTab == 'Today') {
      return now;
    } else if ((_selectedTab == 'This week' || _selectedTab == 'Completed') &&
        cls.dayOfWeek != null) {
      final days = [
        'MONDAY',
        'TUESDAY',
        'WEDNESDAY',
        'THURSDAY',
        'FRIDAY',
        'SATURDAY',
        'SUNDAY',
      ];
      final targetIndex = days.indexOf(cls.dayOfWeek!.toUpperCase());
      if (targetIndex != -1) {
        final currentWeekday = now.weekday - 1;
        final diff = targetIndex - currentWeekday;
        return now.add(Duration(days: diff));
      }
    }
    return now;
  }

  String _formatSubtitle(ClassDataDto cls, DateTime targetDate) {
    final location = cls.location ?? "Others";

    String sessionDateStr =
        ' • ${DateFormat("MMM d, yyyy").format(targetDate)}';

    if (_selectedTab == 'Today') {
      return '$location$sessionDateStr';
    } else {
      final day = cls.dayOfWeek != null
          ? '${cls.dayOfWeek![0]}${cls.dayOfWeek!.substring(1).toLowerCase()}'
          : '';
      String time = cls.startTime ?? "";
      try {
        final startParsed = DateFormat("h:mm a").parse(time);
        time = DateFormat("HH:mm").format(startParsed);
      } catch (e) {}

      return '$location • $day $time$sessionDateStr';
    }
  }

  void _showBroadcastBottomSheet(
    BuildContext context,
    String classId,
    String chatRoomId,
    String chatName,
  ) {
    String message = '';
    final homeCubit = context.read<HomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Broadcast Message',
                      style: TextStyle(
                        fontSize: AppTypography.section,
                        fontWeight: FontWeight.bold,
                        color: BrandColors.navy,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(bottomSheetContext),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: BrandColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: BrandColors.textMuted,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  maxLines: 4,
                  onChanged: (val) => message = val,
                  decoration: InputDecoration(
                    hintText: 'Enter your message to broadcast...',
                    hintStyle: const TextStyle(color: BrandColors.textMuted),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: BrandColors.divider),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: BrandColors.navy),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (message.trim().isEmpty) {
                        return;
                      }
                      homeCubit.broadcastMessage(
                        classId,
                        chatRoomId,
                        message.trim(),
                        chatName,
                      );
                      Navigator.pop(bottomSheetContext);
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      'Send Broadcast',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppTypography.bodyLarge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
