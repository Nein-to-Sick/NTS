import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nts/component/firefly.dart';
import 'package:nts/component/navigationToggle.dart';
import 'package:nts/login/login.dart';
import 'package:nts/profile/profile.dart';
import 'package:nts/provider/backgroundController.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider.value(
          value: BackgroundController(),
          child: const Background(),
        ),
      ),
    );
  }
}

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  BackgroundState createState() => BackgroundState();
}

class BackgroundState extends State<Background> {

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final ScrollController scrollController = controller.scrollController;

    return Stack(
      children: [
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          children: [
            Image.asset(
              'assets/back.png',
              fit: BoxFit.cover,
            ),
          ],
        ),
        AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            if (scrollController.offset == 0) {
              return const LoginPage();
            } else if (scrollController.offset == 600) {
              return const HomePage();
            } else if (scrollController.offset == 864) {
              return const ProfilePage();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        AnimatedBuilder(
          animation: scrollController,
          builder: (context, child) {
            if (scrollController.offset != 0) {
              return const NavigationToggle();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const FireFly(),
      ],
    );
  }
}