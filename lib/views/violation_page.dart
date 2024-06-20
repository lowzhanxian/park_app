import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/violation_view_model.dart';
import '../helpers/database_help.dart';
import '../models/violation.dart';
import 'package:flutter/services.dart';


class FeedbackPage extends StatelessWidget {
  final int userId;

  FeedbackPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeedbackViewModel()..fetchFeedbacks(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Submit Your Feedback'),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: () async {
          //       await Db_Helper().deleteDatabase();
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(content: Text('Database deleted. Restart the app.')),
          //       );
          //     },
          //   ),
          // ],
        ),
        body: Consumer<FeedbackViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 15),
                    TextField(
                      controller: viewModel.dateController,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        errorText: viewModel.dateError,
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await viewModel.pickDate(context);
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: viewModel.locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        errorText: viewModel.locationError,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: viewModel.contactInfoController,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        errorText: viewModel.contactInfoError,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: viewModel.feedbackTypeController,
                      decoration: InputDecoration(
                        labelText: 'Feedback',
                        errorText: viewModel.feedbackTypeError,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: viewModel.feedbackDetailsController,
                      decoration: InputDecoration(
                        labelText: 'Feedback Details',
                        errorText: viewModel.feedbackDetailsError,
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.addFeedback(userId, context);
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    Divider(height: 30, thickness: 3, color: Colors.white),
                    Text(
                      'History Feedback',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.feedbacks.length,
                      itemBuilder: (context, index) {
                        UserFeedback feedback = viewModel.feedbacks[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(feedback.date),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User: ${feedback.fullName}'),
                                Text('Location: ${feedback.location}'),
                                Text('Contact: ${feedback.contactInfo}'),
                                Text('Feedback Type: ${feedback.feedbackType}'),
                                Text('Details: ${feedback.feedbackDetails}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.edit),
                                //   onPressed: () {
                                //     viewModel.dateController.text = feedback.date;
                                //     viewModel.locationController.text = feedback.location;
                                //     viewModel.contactInfoController.text = feedback.contactInfo;
                                //     viewModel.feedbackTypeController.text = feedback.feedbackType;
                                //     viewModel.feedbackDetailsController.text = feedback.feedbackDetails;
                                //     showDialog(
                                //       context: context,
                                //       builder: (context) => AlertDialog(
                                //         title: Text('Edit Feedback'),
                                //         content: SingleChildScrollView(
                                //           child: Column(
                                //             mainAxisSize: MainAxisSize.min,
                                //             children: [
                                //               TextField(
                                //                 controller: viewModel.dateController,
                                //                 decoration: InputDecoration(
                                //                   labelText: 'Incident Date',
                                //                   errorText: viewModel.dateError,
                                //                 ),
                                //                 onTap: () async {
                                //                   FocusScope.of(context).requestFocus(FocusNode());
                                //                   await viewModel.pickDate(context);
                                //                 },
                                //               ),
                                //               TextField(
                                //                 controller: viewModel.locationController,
                                //                 decoration: InputDecoration(
                                //                   labelText: 'Location',
                                //                   errorText: viewModel.locationError,
                                //                 ),
                                //               ),
                                //               TextField(
                                //                 controller: viewModel.contactInfoController,
                                //                 decoration: InputDecoration(
                                //                   labelText: 'Contact Information',
                                //                   errorText: viewModel.contactInfoError,
                                //                 ),
                                //               ),
                                //               TextField(
                                //                 controller: viewModel.feedbackTypeController,
                                //                 decoration: InputDecoration(
                                //                   labelText: 'Feedback Type',
                                //                   errorText: viewModel.feedbackTypeError,
                                //                 ),
                                //               ),
                                //               TextField(
                                //                 controller: viewModel.feedbackDetailsController,
                                //                 decoration: InputDecoration(
                                //                   labelText: 'Feedback Details',
                                //                   errorText: viewModel.feedbackDetailsError,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //             child: Text('Cancel'),
                                //           ),
                                //           TextButton(
                                //             onPressed: () {
                                //               viewModel.updateFeedback(feedback, context);
                                //               Navigator.of(context).pop();
                                //             },
                                //             child: Text('Save'),
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    viewModel.deleteFeedback(feedback.id!, userId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
