import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homepage_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(

          ),
        ),
      ),
      home: AuthScreen(),
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(role: 'admin'),
                  ),
                );
              },
              child: Text('Login as Admin'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(role: 'manager'),
                  ),
                );
              },
              child: Text('Login as Manager'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(role: 'user'),
                  ),
                );
              },
              child: Text('Login as User'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final String role;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({required this.role});

  Future<void> _login(BuildContext context) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(authResult.user!.uid).get();

      if (userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in successfully as $role'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User does not exist or incorrect credentials.'),
          ),
        );
      }
    } catch (e) {
      print('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging in. Please try again.'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {


    void _navigateToSignUpScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen(role: role),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login as $role'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _navigateToSignUpScreen,
              child: Text('Sign Up as $role'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  final String role;

  SignUpScreen({required this.role});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance.collection('Users').doc(authResult.user!.uid).set({
        'email': emailController.text,
        'role': widget.role,
        'password': passwordController.text,
      });

      print('Successfully signed up as ${widget.role}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed up successfully as ${widget.role}'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageScreen(),
        ),
      );
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as ${widget.role}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: Text('Sign Up as ${widget.role}'),
            ),
          ],
        ),
      ),
    );
  }
}
