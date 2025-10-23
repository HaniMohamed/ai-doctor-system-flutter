import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../generated/l10n/app_localizations.dart';
import '../../../../../shared/widgets/base_scaffold.dart';
import '../controllers/booking_assistant_controller.dart';
import '../widgets/booking_input_widget.dart';
import '../widgets/booking_message_widget.dart';
import '../widgets/ai_status_indicator.dart';
import '../widgets/ai_smart_suggestions.dart';
import '../widgets/streaming_progress_indicator.dart';

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
    // Set localized welcome message if messages are empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.messages.isEmpty) {
        _controller.setWelcomeMessage(
          AppLocalizations.of(context)!.bookingAssistantWelcomeMessage,
        );
      }
    });
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
        // AI Status Indicator
        Obx(() => AiStatusIndicator(
              isConnected: _controller.isConnected,
              isProcessing: _controller.isProcessing,
              isStreaming: _controller.isStreaming,
            )),
        const SizedBox(width: 8),
        // Clear conversation button with modern design
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: IconButton(
            onPressed: () => _controller.clearConversation(
              welcomeMessage:
                  AppLocalizations.of(context)!.bookingAssistantWelcomeMessage,
            ),
            icon: Icon(
              Icons.refresh_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            tooltip: AppLocalizations.of(context)!.clearChat,
          ),
        ),
      ],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Column(
          children: [
            // AI Smart Suggestions (when available and not processing)
            Obx(() {
              if ((_controller.suggestedTimeSlots.isNotEmpty ||
                      _controller.availableDoctors.isNotEmpty) &&
                  !_controller.isProcessing &&
                  !_controller.isStreaming) {
                return AiSmartSuggestions(
                  suggestedTimeSlots: _controller.suggestedTimeSlots,
                  availableDoctors: _controller.availableDoctors,
                  onTimeSlotSelected: (slot) =>
                      _controller.selectTimeSlot(slot),
                  onDoctorSelected: (doctor) =>
                      _controller.selectDoctor(doctor),
                );
              }
              return const SizedBox.shrink();
            }),

            // Messages list with modern design
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Obx(() {
                    if (_controller.messages.isEmpty &&
                        !_controller.isStreaming) {
                      return _buildEmptyState(context);
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
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
              ),
            ),

            // Enhanced Streaming Progress Indicator
            Obx(() {
              if (_controller.isProcessing || _controller.isStreaming) {
                return StreamingProgressIndicator(
                  isStreaming: _controller.isStreaming,
                  isProcessing: _controller.isProcessing,
                  currentIntent: _controller.currentIntent.isNotEmpty
                      ? _controller.currentIntent
                      : null,
                  confidence: _controller.currentConfidence > 0
                      ? _controller.currentConfidence
                      : null,
                  streamingMessage: _controller.streamingMessage.isNotEmpty
                      ? _controller.streamingMessage
                      : null,
                );
              }
              return const SizedBox.shrink();
            }),

            // AI Action Result Indicator
            Obx(() {
              if (_controller.actionTaken &&
                  _controller.actionResult.isNotEmpty &&
                  !_controller.isProcessing &&
                  !_controller.isStreaming) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade50,
                        Colors.green.shade100.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.green.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.actionCompleted,
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _controller.actionResult,
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Error message with modern design
            Obx(() {
              if (_controller.errorMessage.isNotEmpty) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.shade50,
                        Colors.red.shade100.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.error_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.somethingWentWrong,
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _controller.errorMessage,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _controller.clearError,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.red.shade700,
                        ),
                        tooltip: AppLocalizations.of(context)!.dismiss,
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Input widget with modern design
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: BookingInputWidget(
                controller: _messageController,
                onSendMessage: (message) {
                  _controller.sendMessage(message);
                  _messageController.clear();
                  _scrollToBottom();
                },
                isLoading: _controller.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI Avatar with animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_rounded,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),

          // Welcome message
          Text(
            AppLocalizations.of(context)!.welcomeToBookingAssistant,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.bookingAssistantDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // Quick action buttons
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildQuickActionButton(
                context,
                icon: Icons.calendar_today_rounded,
                label: AppLocalizations.of(context)!.startBooking,
                onTap: () {
                  _controller.sendMessage(
                    AppLocalizations.of(context)!.iNeedToBookAnAppointment,
                  );
                },
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.medical_services_rounded,
                label: AppLocalizations.of(context)!.findADoctor,
                onTap: () {
                  _controller.sendMessage(
                    AppLocalizations.of(context)!.iNeedToFindADoctor,
                  );
                },
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.schedule_rounded,
                label: AppLocalizations.of(context)!.checkAvailability,
                onTap: () {
                  _controller.sendMessage(
                    AppLocalizations.of(context)!.showMeAvailableAppointments,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreamingMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Avatar with pulsing animation
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.8, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
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
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
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
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: const Radius.circular(8),
                ),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show response message if available, otherwise show streaming content
                  Text(
                    _controller.responseMessage.isNotEmpty
                        ? _controller.responseMessage
                        : _controller.streamingMessage.isNotEmpty
                            ? _controller.streamingMessage
                            : AppLocalizations.of(context)!.aiIsResponding,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Show confidence and intent if available
                  if (_controller.currentIntent.isNotEmpty ||
                      _controller.currentConfidence > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_controller.currentIntent.isNotEmpty) ...[
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${AppLocalizations.of(context)!.intent}: ${_controller.currentIntent}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (_controller.currentConfidence > 0) ...[
                            if (_controller.currentIntent.isNotEmpty)
                              const SizedBox(width: 8),
                            Text(
                              '${AppLocalizations.of(context)!.confidence}: ${(_controller.currentConfidence * 100).toStringAsFixed(0)}%',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTypingDot(0),
                      const SizedBox(width: 8),
                      _buildTypingDot(1),
                      const SizedBox(width: 8),
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
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + (index * 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.4 + (value * 0.6)),
                Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.2 + (value * 0.8)),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3 * value),
                blurRadius: 6 * value,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        );
      },
    );
  }
}
