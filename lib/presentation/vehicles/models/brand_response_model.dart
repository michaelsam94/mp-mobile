class BrandResponseModel {
  int? id;
  String? name;

  BrandResponseModel({this.id, this.name});

  BrandResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
