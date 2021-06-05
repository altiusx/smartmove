class User
{
  String id;
  String name;
  String email;
  String loginType;
  String imagePath;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        imagePath = json['imagePath'],
        loginType = json['loginType'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'imagePath': imagePath,
    'loginType': loginType,
  };
}