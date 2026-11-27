import '../../core/theme/brand_colors.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coachmax_coach/bloc/profile/profile_cubit.dart';
import 'package:coachmax_coach/bloc/profile/profile_state.dart';
import 'package:coachmax_coach/dto/my_profile_response_dto.dart';
import 'package:coachmax_coach/utils/constants.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileDataDto profile;
  final ProfileCubit cubit;

  const EditProfileScreen({
    Key? key,
    required this.profile,
    required this.cubit,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailContoller;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.mobile);
    _emailContoller = TextEditingController(text: widget.profile.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailContoller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: BrandColors.text),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: BrandColors.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoaded) {
              Navigator.pop(context);
            } else if (state is ProfileUpdateError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            final isLoading = state is ProfileUpdateLoading;

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: BrandColors.border,
                              border: Border.all(color: Colors.white, width: 4),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image:
                                          (widget.profile.profileImage != null)
                                          ? NetworkImage(
                                              '${Constants.baseurlImg}${widget.profile.profileImage}',
                                            )
                                          : const NetworkImage(
                                                  'https://i.pravatar.cc/150?img=11',
                                                )
                                                as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: BrandColors.navy,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField('Full name', _nameController),
                    const SizedBox(height: 16),

                    _buildTextField('Email', _emailContoller, readOnly: true),
                    const SizedBox(height: 16),
                    _buildTextField('Phone', _phoneController, isPhone: true),
                    const SizedBox(height: 48),
                    AppButton(
                      isLoading: isLoading,
                      label: 'Save changes',
                      onPressed: () {
                        widget.cubit.updateProfile(
                          fullName: _nameController.text.trim(),
                          phone: _phoneController.text.trim(),
                          profileImage: _selectedImage,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPhone = false,
    bool readOnly = false,
  }) {
    return AppTextField(
      label: label,
      controller: controller,
      readOnly: readOnly,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
    );
  }
}
