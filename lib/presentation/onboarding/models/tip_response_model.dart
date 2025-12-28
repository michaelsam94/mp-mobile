class TipResponseModel {
  int? id;
  String? title;
  String? description;
  int? sort;
  String? mediaUrl;

  TipResponseModel(
      {this.id, this.title, this.description, this.sort, this.mediaUrl});

  TipResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    sort = json['sort'];
    mediaUrl = json['media_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sort'] = this.sort;
    data['media_url'] = this.mediaUrl;
    return data;
  }
}
