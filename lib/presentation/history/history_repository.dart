import 'package:dio/dio.dart';

import '../../core/helpers/network/dio_helper.dart';
import '../../core/helpers/network/end_points.dart';
import 'history_model.dart';

class HistoryRepository {
  Future<HistoryResponse> getChargingHistory() async {
    try {
      final response = await DioHelper.getData(
        url: EndPoints.chargingHistory,
        auth: true,
      );

      if (response.statusCode == 200) {
        return HistoryResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load charging history');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
