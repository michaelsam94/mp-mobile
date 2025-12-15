class ContentPageModel {
  final int id;
  final String title;
  final String description;
  final int sort;
  final List<dynamic> media;

  ContentPageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.sort,
    required this.media,
  });

  factory ContentPageModel.fromJson(Map<String, dynamic> json) {
    return ContentPageModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sort: json['sort'] ?? 0,
      media: json['media'] ?? [],
    );
  }
}
