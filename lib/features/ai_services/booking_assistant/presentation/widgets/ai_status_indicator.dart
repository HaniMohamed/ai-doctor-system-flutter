import 'package:flutter/material.dart';

/// Modern AI status indicator widget with animated states
class AiStatusIndicator extends StatefulWidget {
  final bool isConnected;
  final bool isProcessing;
  final bool isStreaming;

  const AiStatusIndicator({
    super.key,
    required this.isConnected,
    required this.isProcessing,
    required this.isStreaming,
  });

  @override
  State<AiStatusIndicator> createState() => _AiStatusIndicatorState();
}

class _AiStatusIndicatorState extends State<AiStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _startAnimations();
  }

  void _startAnimations() {
    if (widget.isProcessing || widget.isStreaming) {
      _pulseController.repeat(reverse: true);
      _rotateController.repeat();
    } else {
      _pulseController.stop();
      _rotateController.stop();
    }
  }

  @override
  void didUpdateWidget(AiStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isProcessing != oldWidget.isProcessing ||
        widget.isStreaming != oldWidget.isStreaming) {
      _startAnimations();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getStatusColors(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(context),
          const SizedBox(width: 8),
          _buildStatusText(context),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    if (widget.isProcessing || widget.isStreaming) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: AnimatedBuilder(
              animation: _rotateAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotateAnimation.value * 2 * 3.14159,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.isStreaming
                          ? Icons.psychology_rounded
                          : Icons.auto_awesome_rounded,
                      size: 10,
                      color: _getStatusColor(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
        size: 10,
        color: _getStatusColor(),
      ),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    return Text(
      _getStatusText(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _getStatusText() {
    if (widget.isStreaming) return 'AI Typing...';
    if (widget.isProcessing) return 'AI Thinking...';
    if (widget.isConnected) return 'Live';
    return 'Offline';
  }

  Color _getStatusColor() {
    if (widget.isStreaming || widget.isProcessing) {
      return Colors.blue.shade600;
    }
    if (widget.isConnected) {
      return Colors.green.shade600;
    }
    return Colors.red.shade600;
  }

  List<Color> _getStatusColors() {
    if (widget.isStreaming || widget.isProcessing) {
      return [
        Colors.blue.shade500,
        Colors.blue.shade600,
      ];
    }
    if (widget.isConnected) {
      return [
        Colors.green.shade500,
        Colors.green.shade600,
      ];
    }
    return [
      Colors.red.shade500,
      Colors.red.shade600,
    ];
  }
}
