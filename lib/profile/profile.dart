import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nts/profile/settings.dart';
import 'package:provider/provider.dart';

import '../provider/backgroundController.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);

    void signUserOut() {
      FirebaseAuth.instance.signOut();
      controller.movePage(0);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => ProfileSettings(),
                );
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: Center(
          child: Text(
        "Profile",
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
