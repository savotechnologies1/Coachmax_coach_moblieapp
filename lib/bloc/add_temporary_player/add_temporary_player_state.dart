import 'package:coachmax_coach/dto/temporary_player_dtos.dart';

class AddTemporaryPlayerFormData {
  final List<CategoryDto> categories;
  final List<ProgramDto> programs;
  final List<TermDto> terms;
  final List<ClassDropdownDto> classes;

  // Selected values
  final String? selectedCategory;
  final String? selectedProgram;
  final int? selectedYear;
  final String? selectedTerm;
  final List<String> selectedClasses;

  AddTemporaryPlayerFormData({
    required this.categories,
    required this.programs,
    required this.terms,
    required this.classes,
    this.selectedCategory,
    this.selectedProgram,
    this.selectedYear,
    this.selectedTerm,
    this.selectedClasses = const [],
  });

  AddTemporaryPlayerFormData copyWith({
    List<CategoryDto>? categories,
    List<ProgramDto>? programs,
    List<TermDto>? terms,
    List<ClassDropdownDto>? classes,
    String? selectedCategory,
    String? selectedProgram,
    int? selectedYear,
    String? selectedTerm,
    List<String>? selectedClasses,
    bool clearProgram = false,
    bool clearYear = false,
    bool clearTerm = false,
    bool clearClasses = false,
  }) {
    return AddTemporaryPlayerFormData(
      categories: categories ?? this.categories,
      programs: programs ?? this.programs,
      terms: terms ?? this.terms,
      classes: classes ?? this.classes,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProgram: clearProgram ? null : (selectedProgram ?? this.selectedProgram),
      selectedYear: clearYear ? null : (selectedYear ?? this.selectedYear),
      selectedTerm: clearTerm ? null : (selectedTerm ?? this.selectedTerm),
      selectedClasses: clearClasses ? [] : (selectedClasses ?? this.selectedClasses),
    );
  }
}
