import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

import '../provider/backgroundController.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BackgroundController>(context);
    final ScrollController scrollController = controller.scrollController;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),

      ],
    );
  }
}
