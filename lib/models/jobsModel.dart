class Jobs {
  String id;
  String title;
  String content;
  String min_experience;
  String max_experience;
  String minimum;
  String maximum;
  String state;
  String city;
  List skill_id;
  String company;
  String created_hours;
  String company_profile_pic;
  String company_name;
  String position_available;
  String hiring_timeline;
  String deadline;
  String job_type;
  String job_schedule;
  String quick_hiring_time;
  String suplement_pay;
  String company_id;
  String qualification;
  bool applied;

  Jobs(
      {required this.id,
        required this.title,
        required this.content,
        required this.min_experience,
        required this.max_experience,
        required this.minimum,
        required this.maximum,
        required this.state,
        required this.city,
        required this.skill_id,
        required this.company,
        required this.created_hours,
        required this.company_profile_pic,
        required this.company_name,
        required this.position_available,
        required this.hiring_timeline,
        required this.deadline,
        required this.job_type,
        required this.job_schedule,
        required this.quick_hiring_time,
        required this.suplement_pay,
        required this.qualification,
        required this.applied,
        required this.company_id,
      });

  factory Jobs.fromJson(Map<String, dynamic> json) {
    return Jobs(
      id: json['id'].toString(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      min_experience: json['min_experience'].toString(),
      max_experience: json['max_experience'].toString(),
      minimum: json['minimum'].toString(),
      maximum: json['maximum'].toString(),
      state: json['state'].toString(),
      city: json['city'].toString(),
      skill_id: json['skill_id']!! as List,
      company: json['company'].toString(),
      created_hours: json['created_hours'].toString(),
      company_profile_pic: json['company_profile_pic'].toString(),
      company_name: json['company_name'].toString(),
      position_available: json['position_available'].toString(),
      hiring_timeline: json['hiring_timeline'].toString(),
      deadline: json['deadline'].toString(),
      job_type: json['job_type'].toString(),
      job_schedule: json['job_schedule'].toString(),
      quick_hiring_time: json['quick_hiring_time'].toString(),
      suplement_pay: json['suplement_pay'].toString(),
      qualification: json['qualification'].toString(),
      company_id: json['company_id'].toString(),
      applied: json['applied'],
    );
  }
}