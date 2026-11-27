import '../../core/theme/app_typography.dart';
import '../../core/theme/brand_colors.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coachmax_coach/bloc/chat/chat_detail_cubit.dart';
import 'package:coachmax_coach/bloc/api_resp_state.dart';
import 'package:coachmax_coach/dto/chat_dto.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/ui/dashboard/video_message_player.dart';

class ChatDetailScreen extends StatefulWidget {
  final String conversationId;
  final String name;
  final String? avatarUrl;
  final bool isGroup;

  const ChatDetailScreen({
    Key? key,
    required this.conversationId,
    required this.name,
    this.avatarUrl,
    this.isGroup = false,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedFile;
  String? _selectedFileType;

  String _getDateSeparator(DateTime messageDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final msgDay = DateTime(
      messageDate.year,
      messageDate.month,
      messageDate.day,
    );

    if (msgDay == today) return "TODAY";
    if (msgDay == yesterday) return "YESTERDAY";
    return "${msgDay.day.toString().padLeft(2, '0')}/${msgDay.month.toString().padLeft(2, '0')}/${msgDay.year}";
  }

  String _getTime(DateTime messageDate) {
    final h = messageDate.hour.toString().padLeft(2, '0');
    final m = messageDate.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAttachmentOption(
                Icons.image,
                "Image",
                BrandColors.primary,
                () {
                  Navigator.pop(context);
                  _pickAndSendAttachment('IMAGE');
                },
              ),
              _buildAttachmentOption(
                Icons.videocam,
                "Video",
                BrandColors.warning,
                () {
                  Navigator.pop(context);
                  _pickAndSendAttachment('VIDEO');
                },
              ),
              _buildAttachmentOption(
                Icons.insert_drive_file,
                "Document",
                BrandColors.primary,
                () {
                  Navigator.pop(context);
                  _pickAndSendAttachment('FILE');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.caption,
            color: BrandColors.text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Future<void> _pickAndSendAttachment(String type) async {
    File? file;
    try {
      if (type == 'IMAGE') {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) file = File(image.path);
      } else if (type == 'VIDEO') {
        final ImagePicker picker = ImagePicker();
        final XFile? video = await picker.pickVideo(
          source: ImageSource.gallery,
        );
        if (video != null) file = File(video.path);
      } else if (type == 'FILE') {
        FilePickerResult? result = await FilePicker.pickFiles();
        if (result != null && result.files.single.path != null) {
          file = File(result.files.single.path!);
        }
      }

      if (file != null && mounted) {
        setState(() {
          _selectedFile = file;
          _selectedFileType = type;
        });
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  bool _showDateSeparator(List<ChatMessageDto> messages, int index) {
    if (index == messages.length - 1) return true;

    final currentMsgDate =
        DateTime.tryParse(messages[index].createdAt ?? '') ?? DateTime.now();
    final nextMsgDate =
        DateTime.tryParse(messages[index + 1].createdAt ?? '') ??
        DateTime.now();

    final currentDay = DateTime(
      currentMsgDate.year,
      currentMsgDate.month,
      currentMsgDate.day,
    );
    final nextDay = DateTime(
      nextMsgDate.year,
      nextMsgDate.month,
      nextMsgDate.day,
    );

    return currentDay != nextDay;
  }

  Widget _buildAttachmentView(ChatAttachmentDto? attachment, bool isSent) {
    if (attachment == null || attachment.url == null)
      return const SizedBox.shrink();

    final fullUrl = Constants.baseurl + attachment.url!;
    final textColor = isSent ? Colors.white : BrandColors.text;
    final iconColor = isSent ? Colors.white : BrandColors.text;
    final bgColor = isSent
        ? Colors.white.withOpacity(0.2)
        : Colors.black.withOpacity(0.05);

    if (attachment.fileType == 'IMAGE') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(fullUrl);
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              fullUrl,
              width: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 50, color: iconColor),
            ),
          ),
        ),
      );
    } else if (attachment.fileType == 'VIDEO') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: VideoMessagePlayer(videoUrl: fullUrl),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(fullUrl);
            if (await canLaunchUrl(uri)) await launchUrl(uri);
          },
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.insert_drive_file, color: iconColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "View Document",
                    style: TextStyle(
                      color: textColor,
                      decoration: TextDecoration.underline,
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

  Widget _buildAttachmentsList(
    List<ChatAttachmentDto>? attachments,
    bool isSent,
  ) {
    if (attachments == null || attachments.isEmpty)
      return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: attachments
          .map((a) => _buildAttachmentView(a, isSent))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatDetailCubit(widget.conversationId),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: BrandColors.background,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.isGroup
                              ? BrandColors.navy
                              : BrandColors.surfaceMuted,
                          image: (widget.avatarUrl != null && !widget.isGroup)
                              ? DecorationImage(
                                  image: NetworkImage(widget.avatarUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: widget.isGroup
                            ? const Icon(
                                Icons.people_alt,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: BrandColors.text,
                                fontSize: AppTypography.bodyLarge,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Maya's guardian · U12 Performance",
                              style: TextStyle(
                                color: BrandColors.textMuted,
                                fontSize: AppTypography.caption,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info_outline,
                          color: BrandColors.navy,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                // Banner
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BrandColors.successSoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.shield_outlined,
                          color: BrandColors.successText,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Messages are securely retained and visible to Super Admin.',
                            style: TextStyle(
                              color: BrandColors.successText,
                              fontSize: AppTypography.caption,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: BlocBuilder<ChatDetailCubit, ResponseState>(
                    builder: (context, state) {
                      if (state is ResponseStateLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ResponseStateError) {
                        return Center(child: Text(state.errorMessage));
                      } else if (state is ChatDetailState) {
                        final messages = state.messages;
                        return ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          itemCount: messages.length + (state.isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (state.isTyping && index == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${state.typingUserName ?? 'Someone'} is typing...",
                                  style: const TextStyle(
                                    color: BrandColors.textMuted,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              );
                            }

                            final actualIndex = state.isTyping
                                ? index - 1
                                : index;
                            final msg = messages[actualIndex];

                            // Check if sent by current user
                            final currentUserId = context
                                .read<ChatDetailCubit>()
                                .currentUserId;
                            bool isSent = false;

                            if (currentUserId.isNotEmpty &&
                                msg.sender?.user?.id != null) {
                              isSent = msg.sender?.user?.id == currentUserId;
                            } else {
                              // Fallback
                              isSent =
                                  msg.sender?.refModel == 'Coach' ||
                                  msg.sender?.refModel == 'Admin' ||
                                  msg.sender?.refModel == 'ServiceUser';
                            }

                            final msgDate =
                                DateTime.tryParse(
                                  msg.createdAt ?? '',
                                )?.toLocal() ??
                                DateTime.now();
                            final timeStr = _getTime(msgDate);

                            Widget? tickIcon;
                            String statusText = "";
                            if (isSent) {
                              if (msg.tickStatus == 'READ') {
                                statusText = "Read $timeStr";
                              } else if (msg.tickStatus == 'DELIVERED') {
                                statusText = "Delivered $timeStr";
                              } else {
                                statusText = "Sent $timeStr";
                              }
                            }

                            final showDate = _showDateSeparator(
                              messages,
                              actualIndex,
                            );

                            return Column(
                              children: [
                                if (showDate)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Text(
                                      _getDateSeparator(msgDate),
                                      style: const TextStyle(
                                        color: BrandColors.textMuted,
                                        fontSize: AppTypography.caption,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),

                                if (isSent)
                                  // Sent Message
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const SizedBox(
                                        width: 48,
                                      ), // Padding on left
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: const BoxDecoration(
                                                color: BrandColors.navy,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft: Radius.circular(
                                                    20,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    4,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildAttachmentsList(
                                                    msg.attachments,
                                                    true,
                                                  ),
                                                  if (msg.text?.isNotEmpty ==
                                                      true)
                                                    Text(
                                                      msg.text!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            AppTypography.body,
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                  if (msg.text?.isNotEmpty ==
                                                      true)
                                                    const SizedBox(height: 8),
                                                  Text(
                                                    statusText,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize:
                                                          AppTypography.caption,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                else
                                  // Received Message
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        margin: const EdgeInsets.only(top: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: (widget.avatarUrl != null)
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    widget.avatarUrl!,
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          color: BrandColors.border,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildAttachmentsList(
                                                msg.attachments,
                                                false,
                                              ),
                                              if (msg.text?.isNotEmpty == true)
                                                Text(
                                                  msg.text!,
                                                  style: const TextStyle(
                                                    color: BrandColors.text,
                                                    fontSize:
                                                        AppTypography.body,
                                                    height: 1.4,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 48,
                                      ), // Padding on right
                                    ],
                                  ),
                              ],
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Input Area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: BrandColors.divider, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        if (_selectedFile != null)
                          Container(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: BrandColors.surfaceMuted,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _selectedFileType == 'IMAGE'
                                              ? Icons.image
                                              : _selectedFileType == 'VIDEO'
                                              ? Icons.videocam
                                              : Icons.insert_drive_file,
                                          size: 20,
                                          color: BrandColors.textMuted,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _selectedFile!.path
                                                .split('/')
                                                .last
                                                .split('\\')
                                                .last,
                                            style: const TextStyle(
                                              fontSize: AppTypography.caption,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedFile = null;
                                              _selectedFileType = null;
                                            });
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            size: 18,
                                            color: BrandColors.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showAttachmentMenu(context),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: BrandColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: BrandColors.navy,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: BrandColors.background,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _messageController,
                                        onChanged: (text) {
                                          context
                                              .read<ChatDetailCubit>()
                                              .emitTyping();
                                        },
                                        decoration: InputDecoration(
                                          hintText:
                                              'Message ${widget.name.split(' ').first}...',
                                          hintStyle: const TextStyle(
                                            color: BrandColors.textMuted,
                                            fontSize: AppTypography.body,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: BrandColors.background,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.emoji_emotions_outlined,
                                color: BrandColors.navy,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                final text = _messageController.text;
                                if (_selectedFile != null &&
                                    _selectedFileType != null) {
                                  context
                                      .read<ChatDetailCubit>()
                                      .sendAttachment(
                                        _selectedFile!,
                                        _selectedFileType!,
                                        text,
                                      );
                                  setState(() {
                                    _selectedFile = null;
                                    _selectedFileType = null;
                                    _messageController.clear();
                                  });
                                } else if (text.isNotEmpty) {
                                  context.read<ChatDetailCubit>().sendMessage(
                                    text,
                                  );
                                  _messageController.clear();
                                }
                              },
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: BrandColors.navy,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
