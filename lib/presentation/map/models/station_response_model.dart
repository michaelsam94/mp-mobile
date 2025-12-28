class StationResponseModel {
  int? id;
  String? name;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  String? status;
  bool? acCompatible;
  List<Guns>? guns;

  StationResponseModel({
    this.id,
    this.name,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.status,
    this.acCompatible,
    this.guns,
  });

  StationResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    city = json['city'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    acCompatible = json['ac_compatible'];
    if (json['guns'] != null) {
      guns = <Guns>[];
      json['guns'].forEach((v) {
        guns!.add(new Guns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['ac_compatible'] = this.acCompatible;
    if (this.guns != null) {
      data['guns'] = this.guns!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Guns {
  int? id;
  int? chargerId;
  String? chargerIdPrefex;
  String? status;
  String? name;
  String? maxPower;
  String? type;
  String? price;

  Guns({
    this.id,
    this.chargerId,
    this.chargerIdPrefex,
    this.status,
    this.name,
    this.maxPower,
    this.type,
    this.price,
  });

  Guns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chargerId = json['charger_id'];
    chargerIdPrefex = json['charger_id_prefex'];
    status = json['status'];
    name = json['name'];
    maxPower = json['max_power'];
    type = json['type'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['charger_id'] = this.chargerId;
    data['charger_id_prefex'] = this.chargerIdPrefex;
    data['status'] = this.status;
    data['name'] = this.name;
    data['max_power'] = this.maxPower;
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}
