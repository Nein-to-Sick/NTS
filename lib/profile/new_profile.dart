import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';
import 'package:nts/loading/loading_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemeColors.primaryColor,
      appBar: AppBar(
        title: const Text('프로필 테스트 페이지'),
      ),
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 75,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                loading = !loading;
              });
            },
            child: const Text('WoooooooooW'),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: (loading) ? const MyCatLoadingPage() : null,
          ),
        ],
      )),
    );
  }
}
