class AppUser {
  final String id;
  final String fullName;
  final String specialization;
  final String token;
  final DateTime tokenTime;
  final String email;
  final int age;
  final String gender;
  final String userRole;

  AppUser(
      {required this.id,
      required this.fullName,
      required this.specialization,
      required this.token,
      required this.tokenTime,
      required this.email,
      required this.age,
      required this.gender,
      required this.userRole});

  AppUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        specialization = data['specialization'] ?? "",
        token = data['token'] ?? "",
        tokenTime = data['tokenTime'] != null
            ? data['tokenTime'].toDate()
            : DateTime(2022),
        email = data['email'],
        age = data['age'],
        gender = data['gender'],
        userRole = data['userRole'] ?? "patient";

  Map<String, dynamic> toJson(keyword) {
    return {
      'id': id,
      'fullName': fullName,
      'specialization': specialization,
      'token': token,
      'tokenTime': tokenTime,
      'keyword': keyword,
      'email': email,
      'age': age,
      'gender': gender,
      'userRole': userRole,
    };
  }
}
