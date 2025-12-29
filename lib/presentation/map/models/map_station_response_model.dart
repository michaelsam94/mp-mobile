
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
  bool? acCompatible;

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
    this.acCompatible,
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
    acCompatible = json['ac_compatible'] ?? false;
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
    data['ac_compatible'] = acCompatible;
    return data;
  }

  /// Gets the appropriate station marker icon path based on AC/DC and status
  String getStationIconPath() {
    // If ac_compatible is true, it's AC, otherwise it's DC
    final isDC = !(acCompatible ?? false);
    final statusLower = status?.toLowerCase() ?? 'available';
    
    if (isDC) {
      // DC marker icons
      switch (statusLower) {
        case 'available':
          return 'assets/icons/dc_available.png';
        case 'unavailable':
          return 'assets/icons/dc_unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/dc_inuse.png';
        default:
          return 'assets/icons/dc_available.png';
      }
    } else {
      // AC marker icons
      switch (statusLower) {
        case 'available':
          return 'assets/icons/ac.png';
        case 'unavailable':
          return 'assets/icons/unavailable.png';
        case 'inuse':
        case 'in_use':
          return 'assets/icons/ac.png'; // Use AC icon for in use
        default:
          return 'assets/icons/ac.png';
      }
    }
  }
}
