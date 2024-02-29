class profile {
  String id;
  String name;
  String dob;
  String profileImage;
  String category;
  String category_id;
  String parent_id;
  String totalReview;
  String average_rating;
  String link;
  String mobile;
  String phonestatus;
  String totalExperience;
  String minimumCharges;
  String email;
  String address;
  String city_name;
  String state_name;
  String country;
  String pincode;
  String description;
  String longitude;
  String latitude;
  List education;
  List experience;
  List ourServices;
  List awardAchivement;
  List feedback;
  List memberships;
  List openingHours;
  List gallery;


  profile(
      {required this.id,
        required this.name,
        required this.dob,
        required this.profileImage,
        required this.category,
        required this.category_id,
        required this.parent_id,
        required this.totalReview,
        required this.average_rating,
        required this.link,
        required this.mobile,
        required this.phonestatus,
        required this.totalExperience,
        required this.minimumCharges,
        required this.email,
        required this.address,
        required this.city_name,
        required this.state_name,
        required this.country,
        required this.pincode,
        required this.longitude,
        required this.latitude,
        required this.description,
        required this.education,
        required this.experience,
        required this.ourServices,
        required this.awardAchivement,
        required this.feedback,
        required this.memberships,
        required this.openingHours,
        required this.gallery,

      });

  factory profile.fromJson(Map<String, dynamic> json) {
    return profile(
      id: json['id'].toString(),
      name: json['name'].toString(),
      dob: json['dob'].toString(),
      profileImage: json['profileImage'].toString(),
      category: json['category'].toString(),
      category_id: json['category_id'].toString(),
      parent_id: json['parent_id'].toString(),
      totalReview: json['totalReview'].toString(),
      average_rating: json['average_rating'].toString(),
      link: json['link'].toString(),
      mobile: json['mobile'].toString(),
      phonestatus: json['phonestatus'].toString(),
      totalExperience: json['totalExperience'].toString(),
      minimumCharges: json['minimumCharges'].toString(),
      email: json['email'].toString(),
      address: json['address'].toString(),
      city_name: json['city_name'].toString(),
      state_name: json['state_name'].toString(),
      country: json['country'].toString(),
      pincode: json['pincode'].toString(),
      longitude: json['longitude'].toString(),
      latitude: json['latitude'].toString(),
      description: json['description'].toString(),
      education: json['education'] as List,
      experience: json['experience'] as List,
      ourServices: json['ourServices'] as List,
      awardAchivement: json['awardAchivement']as List,
      feedback: json['feedback']as List,
      memberships: json['memberships']as List,
      openingHours: json['openingHours']as List,
      gallery: json['gallery']as List,
    );
  }
}
