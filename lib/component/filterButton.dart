import 'package:flutter/material.dart';
import 'package:nts/Theme/theme_colors.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({Key? key, required this.title, required this.function})
      : super(key: key);

  final String title;
  final Function function;

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    _animation =
        Tween<double>(begin: 0, end: -0.5).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });

        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        widget.function();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isExpanded ? Colors.white.withOpacity(0.9) : MyThemeColors.myGreyscale.shade700.withOpacity(0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 5.0, 11, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _isExpanded ? MyThemeColors.myGreyscale[900] : MyThemeColors.myGreyscale.shade300,
                  fontSize: 13,
                ),
              ),
              RotationTransition(
                turns: _animation,
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: _isExpanded ? MyThemeColors.myGreyscale[900] : MyThemeColors.myGreyscale.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
