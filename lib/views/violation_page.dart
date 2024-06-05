import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/violation_view_model.dart';
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
          title: Text('Violations'),
        ),
        body: Consumer<ViolationViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              children: [
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      viewModel.errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.violations.length,
                    itemBuilder: (context, index) {
                      Violation violation = viewModel.violations[index];
                      return ListTile(
                        title: Text(violation.date),
                        subtitle: Text(violation.details_report),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                viewModel.date_Controller.text = violation.date;
                                viewModel.details_Controller.text = violation.details_report;
                                viewModel.path_Image = violation.path_image;
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Edit Violation'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: viewModel.date_Controller,
                                          decoration: InputDecoration(labelText: 'Date'),
                                        ),
                                        TextField(
                                          controller: viewModel.details_Controller,
                                          decoration: InputDecoration(labelText: 'Details'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await viewModel.pickImage();
                                          },
                                          child: Text('Select Image'),
                                        ),
                                        if (viewModel.path_Image != null)
                                          Image.memory(viewModel.path_Image!),
                                      ],
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
                                          viewModel.updateViolation(violation);
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
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Add Violation'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: viewModel.date_Controller,
                                decoration: InputDecoration(labelText: 'Date'),
                              ),
                              TextField(
                                controller: viewModel.details_Controller,
                                decoration: InputDecoration(labelText: 'Details'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await viewModel.pickImage();
                                },
                                child: Text('Select Image'),
                              ),
                              if (viewModel.path_Image != null)
                                Image.memory(viewModel.path_Image!),
                            ],
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
                                viewModel.addViolation(userId);
                                Navigator.of(context).pop();
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Violation'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
