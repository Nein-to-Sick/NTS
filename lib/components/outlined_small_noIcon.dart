import 'package:flutter/material.dart';
import 'package:nts/theme/custom_theme_data.dart';

class OSmallNoIcon extends StatefulWidget {
  const OSmallNoIcon(
      {super.key,
      required this.title,
      required this.function,
      required this.disabled});
  final String title;
  final Function function;
  final bool disabled;

  @override
  State<OSmallNoIcon> createState() => _OSmallNoIconState();
}

class _OSmallNoIconState extends State<OSmallNoIcon> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.disabled) {
          widget.function();
          setState(() {
            clicked = !clicked;
          });
        }
      },
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
              color: widget.disabled
                  ? BandiColor.gray001Color(context)
                  : clicked
                      ? BandiColor.primaryColor(context)
                      : BandiColor.backgroundColor(context),
              border: Border.all(
                color: widget.disabled
                    ? BandiColor.gray001Color(context)
                    : clicked
                        ? BandiColor.primaryColor(context)
                        : BandiColor.gray002Color(context),
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Center(
              child: Text(
                widget.title,
                style: widget.disabled
                    ? BandiFont.small(context)
                        ?.copyWith(color: BandiColor.backgroundColor(context))
                    : clicked
                        ? BandiFont.small(context)?.copyWith(
                            color: BandiColor.backgroundColor(context))
                        : BandiFont.small(context)
                            ?.copyWith(color: BandiColor.gray004Color(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
