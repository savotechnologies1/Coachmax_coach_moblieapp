import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/dto/notes_response_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/player_profile/player_profile_cubit.dart';
import 'package:coachmax_coach/bloc/player_profile/player_profile_state.dart';
import 'package:coachmax_coach/dto/player_profile_response_dto.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/utility.dart';
import 'package:coachmax_coach/ui/dashboard/chat_detail_screen.dart';

class PlayerProfileScreen extends StatelessWidget {
  final String playerId;
  final String? classId;
  final String? status;

  const PlayerProfileScreen({
    Key? key,
    required this.playerId,
    this.classId,
    this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlayerProfileCubit()..fetchPlayerProfile(playerId),
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: SafeArea(
          child: BlocConsumer<PlayerProfileCubit, PlayerProfileState>(
            buildWhen: (previous, current) {
              return current is PlayerProfileLoading ||
                  current is PlayerProfileError ||
                  current is PlayerProfileLoaded;
            },
            listener: (context, state) {
              if (state is PlayerProfileDirectMessageSuccess) {
                // Navigate to chat detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      conversationId: state.chatRoomId,
                      name:
                          'Direct Message', // Could pass parent name if stored
                      isGroup: false,
                    ),
                  ),
                );
              } else if (state is PlayerProfileDirectMessageError) {
                Utility().showFlushBar(
                  context: context,
                  message: 'Error: ${state.message}',
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              if (state is PlayerProfileInitial ||
                  state is PlayerProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PlayerProfileError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: BrandColors.error),
                  ),
                );
              } else if (state is PlayerProfileLoaded) {
                final data = state.data;
                final player = data.player;
                if (player == null) return const SizedBox.shrink();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (player.isMedicalCondition == true)
                        _buildMedicalAlert(player),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeaderCard(context, data),
                            const SizedBox(height: 24),
                            const Text(
                              'Safety & care',
                              style: TextStyle(
                                fontSize: AppTypography.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: BrandColors.navy,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildSafetyCard(data.parent),
                            const SizedBox(height: 24),
                            const Text(
                              'Programs & sessions',
                              style: TextStyle(
                                fontSize: AppTypography.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: BrandColors.navy,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildProgramsCard(player),
                            const SizedBox(height: 24),
                            const Text(
                              'Attendance',
                              style: TextStyle(
                                fontSize: AppTypography.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: BrandColors.navy,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAttendanceCard(data.perDayAttendance),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: BrandColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      _showAddNoteBottomSheet(context, player);
                                    },
                                    child: const Text(
                                      'Coach notes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                        color: BrandColors.border,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                    ),
                                    onPressed: () {
                                      final parentId = data.parent?.id;
                                      final parentName =
                                          data.parent?.fullName ?? 'Parent';
                                      if (parentId != null) {
                                        context
                                            .read<PlayerProfileCubit>()
                                            .sendDirectMessage(parentId, '');
                                      } else {
                                        Utility().showFlushBar(
                                          context: context,
                                          message:
                                              'No parent found for this player',
                                          isError: true,
                                        );
                                      }
                                    },
                                    child: const Text(
                                      'Message parent',
                                      style: TextStyle(
                                        color: BrandColors.navy,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _buildNotesTimeline(
                              context,
                              state.data.player!,
                              state.notes,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalAlert(PlayerDetailDto player) {
    return Container(
      width: double.infinity,
      color: BrandColors.error,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEDICAL ALERT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppTypography.caption,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  player.medicalConditionDetails ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: AppTypography.caption,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, PlayerDetailDataDto data) {
    final player = data.player!;
    final overall = data.overallAttendance;
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BrandColors.textMuted.withOpacity(0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: BrandColors.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Player profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppTypography.body,
                    ),
                  ),
                ],
              ),
              if (status != null && status != 'none')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: status == 'PRESENT'
                        ? BrandColors.successSoft
                        : (status == 'LATE'
                              ? BrandColors.warningSoft
                              : BrandColors.errorSoft),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        status == 'PRESENT'
                            ? Icons.check_circle
                            : (status == 'LATE'
                                  ? Icons.access_time_filled
                                  : Icons.cancel),
                        color: status == 'PRESENT'
                            ? BrandColors.successText
                            : (status == 'LATE'
                                  ? BrandColors.warning
                                  : BrandColors.error),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status == 'PRESENT'
                            ? 'Present'
                            : (status == 'LATE' ? 'Late' : 'Absent'),
                        style: TextStyle(
                          color: status == 'PRESENT'
                              ? BrandColors.successText
                              : (status == 'LATE'
                                    ? BrandColors.warning
                                    : BrandColors.error),
                          fontSize: AppTypography.caption,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: status == 'PRESENT'
                            ? BrandColors.successText
                            : (status == 'LATE'
                                  ? BrandColors.warning
                                  : BrandColors.error),
                        size: 16,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: player.profileImage != null
                    ? NetworkImage(Constants.baseurlImg + player.profileImage!)
                    : null,
                backgroundColor: BrandColors.surfaceMuted,
                child: player.profileImage == null
                    ? const Icon(
                        Icons.person,
                        color: BrandColors.textMuted,
                        size: 36,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.fullName ?? 'Player',
                    style: const TextStyle(
                      fontSize: AppTypography.heading,
                      fontWeight: FontWeight.w800,
                      color: BrandColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${player.programs?.isNotEmpty == true ? player.programs![0].name : 'Program'} • #${player.jerseyNumber ?? 'N/A'}',
                    style: const TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: BrandColors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      player.isBlocked == true ? 'BLOCKED' : 'ACTIVE PLAYER',
                      style: const TextStyle(
                        color: BrandColors.navy,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildInfoBox(
                  'DOB',
                  player.dob != null
                      ? DateFormat(
                          'dd MMM yyyy',
                        ).format(DateTime.parse(player.dob!))
                      : 'N/A',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  'AGE',
                  player.dob != null
                      ? '${DateTime.now().year - DateTime.parse(player.dob!).year} years'
                      : 'N/A',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoBox(
                  'ATTEND.',
                  '${overall?.percentage?.toStringAsFixed(0) ?? 0}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: BrandColors.textMuted.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: BrandColors.textMuted,
              fontSize: AppTypography.caption,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: BrandColors.text,
              fontSize: AppTypography.caption,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyCard(ParentDetailDto? parent) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guardian & emergency contact',
                    style: TextStyle(
                      color: BrandColors.text,
                      fontWeight: FontWeight.bold,
                      fontSize: AppTypography.body,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${parent?.fullName ?? 'Parent'} - ${parent?.phone ?? parent?.emergencyContact ?? ''}',
                    style: TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.phone_outlined, color: BrandColors.primary),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          const Text(
            'Allergies: Peanuts, cashews',
            style: TextStyle(
              color: BrandColors.error,
              fontWeight: FontWeight.bold,
              fontSize: AppTypography.body,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Medical information is parent-provided and read-only.',
            style: TextStyle(
              color: BrandColors.textMuted,
              fontSize: AppTypography.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsCard(PlayerDetailDto player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.programs?.isNotEmpty == true
                    ? player.programs![0].name ?? ''
                    : '',
                style: const TextStyle(
                  color: BrandColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: AppTypography.body,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                player.assignedClasses?.isNotEmpty == true
                    ? player.assignedClasses![0].className ?? ''
                    : '',
                style: TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.caption,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: BrandColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(List<AttendanceRecordDto>? attendance) {
    return AttendanceCalendarCard(attendance: attendance);
  }

  Widget _buildNotesTimeline(
    BuildContext context,
    PlayerDetailDto player,
    List<NoteDto>? notes,
  ) {
    int selectedTabIndex = 0;
    return StatefulBuilder(
      builder: (context, setState) {
        final publicNotes =
            notes?.where((n) => n.isPersonal != true).toList() ?? [];
        final personalNotes =
            notes?.where((n) => n.isPersonal == true).toList() ?? [];
        final currentNotes = selectedTabIndex == 0
            ? publicNotes
            : personalNotes;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: BrandColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 0
                              ? BrandColors.navy
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Public Notes',
                          style: TextStyle(
                            color: selectedTabIndex == 0
                                ? Colors.white
                                : BrandColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selectedTabIndex == 1
                              ? BrandColors.navy
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Personal Notes',
                          style: TextStyle(
                            color: selectedTabIndex == 1
                                ? Colors.white
                                : BrandColors.textMuted,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12, right: 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 2,
                            color: BrandColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        if (currentNotes.isNotEmpty)
                          ...currentNotes.map((note) => _buildSingleNote(note)),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            _showAddNoteBottomSheet(context, player);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.add_circle_outline,
                                color: BrandColors.error,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add New Notes',
                                style: TextStyle(
                                  color: BrandColors.error,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  decorationColor: BrandColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSingleNote(NoteDto note) {
    String formattedDate = '';
    if (note.createdAt != null) {
      try {
        final date = DateTime.parse(note.createdAt!).toLocal();
        final now = DateTime.now();
        if (date.year == now.year &&
            date.month == now.month &&
            date.day == now.day) {
          formattedDate = 'Today, ${DateFormat('HH:mm').format(date)}';
        } else {
          formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(date);
        }
      } catch (e) {
        formattedDate = note.createdAt!;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -29,
            top: 16,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: BrandColors.primary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: BrandColors.primarySoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (note.noteType ?? 'NOTE')
                            .replaceAll('_', ' ')
                            .toUpperCase(),
                        style: const TextStyle(
                          color: BrandColors.navy,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (note.isEdited == true)
                      const Icon(
                        Icons.edit,
                        color: BrandColors.textMuted,
                        size: 14,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  note.description ?? '',
                  style: const TextStyle(
                    color: BrandColors.text,
                    fontSize: AppTypography.body,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${note.coach?.name ?? 'Coach'} • $formattedDate',
                      style: const TextStyle(
                        color: BrandColors.textMuted,
                        fontSize: AppTypography.caption,
                      ),
                    ),
                    const Text(
                      'Audit logged',
                      style: TextStyle(
                        color: BrandColors.textMuted,
                        fontSize: AppTypography.caption,
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

  void _showAddNoteBottomSheet(BuildContext context, PlayerDetailDto player) {
    String noteDescription = '';
    String selectedReason = 'POSITIVE_PERFORMANCE';
    bool isPersonal = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<PlayerProfileCubit>(),
          child: StatefulBuilder(
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
                  child: SingleChildScrollView(
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
                              if (player.profileImage != null)
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    player.profileImage!,
                                  ),
                                )
                              else
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
                                  child: const Icon(
                                    Icons.person,
                                    color: BrandColors.navy,
                                  ),
                                ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      player.fullName ?? 'Unknown Player',
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
                              borderSide: const BorderSide(
                                color: BrandColors.navy,
                              ),
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
                              context.read<PlayerProfileCubit>().addNote(
                                classId ?? "",
                                player.id ?? "",
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showMessageParentBottomSheet(
    BuildContext context,
    String parentId,
    String parentName,
  ) {
    String messageText = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<PlayerProfileCubit>(),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          Text(
                            'Message $parentName',
                            style: const TextStyle(
                              fontSize: AppTypography.section,
                              fontWeight: FontWeight.bold,
                              color: BrandColors.navy,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        maxLines: 4,
                        onChanged: (val) {
                          setState(() {
                            messageText = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: BrandColors.border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: BrandColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: BrandColors.navy,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child:
                            BlocBuilder<PlayerProfileCubit, PlayerProfileState>(
                              builder: (context, state) {
                                final isLoading = state is PlayerProfileLoading;
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: BrandColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed:
                                      (isLoading || messageText.trim().isEmpty)
                                      ? null
                                      : () {
                                          context
                                              .read<PlayerProfileCubit>()
                                              .sendDirectMessage(
                                                parentId,
                                                messageText.trim(),
                                              );
                                        },
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Send Message',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppTypography.bodyLarge,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                );
                              },
                            ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class AttendanceCalendarCard extends StatefulWidget {
  final List<AttendanceRecordDto>? attendance;

  const AttendanceCalendarCard({Key? key, this.attendance}) : super(key: key);

  @override
  _AttendanceCalendarCardState createState() => _AttendanceCalendarCardState();
}

class _AttendanceCalendarCardState extends State<AttendanceCalendarCard> {
  late DateTime _currentMonth;
  final Map<String, Color> _attendanceMap = {};

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _generateAttendance();
  }

  @override
  void didUpdateWidget(covariant AttendanceCalendarCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.attendance != oldWidget.attendance) {
      _generateAttendance();
    }
  }

  void _generateAttendance() {
    _attendanceMap.clear();

    if (widget.attendance != null) {
      for (var record in widget.attendance!) {
        if (record.sessionDate != null && record.status != null) {
          final date = DateTime.parse(record.sessionDate!);
          if (date.year == _currentMonth.year &&
              date.month == _currentMonth.month) {
            if (record.status == 'PRESENT') {
              _attendanceMap[date.day.toString()] = BrandColors.successText;
            } else if (record.status == 'LATE') {
              _attendanceMap[date.day.toString()] = BrandColors.warning;
            } else if (record.status == 'ABSENT') {
              _attendanceMap[date.day.toString()] = BrandColors.error;
            }
          }
        }
      }
    }
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      _generateAttendance();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      _generateAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BrandColors.background,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: BrandColors.navy,
                  ),
                ),
              ),
              Column(
                children: [
                  const Text(
                    'ACADEMY PRO',
                    style: TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM yyyy').format(_currentMonth),
                    style: const TextStyle(
                      color: BrandColors.navy,
                      fontSize: AppTypography.bodyLarge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BrandColors.background,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: BrandColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendDot(BrandColors.successText, 'PRESENT'),
              const SizedBox(width: 12),
              _buildLegendDot(BrandColors.warning, 'LATE'),
              const SizedBox(width: 12),
              _buildLegendDot(BrandColors.error, 'ABSENT'),
              const SizedBox(width: 12),
              _buildLegendDot(BrandColors.border, 'NONE'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map(
                  (d) => Text(
                    d,
                    style: TextStyle(
                      color: BrandColors.textMuted,
                      fontSize: AppTypography.caption,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: BrandColors.textMuted,
            fontSize: AppTypography.caption,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    // get weekday of 1st day (1=Monday, ..., 7=Sunday)
    final firstWeekday = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    ).weekday;
    final now = DateTime.now();
    final isCurrentMonth =
        _currentMonth.year == now.year && _currentMonth.month == now.month;

    List<Widget> rows = [];
    int dayCounter = 1;

    // up to 6 rows in a month
    for (int i = 0; i < 6; i++) {
      List<Widget> rowChildren = [];
      bool emptyRow = true;
      for (int j = 1; j <= 7; j++) {
        if (i == 0 && j < firstWeekday) {
          // Empty slot before month starts
          rowChildren.add(const SizedBox(width: 26, height: 26));
        } else if (dayCounter <= daysInMonth) {
          emptyRow = false;
          final isToday = isCurrentMonth && dayCounter == now.day;
          final color =
              _attendanceMap[dayCounter.toString()] ?? Colors.transparent;
          final isTransparent = color == Colors.transparent;

          rowChildren.add(
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isToday ? Colors.white : color,
                shape: BoxShape.circle,
                border: isToday
                    ? Border.all(color: BrandColors.primary, width: 1.5)
                    : null,
              ),
              child: Center(
                child: Text(
                  dayCounter.toString(),
                  style: TextStyle(
                    color: isToday
                        ? BrandColors.primary
                        : (isTransparent ? BrandColors.border : Colors.white),
                    fontSize: AppTypography.caption,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        } else {
          // Empty slot after month ends
          rowChildren.add(const SizedBox(width: 26, height: 26));
        }
      }

      if (!emptyRow) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: rowChildren,
          ),
        );
        if (dayCounter <= daysInMonth) {
          rows.add(const SizedBox(height: 12));
        }
      } else {
        break; // stop adding rows if empty
      }
    }

    return Column(children: rows);
  }
}
