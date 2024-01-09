

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import 'delete_task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddTaskScreen> {


  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  String icon = "";
  bool showSpinner = false;
  String selectedStatus = "in progress"; // Default value

  @override
  initState() {
    super.initState();
    selectedStatus = 'in progress'; // or 'completed' or 'pending'
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Future<void> sendEmail() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final smtpServer = gmail('isvashaz@gmail.com', 'ncsq nugn gdof vdim');

      final message = Message()
        ..from = Address('isvashaz@gmail.com', 'Isva')
        ..recipients.add(user.email!) // Use the user's email
        ..subject = 'New Task Added!'
        ..text = '''
        Task Details:
        Title: ${titleController.text}
        Description: ${descriptionController.text}
        Status: $selectedStatus
      ''';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (e) {
        print('Error sending email: $e');
      }
    } else {
      print('User is not logged in');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          // Background Image

          ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[
                              700], // Set light grey color for the icon
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 36, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: titleController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Title',
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                              // Explicitly set the label text style
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight
                                    .normal, // Set the desired font weight
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[
                                700], // Set light grey color for the icon
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          height: 40, // Set the desired height
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors
                                  .grey[100], // Set fill color to grey 100
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 0.0),
                                borderRadius: BorderRadius.circular(9.0),
                              ),
                              hintText: 'Enter Task Description',
                              contentPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              DropdownButton<String>(
                                value: selectedStatus,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedStatus = newValue!;
                                  });
                                },
                                items: <String>[
                                  'in progress',
                                  'completed',
                                  'pending'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  showSpinner
                      ? SingleChildScrollView(
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 2),
                        child: const CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation(Colors.black54),
                        )),
                  )
                      : Container(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    width: 170,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.toString().isNotEmpty &&
                            descriptionController.text
                                .toString()
                                .isNotEmpty &&
                            selectedStatus.isNotEmpty) {
                          await sendEmail();
                          saveItemInfo();
                        } else {
                          Fluttertoast.showToast(
                            msg: "Incomplete Information",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 14,
                          );
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteTaskScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        primary: Color(0xFF9370DB),
                      ),
                      child: const Text(
                        "Add",
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }

  String iconName = DateTime.now().millisecond.toString();

  saveItemInfo() async {
    final taskCollection = FirebaseFirestore.instance.collection("Tasks");

    Map<String, dynamic> newTask = {
      "title": titleController.text.toString(),
      "description": descriptionController.text.toString(),
      "status": selectedStatus,
    };

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the user's email from Firestore using the UID
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .get();

        if (userSnapshot.exists) {
          String userEmail = userSnapshot.get("email");
          print(
              "Current User Email: $userEmail"); // Add this line to print the email

          // Add the new task to the AddedTasks array

          // Retrieve existing AddedTasks array from Firestore
          DocumentSnapshot documentSnapshot =
          await taskCollection.doc("addedTasksDoc").get();
          List<Map<String, dynamic>> addedTasks = [];

          if (documentSnapshot.exists) {
            Map<String, dynamic>? documentData =
            documentSnapshot.data() as Map<String, dynamic>?;

            if (documentData != null &&
                documentData.containsKey('AddedTasks')) {
              addedTasks =
              List<Map<String, dynamic>>.from(documentData['AddedTasks']);
            }
          }

          addedTasks.add(newTask);

          // Update the Firestore document with the modified AddedTasks array
          await taskCollection
              .doc("addedTasksDoc")
              .set({"AddedTasks": addedTasks});

          print("Task added to collection 'Tasks' successfully!");
          setState(() {
            // Clearing controllers and updating the UI
            titleController.clear();
            descriptionController.clear();
            statusController.clear();
            showSpinner = false;
            Fluttertoast.showToast(
              msg: "Task Added",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14,
            );
          });
        } else {
          print("User document not found in Firestore");
        }
      } else {
        print('User is not logged in');
      }
    } catch (e) {
      print("Error adding task to Firestore: $e");
    }
  }
}
