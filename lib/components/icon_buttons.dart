import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:nts/theme/custom_theme_data.dart';

class IconButtons extends StatefulWidget {
  const IconButtons(
      {super.key, required this.function, required this.disabled});
  final Function function;
  final bool disabled;

  @override
  State<IconButtons> createState() => _IconButtonsState();
}

class _IconButtonsState extends State<IconButtons> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.disabled) {
          widget.function();
        }
      },
      child: HeroIcon(
        HeroIcons.chevronLeft,
        style: HeroIconStyle.solid,
        color: widget.disabled
            ? BandiColor.gray002Color(context)
            : BandiColor.primaryColor(context),
        size: 24,
      ),
    );
  }
}
