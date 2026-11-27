import 'package:coachmax_coach/network/rest_client.dart';
import 'package:coachmax_coach/utils/shared_prefs_helper.dart';
import 'package:coachmax_coach/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'temporary_players_list_state.dart';

class TemporaryPlayersListCubit extends Cubit<TemporaryPlayersListState> {
  final RestClient restClient;

  TemporaryPlayersListCubit(this.restClient) : super(TemporaryPlayersListInitial());

  Future<void> fetchTemporaryPlayers() async {
    emit(TemporaryPlayersListLoading());
    try {
      final token = await SharedPrefsHelper.getToken();
      if (token == null || token.isEmpty) {
        emit(const TemporaryPlayersListError("Unauthorized access."));
        return;
      }

      final response = await restClient.getTemporaryPlayersApi(
        Constants.baseurl,
        'Bearer $token',
      );

      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        final data = response.data;
        if (data.success == true && data.data != null) {
          emit(TemporaryPlayersListLoaded(data.data!));
        } else {
          emit(TemporaryPlayersListError(data.message ?? 'Failed to fetch temporary players.'));
        }
      } else {
        emit(const TemporaryPlayersListError("Failed to fetch temporary players."));
      }
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data['message'] ?? e.message ?? "Network error";
        emit(TemporaryPlayersListError(message));
      } else {
        emit(TemporaryPlayersListError(e.toString()));
      }
    }
  }
}
