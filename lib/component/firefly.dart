import 'dart:math';
import 'package:flutter/material.dart';

class FireFly extends StatefulWidget {
  const FireFly({super.key});

  @override
  FireFlyState createState() => FireFlyState();
}

class FireFlyState extends State<FireFly> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late AnimationController _controller6;

  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;
  late Animation<double> _animation6;

  late AnimationController _blurController1;
  late Animation<double> _blurAnimation1;
  late AnimationController _blurController2;
  late Animation<double> _blurAnimation2;
  late AnimationController _blurController3;
  late Animation<double> _blurAnimation3;
  late AnimationController _blurController4;
  late Animation<double> _blurAnimation4;
  late AnimationController _blurController5;
  late Animation<double> _blurAnimation5;
  late AnimationController _blurController6;
  late Animation<double> _blurAnimation6;


  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 50),
    );
    _controller4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );
    _controller5 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );
    _controller6 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );

    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.ease)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller1.forward();
        }
      });
    _animation2 = CurvedAnimation(parent: _controller2, curve: Curves.ease)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller2.forward();
        }
      });
    _animation3 = CurvedAnimation(parent: _controller3, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller3.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller3.forward();
        }
      });
    _animation4 = CurvedAnimation(parent: _controller4, curve: Curves.ease)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller4.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller4.forward();
        }
      });
    _animation5 = CurvedAnimation(parent: _controller5, curve: Curves.ease)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller5.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller5.forward();
        }
      });
    _animation6 = CurvedAnimation(parent: _controller6, curve: Curves.ease)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller6.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller6.forward();
        }
      });
    _controller1.repeat();
    _controller2.repeat();
    _controller3.repeat();
    _controller4.repeat();
    _controller5.repeat();
    _controller6.repeat();


    _blurController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _blurAnimation1 = Tween<double>(begin: 3.0, end: 5.0).animate(_blurController1);

    _blurController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _blurAnimation2 = Tween<double>(begin: 3.0, end: 6.0).animate(_blurController2);

    _blurController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _blurAnimation3 = Tween<double>(begin: 2.0, end: 4.0).animate(_blurController3);

    _blurController4 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _blurAnimation4 = Tween<double>(begin: 3.0, end: 6.0).animate(_blurController4);

    _blurController5 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _blurAnimation5 = Tween<double>(begin: 3.0, end: 6.0).animate(_blurController5);

    _blurController6 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _blurAnimation6 = Tween<double>(begin: 2.5, end: 6.0).animate(_blurController6);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation1,
            builder: (context, child) {
              double value = _animation1.value;
              double newX = MediaQuery.of(context).size.width / 2 - 50 + 100 * sin(value * pi);
              double newY = 10 * sin((value * 2) * pi);
              return Transform.translate(
                offset: Offset(newX, newY),
                child: CustomPaint(
                  foregroundPainter: CircleBlurPainter(circleWidth: 7, blurSigma: _blurAnimation1.value),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation2,
            builder: (context, child) {
              double value = _animation2.value;
              double newX = 20 + 100 * sin(value * pi);
              double newY = MediaQuery.of(context).size.height * 0.17 + 100 * sin((value * 2) * pi);
              return Transform.translate(
                offset: Offset(newX, newY),
                child: CustomPaint(
                  foregroundPainter: CircleBlurPainter(circleWidth: 10, blurSigma: _blurAnimation2.value),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation3,
            builder: (context, child) {
              double value = _animation3.value;
              double newX = MediaQuery.of(context).size.width - 40 + 30 * sin((value * 2) * pi);
              double newY = MediaQuery.of(context).size.height * 0.23 + 10 * sin((value * 2) * pi);
              return Transform.translate(
                  offset: Offset(newX, newY),
                  child: CustomPaint(
                    foregroundPainter: CircleBlurPainter(circleWidth: 6, blurSigma: _blurAnimation3.value),
                  ));
            },
          ),
          AnimatedBuilder(
            animation: _animation4,
            builder: (context, child) {
              double value = _animation4.value;
              double newX = MediaQuery.of(context).size.width * 0.6 + 150 * sin(value * pi);
              double newY = MediaQuery.of(context).size.height * 0.5 + 80 * sin((value) * pi);
              return Transform.translate(
                  offset: Offset(newX, newY),
                  child: CustomPaint(
                    foregroundPainter: CircleBlurPainter(circleWidth: 15, blurSigma: _blurAnimation4.value),
                  ));
            },
          ),
          AnimatedBuilder(
            animation: _animation5,
            builder: (context, child) {
              double value = _animation5.value;
              double newX = MediaQuery.of(context).size.width * 0.2 + 50 * sin((value) * pi);
              double newY = MediaQuery.of(context).size.height * 0.8;
              return Transform.translate(
                  offset: Offset(newX, newY),
                  child: CustomPaint(
                    foregroundPainter: CircleBlurPainter(circleWidth: 14, blurSigma: _blurAnimation5.value),
                  ));
            },
          ),
          AnimatedBuilder(
            animation: _animation6,
            builder: (context, child) {
              double newX = MediaQuery.of(context).size.width * 0.9;
              double newY = MediaQuery.of(context).size.height * 0.75;
              return Transform.translate(
                  offset: Offset(newX, newY),
                  child: CustomPaint(
                    foregroundPainter: CircleBlurPainter(circleWidth: 11, blurSigma: _blurAnimation6.value),
                  ));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();


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
      ..style = PaintingStyle.stroke
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