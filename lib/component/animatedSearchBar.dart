import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/provider/searchBarController.dart';
import 'package:provider/provider.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({Key? key}) : super(key: key);

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SearchBarController>(context);
    bool folded = controller.folded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: !folded ? 35 : MediaQuery.of(context).size.width - 40,
      // height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff5E5E5E).withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: folded
                      ? const TextField(
                    cursorColor: Colors.white,
                    autofocus: true,
                    decoration: InputDecoration(border: InputBorder.none),
                  )
                      : null)),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: HeroIcon(
                    HeroIcons.magnifyingGlass,
                    style: HeroIconStyle.outline,
                    color: Color(0xffB0B0B0),
                  ),
                ),
                onTap: () {
                  controller.fold();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}