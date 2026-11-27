
import 'package:coachmax_coach/bloc/api_resp_state.dart';
import 'package:coachmax_coach/dto/utility_dto.dart';
import 'package:coachmax_coach/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../network/server_error.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';



class AuthCubit extends Cubit<ResponseState> {
  final AuthRepository? authRepository;

  AuthCubit(this.authRepository) : super(ResponseStateInitial());

 

  Future<void> forgotPasswordApi(body) async {
    emit(ResponseStateLoading());
    try {
      final HttpResponse<UtilityDto> httpResponse =
      (await authRepository!.forgotPasswordApi(body)) as HttpResponse<UtilityDto>;
      final UtilityDto dto = httpResponse.data as UtilityDto;

      emit(ResponseStateSuccess(dto));
    } on DioException catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }

  Future<void> loginApi(body) async {
    emit(ResponseStateLoading());
    try {
      final HttpResponse<UtilityDto> httpResponse =
      (await authRepository!.loginApi(body)) as HttpResponse<UtilityDto>;
      final UtilityDto dto = httpResponse.data as UtilityDto;

      if (dto.token != null) {
        await SharedPrefsHelper.saveToken(dto.token!);
      }

      emit(ResponseStateSuccess(dto));
    } on DioException catch (error) {
      emit(ServerError.mapDioErrorToState(error));
    }
  }
}

