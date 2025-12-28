class StationDetailsModel {
  final int id;
  final String name;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String status;
  final bool acCompatible;
  final List<String> mediaUrl;
  final List<GunDetail> guns;

  StationDetailsModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.acCompatible,
    required this.mediaUrl,
    required this.guns,
  });

  factory StationDetailsModel.fromJson(Map<String, dynamic> json) {
    return StationDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "N/A",
      address: json['address'] ?? "N/A",
      city: json['city'] ?? "N/A",
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      status: json['status'] ?? "N/A",
      acCompatible: json['ac_compatible'] ?? false,
      mediaUrl: List<String>.from(json['media_url']),
      guns: (json['guns'] as List)
          .map((gun) => GunDetail.fromJson(gun))
          .toList(),
    );
  }
}

class GunDetail {
  final int id;
  final int chargerId;
  final String chargerIdPrefex;
  final String status;
  final String name;
  final String maxPower;
  final String type;
  final String price;

  GunDetail({
    required this.id,
    required this.chargerId,
    required this.chargerIdPrefex,
    required this.status,
    required this.name,
    required this.maxPower,
    required this.type,
    required this.price,
  });

  factory GunDetail.fromJson(Map<String, dynamic> json) {
    return GunDetail(
      id: json['id'] ?? 0,
      chargerId: json['charger_id'] ?? 0,
      chargerIdPrefex: json['charger_id_prefex'] ?? "N/A",
      status: json['status'] ?? "N/A",
      name: json['name'] ?? "N/A",
      maxPower: json['max_power'] ?? "N/A",
      type: json['type'] ?? "N/A",
      price: json['price'] ?? "N/A",
    );
  }
}
