import 'dart:math';
import 'package:flutter/material.dart';

class FireFly extends StatefulWidget {
  const FireFly({super.key});

  @override
  FireFlyState createState() => FireFlyState();
}

class FireFlyState extends State<FireFly> with TickerProviderStateMixin {
  int fireFlyCount = 30;
  late List<AnimationController> controller = [];
  List<Animation<double>> animation = [];

  List<AnimationController> blurController = [];
  List<Animation<double>> blurAnimation = [];

  final List<Duration> _animationDurations = []; // 움직임 시간
  final List<Duration> _blurDurations = []; // 반짝이 시간

  final List<double> _beginBlurValue = []; // 블러 작은 크기
  final List<double> _endBlurValue = []; // 블러 큰 크기
  final List<double> _size = []; // 동그라미 크기

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < fireFlyCount; i++) {
      int randomSeconds = Random().nextInt(21) + 30;
      _animationDurations.add(Duration(seconds: randomSeconds));

      int randomMilliseconds = Random().nextInt(1001) + 1000;
      _blurDurations.add(Duration(milliseconds: randomMilliseconds));

      double randomDouble = Random().nextDouble() * 1 + 2;
      _beginBlurValue.add(randomDouble);
      randomDouble = Random().nextDouble() * 3 + 3;
      _endBlurValue.add(randomDouble);
      randomDouble = Random().nextDouble() * 9 + 3;
      _size.add(randomDouble);

      controller.add(
          AnimationController(vsync: this, duration: _animationDurations[i]));
      Animation<double> curvedAnimation =
      CurvedAnimation(parent: controller[i], curve: Curves.ease)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controller[i].reverse();
          } else if (status == AnimationStatus.dismissed) {
            controller[i].forward();
          }
        });
      animation.add(curvedAnimation);
      controller[i].repeat();
      blurController
          .add(AnimationController(vsync: this, duration: _blurDurations[i]));
      blurController[i].repeat(reverse: true);
      blurAnimation.add(Tween<double>(
          begin: _beginBlurValue[i],
          end: _endBlurValue[i])
          .animate(blurController[i]));
    }
  }



  // newX and newY starting positions
  final List<double> _startX = [];
  final List<double> _startY = [];
  final List<double> onTwo = [];
  final List<int> hundred = [];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Generate random starting positions
    for (int i = 0; i < fireFlyCount; i++) {
      _startX.add(Random().nextDouble() * screenWidth);
      _startY.add(Random().nextDouble() * screenHeight);
      onTwo.add(Random().nextInt(3) + 1);
      hundred.add(Random().nextInt(141) + 10);
    }

    return SafeArea(
      child: Stack(
        children: [
          for (int i = 0; i < fireFlyCount; i++)
            AnimatedBuilder(
              animation: animation[i],
              builder: (context, child) {
                double value = animation[i].value;
                double newX = _startX[i] + hundred[i] * sin(value * pi);
                double newY = _startY[i] + hundred[i] * sin((value * onTwo[i]) * pi);
                return Transform.translate(
                  offset: Offset(newX, newY),
                  child: CustomPaint(
                    size: Size(_size[i],
                        _size[i]),
                    foregroundPainter: CircleBlurPainter(
                        circleWidth: 7, blurSigma: blurAnimation[i].value),
                  ),
                );
              },
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < fireFlyCount; i++) {
      controller[i].dispose();
      blurController[i].dispose();
    }
    super.dispose();
  }
}

class CircleBlurPainter extends CustomPainter {
  CircleBlurPainter({required this.circleWidth, required this.blurSigma});

  double circleWidth;
  double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}