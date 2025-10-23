import 'package:flutter/material.dart';

/// Widget to display AI confidence and intent in real-time
class AiConfidenceIndicator extends StatelessWidget {
  final String intent;
  final double confidence;
  final bool isVisible;

  const AiConfidenceIndicator({
    super.key,
    required this.intent,
    required this.confidence,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible || intent.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withValues(alpha: 0.3),
            Theme.of(context)
                .colorScheme
                .secondaryContainer
                .withValues(alpha: 0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Intent icon
          Icon(
            _getIntentIcon(intent),
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),

          // Intent text
          Text(
            intent.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(width: 12),

          // Confidence bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Confidence',
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${(confidence * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: confidence,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(context, confidence),
                  ),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIntentIcon(String intent) {
    switch (intent.toLowerCase()) {
      case 'book':
      case 'booking':
        return Icons.calendar_today_rounded;
      case 'find':
      case 'search':
        return Icons.search_rounded;
      case 'cancel':
        return Icons.cancel_rounded;
      case 'reschedule':
        return Icons.schedule_rounded;
      case 'info':
      case 'information':
        return Icons.info_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  Color _getConfidenceColor(BuildContext context, double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
