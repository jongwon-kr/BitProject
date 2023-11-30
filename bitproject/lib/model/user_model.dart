class User {
  final String? nickname;
  final String? major;
  final String? gender;

  User({required this.nickname, required this.major, required this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nickname: json['nickname'],
        major: json['major'],
        gender: json['gender']);
  }
  Map<String, dynamic> toJson() => {
        'nickname': nickname,
        'major': major,
        'gender': gender,
      };
}
