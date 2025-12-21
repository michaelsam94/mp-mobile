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
    user = json['user'] != null ? new UserData.fromJson(json['user']) : null;
    expireDateTime = json["expireDateTime"] != null
        ? DateTime.parse(json["expireDateTime"].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data["expireDateTime"] = this.expireDateTime.toString();
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

  UserData({
    this.id,
    this.fullName,
    this.countryCode,
    this.mobileNumber,
    this.email,
    this.createdAt,
    this.birthday,
    this.gender,
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['country_code'] = this.countryCode;
    data['mobile_number'] = this.mobileNumber;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    return data;
  }
}
