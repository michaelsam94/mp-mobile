class ConnectorResponseModel {
  String? type;
  String? label;

  ConnectorResponseModel({this.type, this.label});

  ConnectorResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['label'] = label;
    return data;
  }
}
