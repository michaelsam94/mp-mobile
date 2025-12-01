class MapStationResponseModel {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? status;
  double? distance;
  int? availableGuns;
  int? totalGuns;
  String? totalGunsFormat;

  MapStationResponseModel(
      {this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.status,
      this.distance,
      this.availableGuns,
      this.totalGuns,
      this.totalGunsFormat});

  MapStationResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    distance = json['distance'];
    availableGuns = json['available_guns'];
    totalGuns = json['total_guns'];
    totalGunsFormat = json['total_guns_format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['distance'] = this.distance;
    data['available_guns'] = this.availableGuns;
    data['total_guns'] = this.totalGuns;
    data['total_guns_format'] = this.totalGunsFormat;
    return data;
  }
}
