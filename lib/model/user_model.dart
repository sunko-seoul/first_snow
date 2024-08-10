class UserModel {
  final String? uid;
  String? email;
  String? name;
  int? age;
  String? instagramId;
  String? profileImagePath;
  DateTime? createdAt;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.age,
    this.instagramId,
    this.profileImagePath,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'instagramId': instagramId,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      age: json['age'],
      instagramId: json['instagramId'],
      profileImagePath: json['profileImagePath'],
      createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    );
  }
}