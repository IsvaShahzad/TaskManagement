// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class VerifyEmail extends StatefulWidget {
//   @override
//   State<VerifyEmail> createState() => _VerifyEmailState();
// }
//
// class _VerifyEmailState extends State<VerifyEmail> {
//   bool isverified = false;
//   bool canResendEmail = false;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//
//     isverified = FirebaseAuth.instance.currentUser!.emailVerified;
//
//     if (!isverified) {
//       sendVerificationEmail();
//
//       timer = Timer.periodic(
//         Duration(hours: 1),
//             (_) => checkEmailverified(),
//       );
//     }
//   }
//
//   //when widget is removed from tree
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }
//
//   Future checkEmailverified() async {
//     await FirebaseAuth.instance.currentUser!.reload();
//     setState(() {
//       isverified = FirebaseAuth.instance.currentUser!.emailVerified;
//     });
//
//     if (isverified) timer?.cancel();
//   }
//
//   Future sendVerificationEmail() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser!;
//       await user.sendEmailVerification();
//
//       setState(() => canResendEmail = false);
//       await Future.delayed(Duration(seconds: 5));
//       setState(() => canResendEmail = true);
//     } catch (e) {}
//   }
//
//   @override
//   Widget build(BuildContext context) => Container(
//     decoration: BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage("assets/images/pastel.png"),
//             fit: BoxFit.cover)),
//     child: isverified
//         ? LoginScreen()
//         : Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: Text('verify email'),
//         ),
//         body: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'A verification email has been sent to your account! ',
//                 style: TextStyle(fontSize: 20),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 30),
//               ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size.fromHeight(48),
//                   ),
//                   icon: Icon(Icons.email, size: 25),
//                   label: Text(
//                     'Resent Email',
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   // onPressed: canResendEmail ? sendVerificationEmail :
//                   onPressed: sendVerificationEmail),
//               SizedBox(height: 8),
//               TextButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size.fromHeight(50),
//                   ),
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(fontSize: 24),
//                   ),
//
//                   // onPressed: () => FirebaseAuth.instance.signOut(),
//
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (BuildContext context) =>
//                                 LoginScreen()));
//                   }
//
//                 // onPressed: () => FirebaseAuth.instance.signOut(),
//               ),
//             ],
//           ),
//         )),
//   );
// }