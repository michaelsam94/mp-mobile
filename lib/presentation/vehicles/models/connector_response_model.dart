class ConnectorResponseModel {
  String? type;
  String? label;

  ConnectorResponseModel({this.type, this.label});

  ConnectorResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['label'] = this.label;
    return data;
  }
}
