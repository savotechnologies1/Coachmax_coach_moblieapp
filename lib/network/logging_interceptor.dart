import 'dart:convert';
import 'dart:developer';


import 'dart:async';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:coachmax_coach/main.dart';
import 'package:coachmax_coach/ui/auth/login_screen.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
class LoggingInterceptor extends Interceptor {
  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   print('REQUEST[${options.method}] => PATH: ${options.path}');
  //   return super.onRequest(options, handler);
  // }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    logPrint('***** API Request - Start *****');

    String langCode = "en";
    Map<String, dynamic> headers = options.headers;
    headers["Language"] = langCode;
    options.headers = headers;

    printKV('URI', options.uri);
    printKV('METHOD', options.method);
    logPrint('HEADERS:');
    options.headers.forEach((key, v) => printKV(' - $key', v));
    logPrint('BODY:');
    printAll(options.data ?? "");

    logPrint('***** API Request - End *****');

    return super.onRequest(options, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   print(
  //     'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions
  //         .path}',
  //   );
  //   return super.onResponse(response, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logPrint('***** Api Response - Start *****');

    printKV('URI', response.requestOptions.uri);
    printKV('STATUS CODE', response.statusCode);
    printKV('REDIRECT', response.isRedirect);
    
    // Handle plain text responses gracefully
    if (response.data is String && (response.data as String).isNotEmpty) {
      try {
        var parsed = jsonDecode(response.data);
        if (parsed is Map<String, dynamic>) {
          response.data = parsed;
        } else {
          response.data = {"success": false, "message": response.data};
        }
      } catch (_) {
        response.data = {"success": false, "message": response.data};
      }
    }

    // Handle case where API returns JSON with an empty string in 'data' field instead of null on error
    if (response.data is Map<String, dynamic>) {
      if (response.data['data'] is String) {
        response.data['data'] = null; // Prevent type cast error in fromJson
      }
    }

    logPrint('BODY:');
    printAll(response.data ?? "");

    logPrint('***** Api Response - End *****');

    return super.onResponse(response, handler);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   print(
  //     'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
  //   );
  //   return super.onError(err, handler);
  // }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logPrint('***** Api Error - Start *****:');

    logPrint('URI: ${err.requestOptions.uri}');
    if (err.response != null) {
      logPrint('STATUS CODE: ${err.response?.statusCode?.toString()}');
      if (err.response?.statusCode == 401) {
        bool shouldLogout = false;
        try {
          if (err.response?.data is String) {
            var parsed = jsonDecode(err.response!.data);
            if (parsed['message'] == 'Invalid or expired token') {
              shouldLogout = true;
            }
          } else if (err.response?.data is Map) {
            if (err.response!.data['message'] == 'Invalid or expired token') {
              shouldLogout = true;
            }
          }
        } catch (_) {}

        if (shouldLogout) {
          logPrint('Handling 401 Unauthorized - Token expired - Logging out');
          SharedPrefsHelper.clearToken().then((_) {
            if (navigatorKey.currentContext != null) {
              Navigator.pushAndRemoveUntil(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            }
          });
        }
      }
    }
    logPrint('$err');
    if (err.response != null) {
      printKV('REDIRECT', err.response?.realUri);
      logPrint('BODY:');
      printAll(err.response?.toString());
    }

    logPrint('***** Api Error - End *****:');
    return super.onError(err, handler);
  }

  void printKV(String key, dynamic v) {
    logPrint('$key: $v');
  }

  void printAll(dynamic msg) {
    if (msg is FormData) {
      // Special handling for FormData
      final fields = msg.fields.map((e) => "${e.key}: ${e.value}").join(", ");
      final files = msg.files.map((e) => e.key).join(", ");
      logPrint("FormData => Fields: {$fields}, Files: {$files}");
    } else {
      try {
        const JsonEncoder encoder = JsonEncoder.withIndent(' ');
        final prettyString = encoder.convert(msg);
        prettyString.split('\n').forEach((dynamic element) => print(element));
      } catch (e) {
        // fallback if not JSON encodable
        print(msg.toString());
      }
    }
  }


  void logPrint(String? s) {
    print(s);
  }
}