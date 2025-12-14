import 'package:dio/dio.dart';
import 'package:mega_plus/core/helpers/network/dio_helper.dart';
import 'package:mega_plus/core/helpers/network/end_points.dart';

class ChargingApiService {
  static Future<Response> startCharging(
    String chargerId,
    int connectorId,
    String rfid,
  ) async {
    return DioHelper.postData(
      url: EndPoints.startCharging,
      data: {
        "charger_id": chargerId,
        "connector_id": connectorId,
        "id_tag": rfid,
      },
    );
  }

  static Future<Response> stopCharging(
    String chargerId,
    String trasactionId,
  ) async {
    return DioHelper.postData(
      url: EndPoints.stopCharging,
      // data: {
      //   'charger_id': chargerId,
      // },
      data: {"charger_id": chargerId, "transaction_id": trasactionId},
    );
  }
}
