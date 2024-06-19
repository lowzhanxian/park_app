class UserFeedback {
  int? id;
  int userId;
  String fullName;
  String date;
  String location;
  String contactInfo;
  String feedbackType;
  String feedbackDetails;

  UserFeedback({
    this.id,
    required this.userId,
    required this.fullName,
    required this.date,
    required this.location,
    required this.contactInfo,
    required this.feedbackType,
    required this.feedbackDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'date': date,
      'location': location,
      'contact_info': contactInfo,
      'feedback_type': feedbackType,
      'feedback_details': feedbackDetails,
    };
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    return UserFeedback(
      id: map['id'],
      userId: map['user_id'],
      fullName: map['full_name'],
      date: map['date'],
      location: map['location'],
      contactInfo: map['contact_info'],
      feedbackType: map['feedback_type'],
      feedbackDetails: map['feedback_details'],
    );
  }
}
