import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/notifications/notifications_cubit.dart';
import 'package:coachmax_coach/bloc/notifications/notifications_state.dart';
import 'package:coachmax_coach/dto/notification_dto.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/ui/dashboard/player_profile_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..fetchNotifications(),
      child: const NotificationsView(),
    );
  }
}

class NotificationsView extends StatefulWidget {
  const NotificationsView({Key? key}) : super(key: key);

  @override
  _NotificationsViewState createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilters(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: BrandColors.text,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notifications',
                style: TextStyle(
                  color: BrandColors.text,
                  fontSize: AppTypography.heading,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<NotificationsCubit>().markAllAsRead();
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                color: BrandColors.primary,
                fontSize: AppTypography.body,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ['All', 'Priority', 'Sessions'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? BrandColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : BrandColors.textMuted,
                  fontSize: AppTypography.caption,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is NotificationsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: BrandColors.error),
            ),
          );
        } else if (state is NotificationsLoaded) {
          List<NotificationDto> notifications = state.notifications;

          if (_selectedFilter == 'Priority') {
            notifications = notifications
                .where(
                  (n) =>
                      n.type?.toLowerCase() == 'priority' ||
                      n.type?.toLowerCase() == 'medical',
                )
                .toList();
          } else if (_selectedFilter == 'Sessions') {
            notifications = notifications
                .where(
                  (n) =>
                      n.type?.toLowerCase() == 'session' ||
                      n.type?.toLowerCase() == 'attendance',
                )
                .toList();
          }

          if (notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications found.',
                style: TextStyle(color: BrandColors.textMuted),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(notifications[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotificationCard(NotificationDto notification) {
    // Determine icon and colors based on type
    IconData iconData = Icons.notifications;
    Color iconColor = BrandColors.textMuted;
    Color bgColor = BrandColors.textMuted.withOpacity(0.2);

    final type = notification.type?.toLowerCase() ?? '';
    if (type.contains('medical') ||
        type.contains('alert') ||
        type.contains('priority')) {
      iconData = Icons.error_outline;
      iconColor = BrandColors.error;
      bgColor = BrandColors.error.withOpacity(0.1);
    } else if (type.contains('attendance') || type.contains('session')) {
      iconData = Icons.calendar_today;
      iconColor = BrandColors.navy;
      bgColor = BrandColors.primarySoft;
    } else if (type.contains('approved') || type.contains('temporary')) {
      iconData = Icons.check_circle_outline;
      iconColor = Colors.white;
      bgColor = BrandColors.primary;
    } else if (type.contains('reply') || type.contains('message')) {
      iconData = Icons.chat_bubble_outline;
      iconColor = BrandColors.navy;
      bgColor = BrandColors.divider;
    }

    String formattedDate = notification.createdAt ?? 'Just now';
    if (notification.createdAt != null) {
      try {
        final parsedDate = DateTime.parse(notification.createdAt!).toLocal();
        formattedDate = DateFormat('MMM d, yyyy h:mm a').format(parsedDate);
      } catch (e) {}
    }

    return GestureDetector(
      onTap: () {
        if (notification.type == 'ENROLLMENT_REQUEST' &&
            notification.data != null) {
          final playerId = notification.data!['playerId'];
          if (playerId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlayerProfileScreen(playerId: playerId),
              ),
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title ?? 'Notification',
                    style: const TextStyle(
                      color: BrandColors.text,
                      fontSize: AppTypography.body,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.description ?? '',
                    style: const TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
