import 'package:mega_plus/core/helpers/network/end_points.dart';

class TipResponseModel {
  int? id;
  String? title;
  String? description;
  int? sort;
  List<TipMedia>? media;

  TipResponseModel({this.id, this.title, this.description, this.sort, this.media});

  TipResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    sort = json['sort'];
    if (json['media'] != null) {
      media = (json['media'] as List).map((e) => TipMedia.fromJson(e)).toList();
    }
  }

  String? get imageUrl {
    if (media != null && media!.isNotEmpty) {
      return '${EndPoints.baseUrl}/storage/${media!.first.path}';
    }
    return null;
  }
}

class TipMedia {
  int? id;
  String? storage;
  String? path;
  String? collection;

  TipMedia({this.id, this.storage, this.path, this.collection});

  TipMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storage = json['storage'];
    path = json['path'];
    collection = json['collection'];
  }
}
