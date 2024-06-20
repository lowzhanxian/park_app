import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/database_help.dart';
import '../models/violation.dart'; // Make sure to import the correct model

class FeedbackViewModel extends ChangeNotifier {
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  final contactInfoController = TextEditingController();
  final feedbackTypeController = TextEditingController();
  final feedbackDetailsController = TextEditingController();

  String? dateError;
  String? locationError;
  String? contactInfoError;
  String? feedbackTypeError;
  String? feedbackDetailsError;

  List<UserFeedback> _feedbacks = [];
  List<UserFeedback> get feedbacks => _feedbacks;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _validateInputs() {
    bool isValid = true;

    if (dateController.text.isEmpty) {
      dateError = 'Date Required';
      isValid = false;
    } else {
      dateError = null;
    }

    if (locationController.text.isEmpty) {
      locationError = 'Location Required';
      isValid = false;
    } else {
      locationError = null;
    }

    if (contactInfoController.text.isEmpty) {
      contactInfoError = 'Contact Info Required';
      isValid = false;
    }
    else if(!contactInfoController.text.startsWith('01')){
        contactInfoError='Contact Must Start with 01';
        isValid=false;
    }
    else if (contactInfoController.text.length < 10 || contactInfoController.text.length > 11) {
      contactInfoError = 'Correct Contact Number Format Required';
      isValid = false;
    }

    else {
      contactInfoError = null;
    }

    if (feedbackTypeController.text.isEmpty) {
      feedbackTypeError = 'Feedback Type Required';
      isValid = false;
    } else {
      feedbackTypeError = null;
    }

    if (feedbackDetailsController.text.isEmpty) {
      feedbackDetailsError = 'Details Required';
      isValid = false;
    } else {
      feedbackDetailsError = null;
    }

    notifyListeners();
    return isValid;
  }

  Future<void> fetchFeedbacks(int userId) async {
    _feedbacks = await Db_Helper().getFeedbackDetails(userId);
    notifyListeners();
  }

  Future<void> addFeedback(int userId, BuildContext context) async {
    if (!_validateInputs()) return;

    UserFeedback newFeedback = UserFeedback(
      userId: userId,
      date: dateController.text,
      location: locationController.text,
      contactInfo: contactInfoController.text,
      feedbackType: feedbackTypeController.text,
      feedbackDetails: feedbackDetailsController.text,
      fullName: await _fetchUsername(userId),
    );

    await Db_Helper().insertFeedbackDetails(newFeedback);
    dateController.clear();
    locationController.clear();
    contactInfoController.clear();
    feedbackTypeController.clear();
    feedbackDetailsController.clear();
    fetchFeedbacks(userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback submitted successfully!')),
    );
  }

  Future<void> updateFeedback(UserFeedback feedback, BuildContext context) async {
    if (!_validateInputs()) return;

    feedback.date = dateController.text;
    feedback.location = locationController.text;
    feedback.contactInfo = contactInfoController.text;
    feedback.feedbackType = feedbackTypeController.text;
    feedback.feedbackDetails = feedbackDetailsController.text;

    await Db_Helper().updateFeedbackDetails(feedback);
    fetchFeedbacks(feedback.userId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback updated successfully!')),
    );
  }

  Future<void> deleteFeedback(int id, int userId) async {
    await Db_Helper().deleteFeedbackDetails(id);
    fetchFeedbacks(userId);
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime threeDaysAgo = now.subtract(Duration(days: 2));
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: threeDaysAgo,
      lastDate: now,
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      notifyListeners();
    }
  }

  Future<String> _fetchUsername(int userId) async {
    final user = await Db_Helper().getUserById(userId);
    return user?.full_name ?? 'Unknown';
  }

  @override
  void dispose() {
    dateController.dispose();
    locationController.dispose();
    contactInfoController.dispose();
    feedbackTypeController.dispose();
    feedbackDetailsController.dispose();
    super.dispose();
  }
}
