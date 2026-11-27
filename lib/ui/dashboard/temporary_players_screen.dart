import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/temporary_players/temporary_players_list_cubit.dart';
import 'package:coachmax_coach/bloc/temporary_players/temporary_players_list_state.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:dio/dio.dart';

class TemporaryPlayersScreen extends StatefulWidget {
  const TemporaryPlayersScreen({Key? key}) : super(key: key);

  @override
  _TemporaryPlayersScreenState createState() => _TemporaryPlayersScreenState();
}

class _TemporaryPlayersScreenState extends State<TemporaryPlayersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final dio = Dio();
        dio.interceptors.add(LoggingInterceptor());
        return TemporaryPlayersListCubit(RestClient(dio))
          ..fetchTemporaryPlayers();
      },
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
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
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Temporary player',
                        style: TextStyle(
                          fontSize: AppTypography.heading,
                          fontWeight: FontWeight.bold,
                          color: BrandColors.text,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.filter_alt_outlined,
                        color: BrandColors.text,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: BrandColors.textMuted,
                        size: 20,
                      ),
                      hintText: 'Search players',
                      hintStyle: TextStyle(
                        color: BrandColors.textMuted,
                        fontSize: AppTypography.body,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // List
              Expanded(
                child:
                    BlocBuilder<
                      TemporaryPlayersListCubit,
                      TemporaryPlayersListState
                    >(
                      builder: (context, state) {
                        if (state is TemporaryPlayersListLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TemporaryPlayersListError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: BrandColors.error),
                            ),
                          );
                        } else if (state is TemporaryPlayersListLoaded) {
                          final filteredPlayers = state.players.where((item) {
                            final nameMatch =
                                item.player?.fullName?.toLowerCase().contains(
                                  _searchQuery,
                                ) ??
                                false;
                            return nameMatch;
                          }).toList();

                          if (filteredPlayers.isEmpty) {
                            return const Center(
                              child: Text("No temporary players found"),
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            itemCount: filteredPlayers.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = filteredPlayers[index];

                              // Calculate age
                              String ageText = "Unknown";
                              if (item.player?.dob != null) {
                                try {
                                  final dob = DateTime.parse(item.player!.dob!);
                                  final now = DateTime.now();
                                  int age = now.year - dob.year;
                                  if (now.month < dob.month ||
                                      (now.month == dob.month &&
                                          now.day < dob.day)) {
                                    age--;
                                  }
                                  ageText = "$age yrs";
                                } catch (_) {}
                              }

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          item.player?.profileImage != null &&
                                              item
                                                  .player!
                                                  .profileImage!
                                                  .isNotEmpty
                                          ? NetworkImage(
                                              item.player!.profileImage!,
                                            )
                                          : null,
                                      backgroundColor: BrandColors.border,
                                      child:
                                          item.player?.profileImage == null ||
                                              item.player!.profileImage!.isEmpty
                                          ? const Icon(
                                              Icons.person,
                                              color: BrandColors.textMuted,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.player?.fullName ?? "Unknown",
                                            style: const TextStyle(
                                              fontSize: AppTypography.bodyLarge,
                                              fontWeight: FontWeight.bold,
                                              color: BrandColors.text,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$ageText · Trial today',
                                            style: const TextStyle(
                                              fontSize: AppTypography.caption,
                                              color: BrandColors.textMuted,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: BrandColors
                                                  .warningSoft, // Light orange background
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              item.status ?? 'Pending',
                                              style: const TextStyle(
                                                color: BrandColors
                                                    .warning, // Orange text
                                                fontSize: AppTypography.caption,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: BrandColors.textMuted,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
              ),

              // Info Box
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: BrandColors.primary),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: BrandColors.navy,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Profiles are visible only for players in your assigned classes. Financial and enrolment data are protected.',
                          style: TextStyle(
                            fontSize: AppTypography.caption,
                            color: Colors.black.withOpacity(0.6),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
