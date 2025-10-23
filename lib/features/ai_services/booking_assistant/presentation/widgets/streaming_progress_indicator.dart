import 'package:flutter/material.dart';

import '../../../../../generated/l10n/app_localizations.dart';

/// Enhanced progress indicator for streaming AI responses
class StreamingProgressIndicator extends StatefulWidget {
  final bool isStreaming;
  final bool isProcessing;
  final String? currentIntent;
  final double? confidence;
  final String? streamingMessage;

  const StreamingProgressIndicator({
    super.key,
    required this.isStreaming,
    required this.isProcessing,
    this.currentIntent,
    this.confidence,
    this.streamingMessage,
  });

  @override
  State<StreamingProgressIndicator> createState() =>
      _StreamingProgressIndicatorState();
}

class _StreamingProgressIndicatorState extends State<StreamingProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    if (widget.isStreaming || widget.isProcessing) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(StreamingProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isStreaming || widget.isProcessing) {
      _startAnimations();
    } else {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _waveController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isStreaming && !widget.isProcessing) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context)
                .colorScheme
                .primaryContainer
                .withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated AI Avatar
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status text
                Text(
                  widget.isStreaming
                      ? AppLocalizations.of(context)!.aiIsResponding
                      : AppLocalizations.of(context)!.aiIsThinking,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.analyzingYourRequest,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.8),
                    fontSize: 14,
                  ),
                ),

                // Show streaming content if available
                if (widget.isStreaming &&
                    widget.streamingMessage != null &&
                    widget.streamingMessage!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.streamingMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],

                // Show intent and confidence if available
                if (widget.currentIntent != null ||
                    widget.confidence != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.currentIntent != null) ...[
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${AppLocalizations.of(context)!.intent}: ${widget.currentIntent}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (widget.confidence != null) ...[
                        if (widget.currentIntent != null)
                          const SizedBox(width: 12),
                        Text(
                          '${AppLocalizations.of(context)!.confidence}: ${(widget.confidence! * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Animated progress indicator
          SizedBox(
            width: 24,
            height: 24,
            child: widget.isStreaming
                ? _buildStreamingIndicator()
                : CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingIndicator() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(24, 24),
          painter: StreamingWavePainter(
            progress: _waveAnimation.value,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

/// Custom painter for streaming wave animation
class StreamingWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  StreamingWavePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw animated wave
    for (int i = 0; i < 3; i++) {
      final waveProgress = (progress + i * 0.3) % 1.0;
      final alpha = (1.0 - waveProgress) * 0.8;
      final waveRadius = radius * (0.5 + waveProgress * 0.5);

      paint.color = color.withValues(alpha: alpha);
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  @override
  bool shouldRepaint(StreamingWavePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
