import 'dart:async';
import 'dart:math' as math;
import 'package:ai_doctor_system/core/theme/color_scheme.dart';
import 'package:ai_doctor_system/shared/services/ai_progress_service.dart';
import 'package:flutter/material.dart';

class MedicalAiLoadingIndicator extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final String? initialText;

  const MedicalAiLoadingIndicator({
    super.key,
    this.size = 120,
    this.primaryColor = const Color(0xFF0DC9B2),
    this.secondaryColor = const Color(0xFF007AFF),
    this.initialText,
  });

  @override
  State<MedicalAiLoadingIndicator> createState() =>
      _MedicalAiLoadingIndicatorState();
}

class _MedicalAiLoadingIndicatorState extends State<MedicalAiLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _typingController;
  late Animation<double> _typingAnimation;

  String _currentText = "";
  final AIProgressService _progressService = AIProgressService();
  Timer? _messageDelayTimer;

  @override
  void initState() {
    super.initState();
    _currentText = widget.initialText ?? "";

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();

    _typingController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _currentText.length * 50 + 500),
    );

    _typingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _typingController,
      curve: Curves.easeInOut,
    ));

    // Listen to message changes from AI progress service
    _progressService.messageStream.listen((newMessage) {
      if (mounted) {
        // Cancel any existing delay timer
        _messageDelayTimer?.cancel();

        // Wait for current typing animation to complete, then wait additional time
        _messageDelayTimer = Timer(
          Duration(
              milliseconds: _currentText.length * 50 +
                  800), // Wait for typing + 0.8 seconds
          () {
            if (mounted) {
              setState(() {
                _currentText = newMessage;
              });
              _restartTypingAnimation();
            }
          },
        );
      }
    });

    // Start the initial typing animation
    _startTypingAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the context for localized AI progress messages
    _progressService.setContext(context);
  }

  void _startTypingAnimation() {
    _typingController.reset();
    _typingController.forward();
  }

  void _restartTypingAnimation() {
    _typingController.reset();
    _typingController.duration =
        Duration(milliseconds: _currentText.length * 50 + 500);
    _typingController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _typingController.dispose();
    _messageDelayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return CustomPaint(
                  painter: _AiMedicalPainter(
                    animationValue: _controller.value,
                    primaryColor: widget.primaryColor,
                    secondaryColor: widget.secondaryColor,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _typingAnimation,
            builder: (context, child) {
              final textLength =
                  (_currentText.length * _typingAnimation.value).round();
              final displayText = _currentText.substring(0, textLength);
              final showCursor = (textLength < _currentText.length) ||
                  (_typingAnimation.value < 1.0 &&
                      textLength == _currentText.length);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColorScheme.secondary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  if (showCursor)
                    AnimatedOpacity(
                      opacity:
                          (math.sin(_typingAnimation.value * math.pi * 8) + 1) /
                              2,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 2,
                        height: 20,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                          color: AppColorScheme.secondary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AiMedicalPainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color secondaryColor;

  _AiMedicalPainter({
    required this.animationValue,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Outer AI pulse ring
    final pulsePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.1 + (animationValue * 0.2)),
          secondaryColor.withOpacity(
              0.4 + (math.sin(animationValue * math.pi * 2) * 0.3)),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(
        center,
        radius * (0.9 + 0.1 * math.sin(animationValue * math.pi * 2)),
        pulsePaint);

    // AI neural dots
    final dotCount = 12;
    for (int i = 0; i < dotCount; i++) {
      final angle = (i / dotCount) * 2 * math.pi + animationValue * 2 * math.pi;
      final dotOffset = Offset(
        center.dx + math.cos(angle) * radius * 0.6,
        center.dy + math.sin(angle) * radius * 0.6,
      );
      final dotPaint = Paint()
        ..color = Color.lerp(primaryColor, secondaryColor,
            (math.sin(animationValue * 4 * math.pi + i) + 1) / 2)!
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotOffset,
          3 + math.sin(animationValue * 2 * math.pi + i) * 1.2, dotPaint);
    }

    // Center AI/medical pulse core
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [secondaryColor, primaryColor],
      ).createShader(Rect.fromCircle(center: center, radius: 10));

    canvas.drawCircle(
        center, 10 + 4 * math.sin(animationValue * 2 * math.pi), corePaint);

    // Medical scanner line (horizontal wave)
    final path = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = center.dy +
          math.sin((x / size.width * 4 * math.pi) +
                  animationValue * 2 * math.pi) *
              6;
      if (x == 0)
        path.moveTo(x, y);
      else
        path.lineTo(x, y);
    }
    final wavePaint = Paint()
      ..color = primaryColor.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant _AiMedicalPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
