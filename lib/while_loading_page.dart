import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

class MyLoadingPage extends StatelessWidget {
  const MyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: MyThemeColors.whiteColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
