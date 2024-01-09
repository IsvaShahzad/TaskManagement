import 'package:ezi_taskmanager/screens/delete_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_task.dart';
import 'auth_screen.dart';
import 'feedback_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePageScreen(),
    );
  }
}

class HomePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      // Implement your logout logic here
                      // Example: Sign out the user and navigate to the authentication screen
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  GridTileWidget(
                    title: 'Add Task',
                    icon: Icons.add,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddTaskScreen()),
                      );
                    },
                  ),
                  GridTileWidget(
                    title: 'All Tasks',
                    icon: Icons.list,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DeleteTaskScreen()),
                      );
                    },
                  ),
                  GridTileWidget(
                    title: 'Feedback',
                    icon: Icons.feedback,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FeedbackScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;

  const GridTileWidget({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.0, color: Colors.purple),
              SizedBox(height: 8.0),
              Text(title,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}





