class TipResponseModel {
  String? title;
  String? description;
  int? sort;

  TipResponseModel({this.title, this.description, this.sort});

  TipResponseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    sort = json['sort'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['sort'] = this.sort;
    return data;
  }
}
