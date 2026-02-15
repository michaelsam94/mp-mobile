class UserCacheModel {
  String? tokenType;
  String? accessToken;
  int? expiresIn;
  UserData? user;
  DateTime? expireDateTime;

  UserCacheModel({this.tokenType, this.accessToken, this.expiresIn, this.user});

  UserCacheModel.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    user = json['user'] != null ? UserData.fromJson(json['user']) : null;
    expireDateTime = json["expireDateTime"] != null
        ? DateTime.parse(json["expireDateTime"].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data["expireDateTime"] = expireDateTime.toString();
    return data;
  }
}

class UserData {
  int? id;
  String? fullName;
  String? countryCode;
  String? mobileNumber;
  String? email;
  String? createdAt;
  String? birthday;
  String? gender;
  int? totalCharges;
  List<String>? media;
  String? mediaUrl;

  UserData({
    this.id,
    this.fullName,
    this.countryCode,
    this.mobileNumber,
    this.email,
    this.createdAt,
    this.birthday,
    this.gender,
    this.totalCharges,
    this.media,
    this.mediaUrl,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    createdAt = json['created_at'];
    birthday = json['birthday'];
    gender = json['gender'];
    totalCharges = json['total_charges'];
    mediaUrl = json['media_url'];
    if (json['media'] != null) {
      media = List<String>.from(json['media']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['country_code'] = countryCode;
    data['mobile_number'] = mobileNumber;
    data['email'] = email;
    data['created_at'] = createdAt;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['total_charges'] = totalCharges;
    data['media'] = media;
    data['media_url'] = mediaUrl;
    return data;
  }
}
