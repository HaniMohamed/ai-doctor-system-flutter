import 'package:flutter/material.dart';

import '../../../../../generated/l10n/app_localizations.dart';

/// Widget for inputting messages to the booking assistant
class BookingInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSendMessage;
  final bool isLoading;

  const BookingInputWidget({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.isLoading,
  });

  @override
  State<BookingInputWidget> createState() => _BookingInputWidgetState();
}

class _BookingInputWidgetState extends State<BookingInputWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = widget.controller.text.trim();
    if (message.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(message);
      widget.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Enhanced text input with AI styling
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                    Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                enabled: !widget.isLoading,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.askYourAIAssistant,
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant
                        .withValues(alpha: 0.6),
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Icon(
                      Icons.psychology_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  suffixIcon: widget.isLoading
                      ? Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        )
                      : null,
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Enhanced send button with AI styling
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isLoading
                    ? [
                        Colors.grey.shade400,
                        Colors.grey.shade500,
                      ]
                    : [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.8),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: widget.isLoading
                      ? Colors.grey.withValues(alpha: 0.3)
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : _sendMessage,
                borderRadius: BorderRadius.circular(28),
                child: Icon(
                  Icons.send_rounded,
                  color: widget.isLoading ? Colors.grey.shade600 : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
