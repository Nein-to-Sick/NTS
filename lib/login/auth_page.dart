import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/home/home.dart';
import 'package:nts/login/login.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             //user is logged in
//             // return const BridgPage();
//             return const HomePage();
//           } else {
//             //user is not logged in
//             return const LoginPage();
//           }
//         },
//       ),
//     );
//   }
// }

class AuthPage {
  int checkAuthState() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, return 600
      return 600;
    } else {
      // User is not logged in, return 0
      return 0;
    }
  }
}
