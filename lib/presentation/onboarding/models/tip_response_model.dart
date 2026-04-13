import 'package:mega_plus/core/helpers/network/end_points.dart';

class TipResponseModel {
  int? id;
  String? title;
  String? titleAr;
  String? description;
  String? descriptionAr;
  int? sort;
  List<TipMedia>? media;
  String? mediaUrl;

  TipResponseModel({
    this.id,
    this.title,
    this.description,
    this.sort,
    this.media,
    this.mediaUrl,
    this.titleAr,
    this.descriptionAr,
  });

  TipResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    titleAr = json['title_ar'];
    description = json['description'];
    descriptionAr = json['description_ar'];
    sort = json['sort'];
    mediaUrl = json['media_url'];
    if (json['media'] != null) {
      media = (json['media'] as List).map((e) => TipMedia.fromJson(e)).toList();
    }
  }

  String? get imageUrl {
    // Use media_url if available (new API format)
    if (mediaUrl != null && mediaUrl!.isNotEmpty) {
      return mediaUrl;
    }
    // Fallback to old format with media array
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
