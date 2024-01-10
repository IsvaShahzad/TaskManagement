import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Feedback',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedbackScreen(),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  double responsivenessRating = 5.0; // Default rating

  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Give us your valued feedback',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.purple[700], // Change text color
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    border: InputBorder.none, // No border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: Colors
                          .grey[500], // Change the color of the label text
                    ), // Add background color
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Your Email',
                    border: InputBorder.none, // No border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: Colors
                          .grey[500], // Change the color of the label text
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Feedback',
                    border: InputBorder.none, // No border
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: Colors
                          .grey[500], // Change the color of the label text
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 25),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Responsiveness Rating:'),
                    Slider(
                      value: responsivenessRating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      onChanged: (value) {
                        setState(() {
                          responsivenessRating = value;
                        });
                      },
                      label: responsivenessRating.toString(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Save feedback to Firestore
                      await feedbackCollection.add({
                        'name': nameController.text,
                        'email': emailController.text,
                        'feedback': feedbackController.text,
                        'responsivenessRating': responsivenessRating,
                      });

                      // Reset text controllers and rating
                      nameController.clear();
                      emailController.clear();
                      feedbackController.clear();
                      setState(() {
                        responsivenessRating = 3.0; // Reset to default rating
                      });

                      // Display a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Feedback submitted successfully'),
                          backgroundColor: Colors.blue, // Change snackbar color
                        ),
                      );
                    } catch (error) {
                      // Display an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error occurred. Please try again.'),
                          backgroundColor: Colors.red, // Change snackbar color
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 12, horizontal: 60), // Adjust padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(4.0), // Adjust corner radius
                    ),
                  ),
                  child: Text(
                    'Submit Feedback',
                    style: TextStyle(fontSize: 16), // Adjust font size
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
