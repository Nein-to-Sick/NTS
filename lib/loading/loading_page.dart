import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nts/Theme/theme_colors.dart';

class MyLoadingPage extends StatelessWidget {
  const MyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SpinKitSpinningCircle(
          itemBuilder: (context, index) {
            return const Center(
              child: Text(
                "🐶",
                style: TextStyle(fontSize: 40),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyFireFlyProgressbarAndDotPainter extends CustomPainter {
  final double rotationAngle;
  final double progress;

  MyFireFlyProgressbarAndDotPainter({
    required this.rotationAngle,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final Paint circlePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final Paint arcPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final Paint glowPaint = Paint()
      ..color = Colors.yellow.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    final Paint dotPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final Paint dotPaintHead = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    const double startAngle = -pi / 2;
    final double sweepAngle = 2 * pi * progress;

    // 원형 프로그래스바 그리기
    canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);

    // 빛나는 듯한 원 그리기
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle + rotationAngle * pi / 180,
      sweepAngle,
      false,
      glowPaint,
    );

    // 원 그리기 (프로그래스바 앞쪽 끝 부분에 위치)
    double dotAngle = startAngle + sweepAngle + rotationAngle * pi / 180;
    double dotX = centerX + (radius) * cos(dotAngle);
    double dotY = centerY + (radius) * sin(dotAngle);
    canvas.drawCircle(Offset(dotX, dotY), 17, dotPaint); // 원의 반지름은 20.0으로 설정

    // 원 그리기 (프로그래스바 앞쪽 끝 부분에 위치)
    canvas.drawCircle(Offset(dotX, dotY), 6, dotPaintHead); // 원의 반지름은 7.5으로 설정

    // 원호 그리기
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle + rotationAngle * pi / 180,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyFireFlyProgressbar extends StatefulWidget {
  final double progress;

  const MyFireFlyProgressbar({super.key, required this.progress});

  @override
  MyFireFlyProgressbarState createState() => MyFireFlyProgressbarState();
}

class MyFireFlyProgressbarState extends State<MyFireFlyProgressbar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemeColors.blackColor,
      appBar: AppBar(
        title: const Text('로딩 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SizedBox(
                  height: 135,
                  width: 135,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CustomPaint(
                      painter: MyFireFlyProgressbarAndDotPainter(
                        rotationAngle: _animation.value * 360,
                        progress: widget.progress,
                      ),
                      child: Container(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              '로딩 중...',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
