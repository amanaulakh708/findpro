class Login {
  String userID;
  String link;
  String name;
  String avatar;
  String email;
  String dob;
  String phone;


  Login(
      {required this.userID,
      required this.link,
        required this.name,
        required this.avatar,
        required this.email,
        required this.dob,
        required this.phone,

      });

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      userID: json['userID'].toString(),
      link: json['link'].toString(),
      name: json['name'].toString(),
      avatar: json['avatar'].toString(),
      email: json['email'].toString(),
      dob: json['dob'].toString(),
      phone: json['phone'].toString(),
    );
  }
}