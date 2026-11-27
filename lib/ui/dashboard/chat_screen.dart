import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/ui/dashboard/chat_detail_screen.dart';
import 'package:coachmax_coach/bloc/chat/chat_list_cubit.dart';
import 'package:coachmax_coach/bloc/api_resp_state.dart';
import 'package:coachmax_coach/dto/chat_dto.dart';
import 'package:coachmax_coach/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All chats', 'Class messages', 'Individual'];
  final TextEditingController _searchController = TextEditingController();
  late final ChatListCubit _chatListCubit;

  @override
  void initState() {
    super.initState();
    _chatListCubit = ChatListCubit()..fetchChats();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatListCubit.close();
    super.dispose();
  }

  void _fetchChatsWithFilters() {
    String? type;
    if (_selectedFilterIndex == 1) {
      type = 'BROADCAST';
    } else if (_selectedFilterIndex == 2) {
      type = 'DIRECT';
    }

    final search = _searchController.text.trim();

    _chatListCubit.fetchChats(
      type: type,
      search: search.isNotEmpty ? search : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatListCubit,
      child: Scaffold(
        backgroundColor: BrandColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        _fetchChatsWithFilters();
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
                            _buildHeader(),
                            const SizedBox(height: 24),
                            _buildSearchBar(),
                            const SizedBox(height: 16),
                            _buildFilters(),
                            const SizedBox(height: 24),
                            _buildChatList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ASSIGNED CLASS FAMILIES',
              style: TextStyle(
                color: BrandColors.textMuted,
                fontSize: AppTypography.caption,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Parent communication',
              style: TextStyle(
                color: BrandColors.text,
                fontSize: AppTypography.heading,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     shape: BoxShape.circle,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.05),
        //         blurRadius: 10,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        //   child: IconButton(
        //     icon: const Icon(Icons.edit_outlined, color: BrandColors.text),
        //     onPressed: () {},
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onSubmitted: (_) => _fetchChatsWithFilters(),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search chats',
        hintStyle: const TextStyle(
          color: BrandColors.textMuted,
          fontSize: AppTypography.body,
        ),
        prefixIcon: const Icon(Icons.search, color: BrandColors.textMuted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
              _fetchChatsWithFilters();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? BrandColors.navy : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : BrandColors.text,
                  fontSize: AppTypography.body,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChatList() {
    return BlocBuilder<ChatListCubit, ResponseState>(
      builder: (context, state) {
        if (state is ResponseStateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ResponseStateEmpty) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: BrandColors.textMuted),
            ),
          );
        } else if (state is ResponseStateError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: BrandColors.error),
            ),
          );
        } else if (state is ResponseStateSuccess<List<ChatConversationDto>>) {
          final chats = state.data;
          return Column(
            children: chats.map((chat) {
              final members = chat.members ?? [];
              final parentMember = members.firstWhere(
                (m) => m.refModel == 'Parent',
                orElse: () =>
                    members.isNotEmpty ? members.first : ChatRoomMemberDto(),
              );
              final memberUser = parentMember.user;

              final name = (chat.name != null && chat.name!.isNotEmpty)
                  ? chat.name!
                  : (memberUser?.fullName ??
                        memberUser?.name ??
                        'Unknown User');

              String? avatar;
              if (memberUser?.profileImage != null &&
                  memberUser!.profileImage!.isNotEmpty) {
                final imgPath = memberUser.profileImage!;
                avatar = imgPath.startsWith('http')
                    ? imgPath
                    : "${Constants.baseurl}$imgPath";
              }

              final isGroup = chat.type == 'BROADCAST';
              final msgText = chat.lastMessage?.text ?? '';
              final unread = chat.unreadCount ?? 0;
              final time = chat.lastMessage?.createdAt != null ? "Recent" : "";

              return Column(
                children: [
                  _buildChatItem(
                    conversationId: chat.id ?? '',
                    name: name,
                    message: msgText,
                    time: time,
                    unreadCount: unread,
                    avatarUrl: avatar,
                    isGroup: isGroup,
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChatItem({
    required String conversationId,
    required String name,
    required String message,
    required String time,
    int unreadCount = 0,
    String? avatarUrl,
    bool isGroup = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              conversationId: conversationId,
              name: name,
              avatarUrl: avatarUrl,
              isGroup: isGroup,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16),
                color: isGroup ? BrandColors.navy : BrandColors.surfaceMuted,
                image: (avatarUrl != null && !isGroup)
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isGroup
                  ? const Icon(Icons.people_alt, color: Colors.white, size: 24)
                  : null,
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
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppTypography.body,
                            fontWeight: FontWeight.w700,
                            color: BrandColors.text,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: AppTypography.caption,
                              color: BrandColors.textMuted,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: BrandColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: AppTypography.caption,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: AppTypography.body,
                      color: BrandColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BrandColors.primary, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.remove_red_eye_outlined,
              color: BrandColors.navy,
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Super Admin can monitor coach-parent communication. Contact is limited to assigned classes.',
                style: TextStyle(
                  color: BrandColors.textMuted,
                  fontSize: AppTypography.caption,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
