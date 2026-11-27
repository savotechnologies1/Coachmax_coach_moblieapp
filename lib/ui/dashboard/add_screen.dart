import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../core/theme/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:coachmax_coach/bloc/add_temporary_player/add_temporary_player_cubit.dart';
import 'package:coachmax_coach/bloc/add_temporary_player/add_temporary_player_state.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/bloc/api_resp_state.dart';
import 'package:coachmax_coach/utils/utility.dart';
import 'package:dio/dio.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AddTemporaryPlayerCubit(RestClient(Dio()))..fetchInitialData(),
      child: const AddScreenView(),
    );
  }
}

class AddScreenView extends StatefulWidget {
  const AddScreenView({Key? key}) : super(key: key);

  @override
  State<AddScreenView> createState() => _AddScreenViewState();
}

class _AddScreenViewState extends State<AddScreenView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _playerNameCtrl = TextEditingController();
  DateTime? _dob;
  String? _gender;
  String? _preferredFoot;
  final TextEditingController _parentNameCtrl = TextEditingController();
  final TextEditingController _parentEmailCtrl = TextEditingController();
  final TextEditingController _parentPhoneCtrl = TextEditingController();
  final TextEditingController _emergencyContactCtrl = TextEditingController();
  final TextEditingController _medicalConditionsCtrl = TextEditingController();
  final TextEditingController _allergiesCtrl = TextEditingController();
  DateTime _sessionDate = DateTime.now();

  @override
  void dispose() {
    _playerNameCtrl.dispose();
    _parentNameCtrl.dispose();
    _parentEmailCtrl.dispose();
    _parentPhoneCtrl.dispose();
    _emergencyContactCtrl.dispose();
    _medicalConditionsCtrl.dispose();
    _allergiesCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      Utility().showFlushBar(
        context: context,
        message: 'Please fill all required fields correctly',
        isError: true,
      );
      return;
    }
    if (_dob == null) {
      Utility().showFlushBar(
        context: context,
        message: 'Please select Date of Birth',
        isError: true,
      );
      return;
    }
    final cubit = context.read<AddTemporaryPlayerCubit>();
    final state = cubit.state;
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final data = state.data;
      if (data.selectedCategory == null) {
        Utility().showFlushBar(
          context: context,
          message: 'Please select Main Category',
          isError: true,
        );
        return;
      }
      if (data.selectedProgram == null) {
        Utility().showFlushBar(
          context: context,
          message: 'Please select Sub Category',
          isError: true,
        );
        return;
      }
      if (data.selectedYear == null) {
        Utility().showFlushBar(
          context: context,
          message: 'Please select Year',
          isError: true,
        );
        return;
      }
      if (data.selectedTerm == null) {
        Utility().showFlushBar(
          context: context,
          message: 'Please select Preferred Term',
          isError: true,
        );
        return;
      }
      if (data.selectedClasses.isEmpty) {
        Utility().showFlushBar(
          context: context,
          message: 'Please assign at least 1 Class',
          isError: true,
        );
        return;
      }

      final payload = {
        "name": _playerNameCtrl.text,
        "dob": DateFormat('yyyy-MM-dd').format(_dob!),
        "parentName": _parentNameCtrl.text,
        "parentEmail": _parentEmailCtrl.text,
        "parentPhone": _parentPhoneCtrl.text,
        "emergencyContact": _emergencyContactCtrl.text,
        "medicalConditions": _medicalConditionsCtrl.text.isNotEmpty
            ? _medicalConditionsCtrl.text
            : "None",
        "allergies": _allergiesCtrl.text.isNotEmpty
            ? _allergiesCtrl.text
            : "None",
        "classId": data
            .selectedClasses
            .first, // the spec says assign classes plural, payload example uses single for this but preferredClasses array
        "sessionDate": DateFormat('yyyy-MM-dd').format(_sessionDate),
        "categories": [data.selectedCategory],
        "programs": [data.selectedProgram],
        "preferredTerm": data.selectedTerm,
        "preferredClasses": data.selectedClasses,
        "preferredFoot": (_preferredFoot ?? "Right").toUpperCase(),
        "prefferedFoot": (_preferredFoot ?? "Right").toUpperCase(),
        "gender": (_gender ?? "Male").toUpperCase(),
      };

      cubit.submitTemporaryPlayer(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,

        elevation: 0,
        // leading: Container(
        //   margin: const EdgeInsets.all(8),
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
        //     icon: const Icon(Icons.arrow_back, color: BrandColors.text, size: 20),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'U12 PERFORMANCE · TODAY',
            //   style: TextStyle(
            //     color: BrandColors.textMuted,
            //     fontSize: AppTypography.caption,
            //     fontWeight: FontWeight.w700,
            //     letterSpacing: 0.5,
            //   ),
            // ),
            const Text(
              'Temporary player',
              style: TextStyle(
                color: BrandColors.text,
                fontSize: AppTypography.section,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: BlocConsumer<AddTemporaryPlayerCubit, ResponseState>(
        listener: (context, state) {
          if (state is ResponseStateSuccess<bool>) {
            Utility().showFlushBar(
              context: context,
              message: 'Temporary player added successfully!',
            );

            // Re-fetch initial data to clear the form fields
            context.read<AddTemporaryPlayerCubit>().fetchInitialData();

            // Also clear text controllers
            _playerNameCtrl.clear();
            _parentNameCtrl.clear();
            _parentEmailCtrl.clear();
            _parentPhoneCtrl.clear();
            _emergencyContactCtrl.clear();
            _medicalConditionsCtrl.clear();
            _allergiesCtrl.clear();
            setState(() {
              _dob = null;
              _gender = null;
              _preferredFoot = null;
            });
          } else if (state is ResponseStateError) {
            Utility().showFlushBar(
              context: context,
              message: state.errorMessage,
              isError: true,
            );
          }
        },
        builder: (context, state) {
          if (state is ResponseStateLoading || state is ResponseStateInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ResponseStateError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: BrandColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load data\n${state.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: BrandColors.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<AddTemporaryPlayerCubit>()
                          .fetchInitialData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
            final formData = state.data;
            return SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoBox(),
                      const SizedBox(height: 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isMobile = constraints.maxWidth < 600;
                          return isMobile
                              ? _buildMobileLayout(formData)
                              : _buildDesktopLayout(formData);
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => _submit(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BrandColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Add Temporary player',
                            style: TextStyle(
                              fontSize: AppTypography.bodyLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Super Admin is notified when you add a temporary player.',
                          style: TextStyle(
                            fontSize: AppTypography.caption,
                            color: BrandColors.textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: BrandColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_outline, color: BrandColors.navy, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Temporary player access applies only to this session unless approved by Super Admin.',
              style: TextStyle(
                color: BrandColors.navy,
                fontSize: AppTypography.body,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(AddTemporaryPlayerFormData state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          'Player Name',
          'Full name',
          _playerNameCtrl,
          required: true,
        ),
        const SizedBox(height: 16),
        _buildDateField(
          'Date of Birth',
          _dob,
          (date) => setState(() => _dob = date),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          'Gender',
          ['Male', 'Female', 'Other'],
          _gender,
          (val) => setState(() => _gender = val),
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          'Preferred Foot',
          ['Right', 'Left', 'Both'],
          _preferredFoot,
          (val) => setState(() => _preferredFoot = val),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Parent Name',
          'Parent or guardian name',
          _parentNameCtrl,
          required: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Parent Email',
          'Email address',
          _parentEmailCtrl,
          required: true,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Parent Phone',
          'Mobile number',
          _parentPhoneCtrl,
          required: true,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Emergency Contact',
          'Emergency phone',
          _emergencyContactCtrl,
          required: true,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          'Medical Conditions',
          'Allergies, conditions or medication',
          _medicalConditionsCtrl,
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        _buildTextField('Allergies', 'E.g. Peanuts', _allergiesCtrl),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        _buildCategoryDropdown(state),
        const SizedBox(height: 16),
        _buildProgramDropdown(state),
        const SizedBox(height: 16),
        _buildYearDropdown(state),
        const SizedBox(height: 16),
        _buildTermDropdown(state),
        const SizedBox(height: 16),
        _buildDateField(
          'Session Date',
          _sessionDate,
          (date) => setState(() => _sessionDate = date!),
        ),
        const SizedBox(height: 16),
        _buildClassSelection(state),
      ],
    );
  }

  Widget _buildDesktopLayout(AddTemporaryPlayerFormData state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          'Player Name',
          'Full name',
          _playerNameCtrl,
          required: true,
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Player Name',
                'Full name',
                _playerNameCtrl,
                required: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                'Date of Birth',
                _dob,
                (date) => setState(() => _dob = date),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDropdown(
                'Gender',
                ['Male', 'Female', 'Other'],
                _gender,
                (val) => setState(() => _gender = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                'Preferred Foot',
                ['Right', 'Left', 'Both'],
                _preferredFoot,
                (val) => setState(() => _preferredFoot = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Parent Name',
                'Parent or guardian name',
                _parentNameCtrl,
                required: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Parent Email',
                'Email address',
                _parentEmailCtrl,
                required: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Parent Phone',
                'Mobile number',
                _parentPhoneCtrl,
                required: true,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Emergency Contact',
                'Emergency phone',
                _emergencyContactCtrl,
                required: true,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                'Medical Conditions',
                'Allergies, conditions or medication',
                _medicalConditionsCtrl,
                maxLines: 2,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Allergies',
                'E.g. Peanuts',
                _allergiesCtrl,
                maxLines: 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCategoryDropdown(state)),
            const SizedBox(width: 16),
            Expanded(child: _buildProgramDropdown(state)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildYearDropdown(state)),
            const SizedBox(width: 16),
            Expanded(child: _buildTermDropdown(state)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDateField(
                'Session Date',
                _sessionDate,
                (date) => setState(() => _sessionDate = date!),
              ),
            ),
            const SizedBox(width: 16),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),
        _buildClassSelection(state),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return AppTextField(
      label: label + (required ? ' *' : ''),
      hint: hint,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (val) {
        if (required && (val == null || val.trim().isEmpty))
          return 'This field is required';
        if (keyboardType == TextInputType.emailAddress &&
            val != null &&
            val.isNotEmpty &&
            !val.contains('@'))
          return 'Invalid email';
        return null;
      },
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration('Select $label'),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ' *',
          style: const TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) onChanged(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value == null
                      ? 'DD/MM/YYYY'
                      : DateFormat('dd/MM/yyyy').format(value),
                  style: TextStyle(
                    color: value == null
                        ? BrandColors.textMuted
                        : BrandColors.text,
                    fontSize: AppTypography.body,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: BrandColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) =>
      InputDecoration(hintText: hint);

  Widget _buildCategoryDropdown(AddTemporaryPlayerFormData state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Main Category *',
          style: TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.selectedCategory,
          items: state.categories
              .map(
                (c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? '')),
              )
              .toList(),
          onChanged: (val) =>
              context.read<AddTemporaryPlayerCubit>().selectCategory(val!),
          decoration: _inputDecoration('Select Category'),
        ),
      ],
    );
  }

  Widget _buildProgramDropdown(AddTemporaryPlayerFormData state) {
    bool enabled = state.selectedCategory != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sub Category (Program) *',
          style: TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.selectedProgram,
          items: state.programs
              .map(
                (p) => DropdownMenuItem(value: p.id, child: Text(p.name ?? '')),
              )
              .toList(),
          onChanged: enabled
              ? (val) =>
                    context.read<AddTemporaryPlayerCubit>().selectProgram(val!)
              : null,
          decoration:
              _inputDecoration(
                enabled ? 'Select Program' : 'Select Category first',
              ).copyWith(
                fillColor: enabled ? Colors.white : BrandColors.surfaceMuted,
              ),
          disabledHint: const Text(
            'Select Category first',
            style: TextStyle(color: BrandColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildYearDropdown(AddTemporaryPlayerFormData state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Year *',
          style: TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: state.selectedYear,
          items: context
              .read<AddTemporaryPlayerCubit>()
              .getAvailableYears()
              .map((y) => DropdownMenuItem(value: y, child: Text(y.toString())))
              .toList(),
          onChanged: (val) =>
              context.read<AddTemporaryPlayerCubit>().selectYear(val!),
          decoration: _inputDecoration('Select Year'),
        ),
      ],
    );
  }

  Widget _buildTermDropdown(AddTemporaryPlayerFormData state) {
    bool enabled = state.selectedYear != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Term *',
          style: TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state.selectedTerm,
          items: state.terms
              .map(
                (t) => DropdownMenuItem(value: t.id, child: Text(t.name ?? '')),
              )
              .toList(),
          onChanged: enabled
              ? (val) =>
                    context.read<AddTemporaryPlayerCubit>().selectTerm(val!)
              : null,
          decoration:
              _inputDecoration(
                enabled ? 'Select Term' : 'Select Year first',
              ).copyWith(
                fillColor: enabled ? Colors.white : BrandColors.surfaceMuted,
              ),
          disabledHint: const Text(
            'Select Year first',
            style: TextStyle(color: BrandColors.textMuted),
          ),
        ),
      ],
    );
  }

  Widget _buildClassSelection(AddTemporaryPlayerFormData state) {
    if (state.selectedCategory == null ||
        state.selectedProgram == null ||
        state.selectedTerm == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assign Class *',
          style: TextStyle(
            color: BrandColors.text,
            fontSize: AppTypography.body,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        if (state.classes.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'No classes found for current selection.',
              style: TextStyle(
                color: BrandColors.text,
                fontSize: AppTypography.body,
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.classes.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final cls = state.classes[index];
                final isSelected = state.selectedClasses.contains(cls.classId);
                return CheckboxListTile(
                  title: Text(cls.className ?? ''),
                  subtitle: Text(
                    '${cls.dayOfWeek ?? ''} ${cls.startTime ?? ''} • ${cls.location ?? ''}',
                  ),
                  value: isSelected,
                  onChanged: (val) {
                    if (cls.classId != null) {
                      context.read<AddTemporaryPlayerCubit>().toggleClass(
                        cls.classId!,
                      );
                    }
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
