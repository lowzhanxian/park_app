import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/violation_view_model.dart';
import '../helpers/database_help.dart';
import '../models/violation.dart';

class ViolationPage extends StatelessWidget {
  final int userId;

  ViolationPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ViolationViewModel()..fetchViolations(userId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Submit Violation Feedback'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await Db_Helper().deleteDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Database deleted. Restart the app.')),
                );
              },
            ),
          ],
        ),
        body: Consumer<ViolationViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 16),
                    TextField(
                      controller: viewModel.date_Controller,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        errorText: viewModel.dateError,
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await viewModel.pickDate(context);
                      },
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: viewModel.carColor_Controller,
                      decoration: InputDecoration(
                        labelText: 'Car Color',
                        errorText: viewModel.carColorError,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: viewModel.carPlate_Controller,
                      decoration: InputDecoration(
                        labelText: 'Car Plate',
                        errorText: viewModel.carPlateError,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: viewModel.carType_Controller,
                      decoration: InputDecoration(
                        labelText: 'Car Type',
                        errorText: viewModel.carTypeError,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: viewModel.details_Controller,
                      decoration: InputDecoration(
                        labelText: 'Details',
                        errorText: viewModel.detailsError,
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.addViolation(userId, context);
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
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
                    Divider(height: 30, thickness: 5, color: Colors.blueAccent),
                    Text(
                      'Submitted Feedbacks',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.violations.length,
                      itemBuilder: (context, index) {
                        Violation violation = viewModel.violations[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(violation.date),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('User: ${violation.full_name}'),
                                Text('Car Color: ${violation.car_color}'),
                                Text('Car Plate: ${violation.car_plate}'),
                                Text('Car Type: ${violation.car_type}'),
                                Text('Details: ${violation.details_report}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    viewModel.date_Controller.text = violation.date;
                                    viewModel.carColor_Controller.text = violation.car_color;
                                    viewModel.carPlate_Controller.text = violation.car_plate;
                                    viewModel.carType_Controller.text = violation.car_type;
                                    viewModel.details_Controller.text = violation.details_report;
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Edit Violation'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                controller: viewModel.date_Controller,
                                                decoration: InputDecoration(
                                                  labelText: 'Date',
                                                  errorText: viewModel.dateError,
                                                ),
                                                onTap: () async {
                                                  FocusScope.of(context).requestFocus(FocusNode());
                                                  await viewModel.pickDate(context);
                                                },
                                              ),
                                              TextField(
                                                controller: viewModel.carColor_Controller,
                                                decoration: InputDecoration(
                                                  labelText: 'Car Color',
                                                  errorText: viewModel.carColorError,
                                                ),
                                              ),
                                              TextField(
                                                controller: viewModel.carPlate_Controller,
                                                decoration: InputDecoration(
                                                  labelText: 'Car Plate',
                                                  errorText: viewModel.carPlateError,
                                                ),
                                              ),
                                              TextField(
                                                controller: viewModel.carType_Controller,
                                                decoration: InputDecoration(
                                                  labelText: 'Car Type',
                                                  errorText: viewModel.carTypeError,
                                                ),
                                              ),
                                              TextField(
                                                controller: viewModel.details_Controller,
                                                decoration: InputDecoration(
                                                  labelText: 'Details',
                                                  errorText: viewModel.detailsError,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              viewModel.updateViolation(violation, context);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Save'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    viewModel.deleteViolation(violation.id!, userId);
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
