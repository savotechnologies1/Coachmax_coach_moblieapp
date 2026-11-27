import 'dart:async';
import 'dart:io';
import 'package:coachmax_coach/dto/utility_dto.dart';
import 'package:coachmax_coach/network/logging_interceptor.dart';
import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class AuthRepository {
  final Dio _dio = Dio();
  late RestClient _apiClient;
  String token = "";
  var url = Constants.baseurl;
  AuthRepository() {
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio);
    // appSession = AppSession();
  }

  Future<HttpResponse<UtilityDto>> forgotPasswordApi(body) async {
    var accessToken = "";
    token = "Bearer $accessToken";
    return _apiClient.forgotPasswordApi(url, body, token);
  }

  Future<HttpResponse<UtilityDto>> loginApi(body) async {
    return _apiClient.loginApi(url, body);
  }
}
