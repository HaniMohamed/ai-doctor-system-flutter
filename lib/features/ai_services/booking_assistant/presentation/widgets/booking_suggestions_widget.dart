import 'package:flutter/material.dart';
import '../../domain/entities/booking_message.dart';
import '../../../../../generated/l10n/app_localizations.dart';

/// Widget for displaying booking suggestions (doctors, time slots)
class BookingSuggestionsWidget extends StatelessWidget {
  final List<TimeSlot> suggestedTimeSlots;
  final List<dynamic> availableDoctors;
  final Function(TimeSlot)? onTimeSlotSelected;
  final Function(dynamic)? onDoctorSelected;

  const BookingSuggestionsWidget({
    super.key,
    required this.suggestedTimeSlots,
    required this.availableDoctors,
    this.onTimeSlotSelected,
    this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          top: BorderSide(color: Colors.blue.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.suggestions,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Doctors suggestions
          if (availableDoctors.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)!.availableDoctors,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = availableDoctors[index];
                  return _buildDoctorCard(context, doctor);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Time slots suggestions
          if (suggestedTimeSlots.isNotEmpty) ...[
            Text(
              AppLocalizations.of(context)!.suggestedTimeSlots,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedTimeSlots.length,
                itemBuilder: (context, index) {
                  final slot = suggestedTimeSlots[index];
                  return _buildTimeSlotCard(context, slot);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, dynamic doctor) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doctor['name'] ?? 'Unknown Doctor',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (doctor['specialty'] != null) ...[
            Text(
              doctor['specialty'],
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
          ],
          if (doctor['rating'] != null) ...[
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  doctor['rating'].toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
          const Spacer(),
          ElevatedButton(
            onPressed: () => onDoctorSelected?.call(doctor),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              AppLocalizations.of(context)!.select,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(BuildContext context, TimeSlot slot) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTimeSlot(slot),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(slot.startTime),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          if (slot.reasoning != null) ...[
            const SizedBox(height: 4),
            Text(
              slot.reasoning!,
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          ElevatedButton(
            onPressed: () => onTimeSlotSelected?.call(slot),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: const Size(0, 32),
            ),
            child: Text(
              AppLocalizations.of(context)!.select,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeSlot(TimeSlot slot) {
    final start = slot.startTime;
    final end = slot.endTime;
    return '${_formatTime(start)} - ${_formatTime(end)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) {
      return 'Today';
    } else if (date == tomorrow) {
      return 'Tomorrow';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
