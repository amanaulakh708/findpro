class Search {
  String id;
  String title;
  String content;
  List skill_id;
  String company_id;
  String deadline;
  String position_available;
  String job_type;
  String job_schedule;
  String quick_hiring_time;
  String hiring_timeline;
  String minimum;
  String maximum;
  String suplement_pay;
  String min_experience;
  String max_experience;
  String qualification;
  String city;
  String state;
  bool applied;
  String company_profile_pic;
  String company_name;
  String created_hours;
  String type;
  String name;
  String profileImage;
  String category;
  String rating;
  String link;
  String average_rating;

  Search(
      {
        required this.id,
        required this.title,
        required this.content,
        required this.skill_id,
        required this.company_id,
        required this.deadline,
        required this.position_available,
        required this.job_type,
        required this.job_schedule,
        required this.quick_hiring_time,
        required this.hiring_timeline,
        required this.minimum,
        required this.maximum,
        required this.suplement_pay,
        required this.min_experience,
        required this.max_experience,
        required this.qualification,
        required this.city,
        required this.state,
        required this.applied,
        required this.company_profile_pic,
        required this.company_name,
        required this.created_hours,
        required this.type,
        required this.name,
        required this.profileImage,
        required this.category,
        required this.rating,
        required this.link,
        required this.average_rating,
      });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json['id'].toString(),
      title: json['title'].toString(),
      content: json['content'].toString(),
      skill_id: json['skill_id']!! as List,
      company_id: json['company_id'].toString(),
      deadline: json['deadline'].toString(),
      position_available: json['position_available'].toString(),
      job_type: json['job_type'].toString(),
      job_schedule: json['job_schedule'].toString(),
      quick_hiring_time: json['quick_hiring_time'].toString(),
      hiring_timeline: json['hiring_timeline'].toString(),
      minimum: json['minimum'].toString(),
      maximum: json['maximum'].toString(),
      suplement_pay: json['suplement_pay'].toString(),
      min_experience: json['min_experience'].toString(),
      max_experience: json['max_experience'].toString(),
      qualification: json['qualification'].toString(),
      city: json['city'].toString(),
      state: json['state'].toString(),
      applied: json['applied'],
      company_profile_pic: json['company_profile_pic'].toString(),
      company_name: json['company_name'].toString(),
      created_hours: json['created_hours'].toString(),
      type: json['type'].toString(),
      name: json['name'].toString(),
      profileImage: json['profileImage'].toString(),
      category: json['category'].toString(),
      rating: json['rating'].toString(),
      link: json['link'].toString(),
      average_rating: json['average_rating'].toString(),



    );
  }
}