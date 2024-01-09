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
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Your Name'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Your Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Feedback',

                    alignLabelWithHint: true, // Align label text with the start
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
                        ),
                      );
                    } catch (error) {
                      // Display an error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error occurred. Please try again.'),
                        ),
                      );
                    }
                  },
                  child: Text('Submit Feedback'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
