import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coachmax_coach/bloc/add_temporary_player/add_temporary_player_state.dart';
import 'package:coachmax_coach/dto/temporary_player_dtos.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:dio/dio.dart';
import 'package:coachmax_coach/bloc/api_resp_state.dart';

class AddTemporaryPlayerCubit extends Cubit<ResponseState> {
  final RestClient restClient;

  AddTemporaryPlayerCubit(this.restClient) : super(ResponseStateInitial());

  Future<void> fetchInitialData() async {
    try {
      emit(ResponseStateLoading());
      String token = await SharedPrefsHelper.getToken() ?? "";
      String authHeader = "Bearer $token";

      List<CategoryDto> categories = [];
      // Fetch Categories
      try {
        final catResponse = await restClient.getCategoriesApi(Constants.baseurl, authHeader, "all");
        if (catResponse.data != null) {
          if (catResponse.data is List) {
            categories = (catResponse.data as List).map((e) => CategoryDto.fromJson(e)).toList();
          } else if (catResponse.data is Map && catResponse.data['data'] != null) {
            categories = (catResponse.data['data'] as List).map((e) => CategoryDto.fromJson(e)).toList();
          }
        }
      } catch (e) {
        print("Failed to fetch categories: $e");
      }

      int currentYear = DateTime.now().year;

      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(AddTemporaryPlayerFormData(
        categories: categories,
        programs: [],
        terms: [],
        classes: [],
        selectedYear: currentYear,
      )));
      
      selectYear(currentYear);
    } catch (e) {
      emit(ResponseStateError(e.toString()));
    }
  }

  Future<void> selectCategory(String categoryId) async {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      
      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(
        selectedCategory: categoryId,
        programs: [],
        clearProgram: true,
        clearClasses: true,
      )));

      try {
        String token = await SharedPrefsHelper.getToken() ?? "";
        String authHeader = "Bearer $token";

        List<ProgramDto> programs = [];
        try {
          final progResponse = await restClient.getProgramsByCategoryApi(Constants.baseurl, authHeader, categoryId);
          if (progResponse.data != null) {
            if (progResponse.data is List) {
              programs = (progResponse.data as List).map((e) => ProgramDto.fromJson(e)).toList();
            } else if (progResponse.data is Map && progResponse.data['data'] != null) {
              programs = (progResponse.data['data'] as List).map((e) => ProgramDto.fromJson(e)).toList();
            }
          }
        } catch (e) {
          print("Failed to fetch programs: $e");
        }

        emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(
          selectedCategory: categoryId,
          programs: programs,
          clearProgram: true,
          clearClasses: true,
        )));

        _checkAndFetchClasses();
      } catch (e) {
        emit(ResponseStateError("Failed to fetch programs: $e"));
      }
    }
  }

  void selectProgram(String programId) {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(
        selectedProgram: programId,
        clearClasses: true,
      )));
      _checkAndFetchClasses();
    }
  }

  Future<void> selectYear(int year) async {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      
      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(
        selectedYear: year,
        clearTerm: true,
        clearClasses: true,
      )));
      
      try {
        String token = await SharedPrefsHelper.getToken() ?? "";
        String authHeader = "Bearer $token";

        final termResponse = await restClient.getAllTermsApi(Constants.baseurl, authHeader, "all", year);
        if (termResponse.data != null) {
          List<TermDto> fetchedTerms = [];
          if (termResponse.data is Map && termResponse.data['data'] != null) {
            fetchedTerms = (termResponse.data['data'] as List).map((e) => TermDto.fromJson(e)).toList();
          } else if (termResponse.data is List) {
            fetchedTerms = (termResponse.data as List).map((e) => TermDto.fromJson(e)).toList();
          }
          
          if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
             final latestState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
             emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(latestState.copyWith(terms: fetchedTerms)));
          }
        }
      } catch (e) {
        print("Failed to fetch terms for year $year: $e");
      }
    }
  }

  void selectTerm(String termId) {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(
        selectedTerm: termId,
        clearClasses: true,
      )));
      _checkAndFetchClasses();
    }
  }

  void toggleClass(String classId) {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      List<String> currentSelected = List.from(currentState.selectedClasses);
      if (currentSelected.contains(classId)) {
        currentSelected.remove(classId);
      } else {
        currentSelected.add(classId);
      }
      emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(selectedClasses: currentSelected)));
    }
  }

  List<int> getAvailableYears() {
    return List.generate(2080 - 2002 + 1, (index) => 2002 + index);
  }

  Future<void> _checkAndFetchClasses() async {
    if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
      final currentState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
      
      if (currentState.selectedCategory != null &&
          currentState.selectedProgram != null &&
          currentState.selectedTerm != null) {
        
        try {
          String token = await SharedPrefsHelper.getToken() ?? "";
          String authHeader = "Bearer $token";

          final response = await restClient.getDropdownClassesApi(
            Constants.baseurl,
            authHeader,
            currentState.selectedCategory,
            currentState.selectedProgram,
            currentState.selectedTerm,
          );

          if (response.data.success == true && response.data.data != null) {
            if (state is ResponseStateSuccess<AddTemporaryPlayerFormData>) {
               final latestState = (state as ResponseStateSuccess<AddTemporaryPlayerFormData>).data;
               emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(latestState.copyWith(classes: response.data.data!)));
            }
          }
        } catch (e) {
          // Keep silent or handle class fetch error
        }
      } else {
        emit(ResponseStateSuccess<AddTemporaryPlayerFormData>(currentState.copyWith(clearClasses: true)));
      }
    }
  }

  Future<void> submitTemporaryPlayer(Map<String, dynamic> payload) async {
    try {
      emit(ResponseStateLoading());
      
      String token = await SharedPrefsHelper.getToken() ?? "";
      String authHeader = "Bearer $token";

      final response = await restClient.addTemporaryPlayerApi(Constants.baseurl, authHeader, payload);
      
      if (response.data.success == true) {
        emit(const ResponseStateSuccess<bool>(true));
      } else {
        emit(ResponseStateError(response.data.message ?? "Failed to add player"));
      }
    } on DioException catch (e) {
      String errorMessage = "Failed to add player";
      if (e.response != null && e.response!.data != null && e.response!.data is Map) {
         errorMessage = e.response!.data['message'] ?? errorMessage;
      }
      emit(ResponseStateError(errorMessage));
    } catch (e) {
      emit(ResponseStateError(e.toString()));
    }
  }
}
