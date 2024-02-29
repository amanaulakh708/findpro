class Award {
  String id;
  String title;



  Award(
      {required this.id,
        required this.title,

      });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'].toString(),
      title: json['title'].toString(),
    );
  }
}