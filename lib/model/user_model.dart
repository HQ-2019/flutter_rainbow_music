/// nickname : ""
/// phone : "1860028233"

class UserModel {
  UserModel({
    this.nickname,
    this.phone,
  });

  UserModel.fromJson(dynamic json) {
    nickname = json['nickname'];
    phone = json['phone'];
  }

  String? nickname;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nickname'] = nickname;
    map['phone'] = phone;
    return map;
  }
}
