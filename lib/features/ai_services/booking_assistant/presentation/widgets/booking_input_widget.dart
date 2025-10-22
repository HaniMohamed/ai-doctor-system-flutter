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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: !widget.isLoading,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.typeYourMessage,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: widget.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          Container(
            decoration: BoxDecoration(
              color: widget.isLoading
                  ? Colors.grey.shade300
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: IconButton(
              onPressed: widget.isLoading ? null : _sendMessage,
              icon: Icon(
                Icons.send,
                color: widget.isLoading ? Colors.grey.shade500 : Colors.white,
              ),
              tooltip: AppLocalizations.of(context)!.sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
