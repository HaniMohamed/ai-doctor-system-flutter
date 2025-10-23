import 'package:flutter/material.dart';
import '../../domain/entities/booking_message.dart';

/// Widget for displaying booking assistant messages
class BookingMessageWidget extends StatelessWidget {
  final BookingMessage message;
  final Function(TimeSlot)? onTimeSlotSelected;
  final Function(dynamic)? onDoctorSelected;

  const BookingMessageWidget({
    super.key,
    required this.message,
    this.onTimeSlotSelected,
    this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: message.isUser
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            child: Icon(
              message.isUser ? Icons.person : Icons.smart_toy,
              color: message.isUser ? Colors.white : Colors.grey.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Message bubble
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.content,
                        style: TextStyle(
                          color: message.isUser
                              ? Colors.white
                              : Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      if (message.metadata != null) ...[
                        const SizedBox(height: 8),
                        _buildMetadata(context),
                      ],
                    ],
                  ),
                ),

                // Timestamp
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(message.timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final metadata = message.metadata!;
    final intent = metadata['intent']?.toString();
    final confidence = metadata['confidence'] is num
        ? (metadata['confidence'] as num).toDouble()
        : null;
    final nextStepsRaw = metadata['next_steps'];
    final nextSteps = nextStepsRaw is List<dynamic>
        ? nextStepsRaw.cast<String>()
        : nextStepsRaw as List<String>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (intent != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Intent: $intent',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (confidence != null) ...[
          Text(
            'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (nextSteps != null && nextSteps.isNotEmpty) ...[
          Text(
            'Next steps:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          ...nextSteps.map((step) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 2),
                child: Text(
                  '• $step',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              )),
        ],
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
