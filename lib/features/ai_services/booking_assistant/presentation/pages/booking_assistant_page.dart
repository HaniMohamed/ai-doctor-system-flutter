import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/l10n/app_localizations.dart';
import '../../../../../shared/widgets/base_scaffold.dart';
import '../controllers/booking_assistant_controller.dart';
import '../widgets/booking_message_widget.dart';
import '../widgets/booking_input_widget.dart';
import '../widgets/booking_suggestions_widget.dart';

/// Main page for AI booking assistant
class BookingAssistantPage extends StatefulWidget {
  const BookingAssistantPage({super.key});

  @override
  State<BookingAssistantPage> createState() => _BookingAssistantPageState();
}

class _BookingAssistantPageState extends State<BookingAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late BookingAssistantController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<BookingAssistantController>();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: AppLocalizations.of(context)!.bookingAssistant,
      actions: [
        // WebSocket connection status
        Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _controller.isConnected
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _controller.isConnected ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: _controller.isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _controller.isConnected ? 'Live' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          _controller.isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            )),
        IconButton(
          onPressed: _controller.clearConversation,
          icon: const Icon(Icons.clear_all),
          tooltip: AppLocalizations.of(context)!.clearChat,
        ),
      ],
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: Obx(() {
              if (_controller.messages.isEmpty && !_controller.isStreaming) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _controller.messages.length +
                    (_controller.isStreaming ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _controller.messages.length &&
                      _controller.isStreaming) {
                    return _buildStreamingMessage();
                  }
                  final message = _controller.messages[index];
                  return BookingMessageWidget(
                    message: message,
                    onTimeSlotSelected: (slot) {
                      _controller.selectTimeSlot(slot);
                    },
                    onDoctorSelected: (doctor) {
                      _controller.selectDoctor(doctor);
                    },
                  );
                },
              );
            }),
          ),

          // Loading indicator
          Obx(() {
            if (_controller.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Error message
          Obx(() {
            if (_controller.errorMessage.isNotEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.red.shade50,
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _controller.errorMessage,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                    IconButton(
                      onPressed: _controller.clearError,
                      icon: const Icon(Icons.close),
                      color: Colors.red.shade700,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Suggestions widget
          Obx(() {
            if (_controller.suggestedTimeSlots.isNotEmpty ||
                _controller.availableDoctors.isNotEmpty) {
              return BookingSuggestionsWidget(
                suggestedTimeSlots: _controller.suggestedTimeSlots,
                availableDoctors: _controller.availableDoctors,
                onTimeSlotSelected: (slot) {
                  _controller.selectTimeSlot(slot);
                },
                onDoctorSelected: (doctor) {
                  _controller.selectDoctor(doctor);
                },
              );
            }
            return const SizedBox.shrink();
          }),

          // Input widget
          BookingInputWidget(
            controller: _messageController,
            onSendMessage: (message) {
              _controller.sendMessage(message);
              _messageController.clear();
              _scrollToBottom();
            },
            isLoading: _controller.isLoading,
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (_controller.messages.isNotEmpty) {
          return FloatingActionButton(
            onPressed: _controller.clearConversation,
            tooltip: AppLocalizations.of(context)!.clearConversation,
            child: const Icon(Icons.refresh),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.welcomeToBookingAssistant,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.bookingAssistantDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _controller.sendMessage(
                AppLocalizations.of(context)!.iNeedToBookAnAppointment,
              );
            },
            icon: const Icon(Icons.calendar_today),
            label: Text(AppLocalizations.of(context)!.startBooking),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamingMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.smart_toy,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _controller.streamingMessage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypingDot(0),
                      const SizedBox(width: 4),
                      _buildTypingDot(1),
                      const SizedBox(width: 4),
                      _buildTypingDot(2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .onSurfaceVariant
            .withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}
