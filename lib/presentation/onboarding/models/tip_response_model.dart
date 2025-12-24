class TipResponseModel {
  int? id;
  String? title;
  String? description;
  int? sort;
  List<Media>? media;

  TipResponseModel(
      {this.id, this.title, this.description, this.sort, this.media});

  TipResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    sort = json['sort'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sort'] = this.sort;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int? id;
  String? storage;
  String? path;
  String? collection;
  int? mediableId;
  String? mediableType;
  String? createdAt;
  String? updatedAt;

  Media(
      {this.id,
      this.storage,
      this.path,
      this.collection,
      this.mediableId,
      this.mediableType,
      this.createdAt,
      this.updatedAt});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storage = json['storage'];
    path = json['path'];
    collection = json['collection'];
    mediableId = json['mediable_id'];
    mediableType = json['mediable_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['storage'] = this.storage;
    data['path'] = this.path;
    data['collection'] = this.collection;
    data['mediable_id'] = this.mediableId;
    data['mediable_type'] = this.mediableType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
