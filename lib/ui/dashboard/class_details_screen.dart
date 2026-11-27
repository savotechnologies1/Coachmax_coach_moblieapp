import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/dto/classes_response_dto.dart';
import 'package:coachmax_coach/ui/dashboard/player_profile_screen.dart';
import 'package:coachmax_coach/bloc/class_details/class_details_cubit.dart';
import 'package:coachmax_coach/bloc/class_details/class_details_state.dart';
import 'package:intl/intl.dart';

class ClassDetailsScreen extends StatelessWidget {
  final ClassDataDto classData;
  final String? targetDateStr;

  const ClassDetailsScreen({
    Key? key,
    required this.classData,
    this.targetDateStr,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ClassDetailsCubit()..fetchClassDetails(classData.classId!),
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: SafeArea(
          child: BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
            builder: (context, state) {
              final displayData = (state is ClassDetailsLoaded)
                  ? state.classDetails
                  : classData;
              final isLoading = state is ClassDetailsLoading;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, displayData),
                    const SizedBox(height: 24),
                    _buildClassInfoCard(displayData),
                    const SizedBox(height: 32),
                    _buildPlayerListHeader(context, displayData),
                    const SizedBox(height: 16),
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildPlayerList(context, displayData),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ClassDataDto data) {
    final dayStr = data.dayOfWeek ?? "";
    final timeStr = data.startTime ?? "";
    final endTimeStr = data.endTime ?? "";
    final timeRange = _formatTimeRange(timeStr, endTimeStr);

    String topText = '$dayStr • $timeRange'.toUpperCase();
    final now = DateTime.now();
    final todayStr = DateFormat('EEEE').format(now).toUpperCase();
    if (dayStr.toUpperCase() == todayStr) {
      topText = 'TODAY • $timeRange';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
            icon: const Icon(Icons.arrow_back, color: BrandColors.text),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topText,
                style: const TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.caption,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.className ?? "Unknown Class",
                style: const TextStyle(
                  color: BrandColors.text,
                  fontSize: AppTypography.heading,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassInfoCard(ClassDataDto data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: BrandColors.navy,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RIVERSIDE TRAINING HALL', // Hardcoded mock as requested by screenshot
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: AppTypography.caption,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Court 2 • Week 6',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.title,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Strength & agility progression',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: AppTypography.body,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn(
                    '${data.players?.length ?? 0}/${data.capacity ?? 0}',
                    'Players',
                  ),
                  _buildStatColumn('2', 'Trials'),
                  _buildStatColumn('Alex', 'Coach'),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
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
            color: Colors.white.withOpacity(0.5),
            fontSize: AppTypography.caption,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerListHeader(BuildContext context, ClassDataDto data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'PLAYER LIST',
          style: TextStyle(
            color: BrandColors.textMuted,
            fontSize: AppTypography.caption,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          children: [
            _buildLegendItem(Icons.check_circle, BrandColors.successText, 'P'),
            const SizedBox(width: 12),
            _buildLegendItem(
              Icons.access_time_filled,
              BrandColors.warning,
              'L',
            ),
            const SizedBox(width: 12),
            _buildLegendItem(Icons.cancel, BrandColors.error, 'A'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: BrandColors.textMuted,
            fontSize: AppTypography.caption,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerList(BuildContext context, ClassDataDto data) {
    final players = data.players ?? [];
    if (players.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "No players found for this class.",
          style: TextStyle(color: BrandColors.textMuted),
        ),
      );
    }

    final playerWidgets = players.asMap().entries.map((entry) {
      final index = entry.key;
      final playerDto = entry.value;

      String status = 'none';
      if (targetDateStr != null && playerDto.attendance != null) {
        final records = playerDto.attendance!['records'];
        if (records != null && records is List) {
          for (var record in records) {
            if (record['sessionDate'] != null &&
                record['sessionDate'].startsWith(targetDateStr!)) {
              status = record['status'] ?? 'none';
              break;
            }
          }
        }
      }

      final playerMap = {
        'id': playerDto.id,
        'index': index + 1,
        'name': playerDto.fullName ?? 'Unknown',
        'status': status,
        'medical': playerDto.isMedicalCondition == true,
        'medicalDetails': playerDto.medicalConditionDetails ?? 'N/A',
      };

      return _buildPlayerRow(context, playerMap, data.classId, targetDateStr);
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMarkAllHeader(context, data),
          const Divider(height: 1, color: BrandColors.background),
          ...playerWidgets,
        ],
      ),
    );
  }

  Widget _buildMarkAllHeader(BuildContext context, ClassDataDto data) {
    String dateStr = 'Today';
    if (targetDateStr != null) {
      try {
        final parsedDate = DateTime.parse(targetDateStr!);
        dateStr = DateFormat('dd MMM, yyyy').format(parsedDate);
      } catch (_) {}
    } else {
      dateStr = '${DateFormat('dd MMM').format(DateTime.now())} • Today';
    }

    final playersCount = data.players?.length ?? 0;

    bool allPresent = false;
    if (data.players != null && data.players!.isNotEmpty) {
      allPresent = true;
      for (var playerDto in data.players!) {
        String status = 'none';
        if (targetDateStr != null && playerDto.attendance != null) {
          final records = playerDto.attendance!['records'];
          if (records != null && records is List) {
            for (var record in records) {
              if (record['sessionDate'] != null &&
                  record['sessionDate'].startsWith(targetDateStr!)) {
                status = record['status'] ?? 'none';
                break;
              }
            }
          }
        }
        if (status != 'PRESENT') {
          allPresent = false;
          break;
        }
      }
    }

    return GestureDetector(
      onTap: () {
        final classId = data.classId;
        if (classId != null &&
            data.players != null &&
            data.players!.isNotEmpty) {
          final playerIds = data.players!.map((p) => p.id!).toList();
          context.read<ClassDetailsCubit>().markAllAttendance(
            classId,
            playerIds,
            sessionDate: targetDateStr,
          );
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: allPresent
                    ? BrandColors.successText
                    : Colors.transparent,
                border: Border.all(
                  color: allPresent
                      ? BrandColors.successText
                      : BrandColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: allPresent
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mark All Present',
                    style: TextStyle(
                      color: BrandColors.navy,
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: const TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.body,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: BrandColors.background),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$playersCount Players',
                style: const TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.caption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(
    BuildContext context,
    Map<String, dynamic> player,
    String? classId,
    String? sessionDate,
  ) {
    final status = player['status'];
    Widget statusIcon;

    if (status == 'PRESENT') {
      statusIcon = const Icon(
        Icons.check_circle,
        color: BrandColors.successText,
        size: 24,
      );
    } else if (status == 'LATE') {
      statusIcon = const Icon(
        Icons.access_time_filled,
        color: BrandColors.warning,
        size: 24,
      );
    } else if (status == 'ABSENT') {
      statusIcon = const Icon(Icons.cancel, color: BrandColors.error, size: 24);
    } else {
      statusIcon = Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: BrandColors.divider, width: 2),
        ),
      );
    }

    final isMedical = player['medical'] == true;
    final medicalText = isMedical ? player['medicalDetails'] : 'N/A';
    final medicalColor = isMedical ? BrandColors.error : BrandColors.textMuted;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerProfileScreen(
              playerId: player['id'] as String? ?? '',
              classId: classId,
              status: player['status'],
            ),
          ),
        );
      },
      onLongPress: () {
        if (classId != null) {
          _showAddNoteBottomSheet(context, classId, player);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: BrandColors.background)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '${player['index']}',
                style: const TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.body,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Text(
                player['name'],
                style: const TextStyle(
                  color: BrandColors.navy,
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isMedical) ...[
                    const Icon(
                      Icons.arrow_drop_up,
                      color: BrandColors.error,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Flexible(
                    child: Text(
                      medicalText,
                      style: TextStyle(
                        color: medicalColor,
                        fontSize: AppTypography.caption,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (classId != null) {
                  _showAttendanceDialog(
                    context,
                    classId,
                    player['id'] as String,
                    sessionDate,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: statusIcon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceDialog(
    BuildContext context,
    String classId,
    String playerId,
    String? sessionDate,
  ) {
    String comment = '';
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Mark Attendance'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Comment (Optional)',
                ),
                onChanged: (val) => comment = val,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.successText,
                    ),
                    onPressed: () {
                      context.read<ClassDetailsCubit>().markSingleAttendance(
                        classId,
                        playerId,
                        'PRESENT',
                        comment: comment,
                        sessionDate: sessionDate,
                      );
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('PRESENT'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandColors.warning,
                    ),
                    onPressed: () {
                      context.read<ClassDetailsCubit>().markSingleAttendance(
                        classId,
                        playerId,
                        'LATE',
                        comment: comment,
                        sessionDate: sessionDate,
                      );
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('LATE'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BrandColors.error,
                ),
                onPressed: () {
                  context.read<ClassDetailsCubit>().markSingleAttendance(
                    classId,
                    playerId,
                    'ABSENT',
                    comment: comment,
                    sessionDate: sessionDate,
                  );
                  Navigator.pop(dialogContext);
                },
                child: const Text('ABSENT'),
              ),
            ],
          ),
        );
      },
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

  void _showAddNoteBottomSheet(
    BuildContext context,
    String classId,
    Map<String, dynamic> player,
  ) {
    String noteDescription = '';
    String selectedReason = 'POSITIVE_PERFORMANCE';
    bool isPersonal = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add Note',
                          style: TextStyle(
                            color: BrandColors.navy,
                            fontSize: AppTypography.section,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: BrandColors.background,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BrandColors.background,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${player['index']}',
                              style: const TextStyle(
                                color: BrandColors.navy,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  player['name'],
                                  style: const TextStyle(
                                    color: BrandColors.navy,
                                    fontSize: AppTypography.bodyLarge,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Player',
                                  style: TextStyle(
                                    color: BrandColors.textMuted,
                                    fontSize: AppTypography.caption,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (player['status'] == 'PRESENT')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: BrandColors.successSoft,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'MARKED PRESENT',
                                style: TextStyle(
                                  color: BrandColors.successText,
                                  fontSize: AppTypography.caption,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: BrandColors.divider),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedReason,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: BrandColors.navy,
                          ),
                          style: const TextStyle(
                            color: BrandColors.textMuted,
                            fontSize: AppTypography.body,
                          ),
                          items:
                              [
                                'POSITIVE_PERFORMANCE',
                                'INJURY',
                                'LATENESS',
                                'OTHER',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              setState(() {
                                selectedReason = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'OBSERVATION NOTE',
                      style: TextStyle(
                        color: BrandColors.textMuted,
                        fontSize: AppTypography.caption,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      onChanged: (val) => noteDescription = val,
                      decoration: InputDecoration(
                        hintText:
                            'Enter attendance note (e.g., reason for lateness, injury update, performance feedback)...',
                        hintStyle: const TextStyle(
                          color: BrandColors.textMuted,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: BrandColors.divider,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: BrandColors.divider,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: BrandColors.navy),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text(
                        'Personal Note',
                        style: TextStyle(
                          color: BrandColors.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text(
                        'Only visible to you',
                        style: TextStyle(
                          color: BrandColors.textMuted,
                          fontSize: AppTypography.caption,
                        ),
                      ),
                      value: isPersonal,
                      activeColor: BrandColors.primary,
                      onChanged: (bool value) {
                        setState(() {
                          isPersonal = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
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
                        ),
                        onPressed: () {
                          context.read<ClassDetailsCubit>().addNote(
                            classId,
                            player['id'] as String,
                            selectedReason,
                            noteDescription,
                            isPersonal: isPersonal,
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Save Note',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTypography.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: BrandColors.textMuted,
                            fontSize: AppTypography.bodyLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
