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

  Future<void> startCharging(
    String chargerId,
    int connectorId,
    String rfid, {
    int? vehicleId,
  }) async {
    emit(ChargingLoading());
    try {
      final response = await ChargingApiService.startCharging(
        chargerId,
        connectorId,
        rfid,
        vehicleId: vehicleId,
      );

      print(response.data);
      print(response.statusCode);
      
      // Handle 402 status code - insufficient balance
      if (response.statusCode == 402) {
        final errorMessage = response.data['message'] ?? 
                            'Insufficient balance. Please top up your account.';
        emit(InsufficientBalanceState(errorMessage));
        return;
      }
      
      // Check for both 'success' and 'status' fields in response
      final isSuccess = response.data['success'] == true || 
                       (response.data['status'] != null && response.data['status'] == true);
      
      if (response.statusCode == 200 && isSuccess) {
        emit(ChargingSuccess(response.data['data'] ?? true));
      } else {
        final errorMessage = response.data['message'] ?? 
                            'Unable to start charging. Please try again.';
        emit(ChargingError(errorMessage));
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      // Handle 402 status code in DioException
      if (e.response?.statusCode == 402) {
        final errorMessage = e.response?.data['message'] ?? 
                            'Insufficient balance. Please top up your account.';
        emit(InsufficientBalanceState(errorMessage));
      } else {
        emit(ChargingError('Failed to start charging'));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(ChargingError('An error occurred'));
    }
  }

  String? pdfUrl;
  Future<void> stopCharging(String chargerId, String transactionId, [String? connectorId]) async {
    emit(ChargingLoading());
    try {
      final response = await ChargingApiService.stopCharging(
        chargerId,
        transactionId,
        connectorId ?? "",
      );

      print(response.data);
      print(response.statusCode);

      if (response.statusCode == 200 && response.data['success'] == true) {
        pdfUrl = response.data["data"][0];
        emit(StopChargingSuccess(response.data['success']));
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
