class StationResponseModel {
  int? id;
  String? name;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  String? status;
  List<Guns>? guns;
  String? mediaUrl;
  List<String>? mediaUrls;
  bool? isFavourite;
  bool? acCompatible;

  StationResponseModel({
    this.id,
    this.name,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.status,
    this.guns,
    this.mediaUrl,
    this.mediaUrls,
    this.isFavourite,
    this.acCompatible,
  });

  StationResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    isFavourite = json['is_favourite'] ?? false;
    acCompatible = json['ac_compatible'] ?? false;

    // Handle media_url - can be a string, list, or null
    if (json['media_url'] != null) {
      if (json['media_url'] is String) {
        // Single URL string
        mediaUrl = json['media_url'];
      } else if (json['media_url'] is List) {
        // Array of URLs
        final mediaList = json['media_url'] as List;
        if (mediaList.isNotEmpty) {
          mediaUrls = mediaList
              .map((e) {
                if (e is String) return e;
                if (e is Map && e['url'] != null) return e['url'].toString();
                if (e is Map && e['media_url'] != null) {
                  return e['media_url'].toString();
                }
                return e.toString();
              })
              .toList()
              .cast<String>();
        }
      }
    }

    // Handle media_urls (separate field)
    if (json['media_urls'] != null && json['media_urls'] is List) {
      mediaUrls = List<String>.from(json['media_urls']);
    }

    // Fallback: handle media field
    if (json['media'] != null && json['media'] is List) {
      final mediaList = json['media'] as List;
      if (mediaList.isNotEmpty) {
        mediaUrls = mediaList
            .map((e) {
              if (e is String) return e;
              if (e is Map && e['url'] != null) return e['url'].toString();
              if (e is Map && e['media_url'] != null) {
                return e['media_url'].toString();
              }
              return e.toString();
            })
            .toList()
            .cast<String>();
      }
    }

    if (json['guns'] != null) {
      guns = <Guns>[];
      json['guns'].forEach((v) {
        guns!.add(Guns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['city'] = city;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status'] = status;
    data['media_url'] = mediaUrl;
    data['media_urls'] = mediaUrls;
    data['is_favourite'] = isFavourite;
    data['ac_compatible'] = acCompatible;
    if (guns != null) {
      data['guns'] = guns!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  /// Get list of image URLs for carousel
  List<String> get imageUrls {
    List<String> urls = [];
    if (mediaUrls != null && mediaUrls!.isNotEmpty) {
      urls.addAll(mediaUrls!);
    } else if (mediaUrl != null && mediaUrl!.isNotEmpty) {
      urls.add(mediaUrl!);
    }
    return urls;
  }
}

class Guns {
  int? id;
  int? chargerId;
  String? status;
  String? name;
  String? maxPower;
  String? type;
  String? price;

  Guns({
    this.id,
    this.chargerId,
    this.status,
    this.name,
    this.maxPower,
    this.type,
    this.price,
  });

  Guns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargerId = json['charger_id'];
    status = json['status'];
    name = json['name'];
    maxPower = json['max_power'];
    type = json['type'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['charger_id'] = chargerId;
    data['status'] = status;
    data['name'] = name;
    data['max_power'] = maxPower;
    data['type'] = type;
    data['price'] = price;
    return data;
  }
}
