import 'package:dio/dio.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';

class ChargingApiService {
  static Future<Response> startCharging(
    String chargerId,
    int connectorId,
    String rfid, {
    int? vehicleId,
  }) async {
    final data = {
      "charger_id": chargerId,
      "connector_id": connectorId,
      "id_tag": rfid,
    };
    
    // Add vehicle_id if provided
    if (vehicleId != null) {
      data["vehicle_id"] = vehicleId;
    }
    
    return DioHelper.postData(
      url: EndPoints.startCharging,
      data: data,
    );
  }

  static Future<Response> stopCharging(
    String chargerId,
    String transactionId,
    String connectorId,
  ) async {
    return DioHelper.postData(
      url: EndPoints.stopCharging,
      data: {
        "charger_id": chargerId,
        "transaction_id": transactionId,
        "connector_id": connectorId,
      },
    );
  }

  static Future<Response> getCurrentCharging() async {
    return DioHelper.getData(
      url: EndPoints.currentCharging,
      auth: true,
    );
  }

  static Future<Response> getCurrentChargingBySession(int sessionId) async {
    return DioHelper.getData(
      url: EndPoints.currentChargingWithSession(sessionId),
      auth: true,
    );
  }
}
