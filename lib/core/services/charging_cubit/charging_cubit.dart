import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../charging_api_service.dart';

part 'charging_state.dart';

class ChargingCubit extends Cubit<ChargingState> {
  ChargingCubit() : super(ChargingInitial());

  static ChargingCubit get(context) => BlocProvider.of(context);

  Future<void> startCharging(String chargerId, int connectorId,String rfid) async {
    emit(ChargingLoading());
    try {
      final response = await ChargingApiService.startCharging(
        chargerId,
        connectorId,
        rfid
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        emit(ChargingSuccess(response.data['data']));
      } else {
        emit(ChargingError(response.data['message']));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      emit(ChargingError('Failed to start charging'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ChargingError('An error occurred'));
    }
  }

  Future<void> stopCharging(String chargerId,int transactionId) async {
    emit(ChargingLoading());
    try {
      final response = await ChargingApiService.stopCharging(chargerId,transactionId);
      if (response.statusCode == 200 && response.data['success'] == true) {
        emit(ChargingSuccess(response.data['data']));
      } else {
        emit(ChargingError(response.data['message']));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      emit(ChargingError('Failed to stop charging'));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ChargingError('An error occurred'));
    }
  }
}
