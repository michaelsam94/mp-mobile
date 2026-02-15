class NotificationModel {
  int? id;
  String? title;
  String? body;
  bool? isRead;
  String? sentAt;
  String? readAt;
  String? createdAt;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.isRead,
    this.sentAt,
    this.readAt,
    this.createdAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    isRead = json['is_read'] ?? false;
    sentAt = json['sent_at'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['is_read'] = isRead;
    data['sent_at'] = sentAt;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    return data;
  }
}
