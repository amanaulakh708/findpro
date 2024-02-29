class AplliedJobs {
  String id;
  String title;
  String created_hours;
  String company_profile_pic;
  String company_name;
  String company_id;

  AplliedJobs(
      {required this.id,
        required this.title,
        required this.created_hours,
        required this.company_profile_pic,
        required this.company_name,
        required this.company_id,
      });

  factory AplliedJobs.fromJson(Map<String, dynamic> json) {
    return AplliedJobs(
      id: json['id'].toString(),
      title: json['title'].toString(),
      created_hours: json['created_hours'].toString(),
      company_profile_pic: json['company_profile_pic'].toString(),
      company_name: json['company_name'].toString(),
      company_id: json['company_id'].toString(),
    );
  }
}