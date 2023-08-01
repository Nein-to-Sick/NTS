import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/backgroundController.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                controller.movePage(600);
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ),
        ),
      ],
    );
  }
}
