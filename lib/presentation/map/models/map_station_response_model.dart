
class MapStationResponseModel  {
  int? id;
  String? name;
  String? latitude;
  String? longitude;
  String? status;
  String? distance;
  String? availableGuns;
  String? totalGuns;
  String? totalGunsFormat;

  MapStationResponseModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.status,
    this.distance,
    this.availableGuns,
    this.totalGuns,
    this.totalGunsFormat,
  });

  MapStationResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    status = json['status'];
    distance = json['distance'].toString();
    availableGuns = json['available_guns'].toString();
    totalGuns = json['total_guns'].toString();
    totalGunsFormat = json['total_guns_format'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['distance'] = distance;
    data['available_guns'] = availableGuns;
    data['total_guns'] = totalGuns;
    data['total_guns_format'] = totalGunsFormat;
    return data;
  }

}
