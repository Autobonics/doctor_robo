class AppUser {
  final String id;
  final String fullName;
  final String email;
  final int age;
  final String gender;
  final String userRole;

  AppUser(
      {required this.id,
      required this.fullName,
      required this.email,
      required this.age,
      required this.gender,
      required this.userRole});

  AppUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        age = data['age'],
        gender = data['gender'],
        userRole = data['userRole'] ?? "patient";

  Map<String, dynamic> toJson(keyword) {
    return {
      'id': id,
      'fullName': fullName,
      'keyword': keyword,
      'email': email,
      'age': age,
      'gender': gender,
      'userRole': userRole,
    };
  }
}
