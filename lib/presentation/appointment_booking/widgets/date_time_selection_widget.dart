import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DateTimeSelectionWidget extends StatefulWidget {
  final Map<String, dynamic>? selectedCenter;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<String> timeSlots;
  final Function(DateTime, String) onDateTimeSelected;

  const DateTimeSelectionWidget({
    super.key,
    required this.selectedCenter,
    required this.selectedDate,
    required this.selectedTime,
    required this.timeSlots,
    required this.onDateTimeSelected,
  });

  @override
  State<DateTimeSelectionWidget> createState() =>
      _DateTimeSelectionWidgetState();
}

class _DateTimeSelectionWidgetState extends State<DateTimeSelectionWidget> {
  DateTime? _tempSelectedDate;
  String? _tempSelectedTime;

  // Mock unavailable dates
  final List<DateTime> unavailableDates = [
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 7)),
    DateTime.now().add(Duration(days: 14)),
  ];

  @override
  void initState() {
    super.initState();
    _tempSelectedDate = widget.selectedDate;
    _tempSelectedTime = widget.selectedTime;
  }

  bool _isDateAvailable(DateTime date) {
    // Check if date is in the past
    if (date.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      return false;
    }

    // Check if date is in unavailable dates
    return !unavailableDates.any((unavailableDate) =>
        date.year == unavailableDate.year &&
        date.month == unavailableDate.month &&
        date.day == unavailableDate.day);
  }

  void _selectDate(DateTime date) {
    if (_isDateAvailable(date)) {
      setState(() {
        _tempSelectedDate = date;
        _tempSelectedTime = null; // Reset time selection when date changes
      });
    }
  }

  void _selectTime(String time) {
    setState(() {
      _tempSelectedTime = time;
    });

    if (_tempSelectedDate != null) {
      widget.onDateTimeSelected(_tempSelectedDate!, time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected center info
          if (widget.selectedCenter != null) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedCenter!['name'] as String,
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.selectedCenter!['address'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],

          Text(
            'Select Date & Time',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose your preferred appointment date and time',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Calendar section
          Text(
            'Select Date',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: CalendarDatePicker(
              initialDate: _tempSelectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 90)),
              onDateChanged: _selectDate,
              selectableDayPredicate: _isDateAvailable,
            ),
          ),

          SizedBox(height: 3.h),

          // Time slots section
          if (_tempSelectedDate != null) ...[
            Row(
              children: [
                Text(
                  'Available Times',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Text(
                  '${_formatDate(_tempSelectedDate!)}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Time slots grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: widget.timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = widget.timeSlots[index];
                final isSelected = _tempSelectedTime == timeSlot;
                final isAvailable = _isTimeSlotAvailable(timeSlot);

                return GestureDetector(
                  onTap: isAvailable ? () => _selectTime(timeSlot) : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : isAvailable
                              ? AppTheme.lightTheme.colorScheme.surface
                              : AppTheme.lightTheme.colorScheme.surface
                                  .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : isAvailable
                                ? AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            timeSlot,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : isAvailable
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                      : AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (!isAvailable)
                            Text(
                              'Unavailable',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Duration info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Duration',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Approximately 45-60 minutes including registration and post-donation rest',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isTimeSlotAvailable(String timeSlot) {
    // Mock logic - some time slots might be unavailable
    final unavailableSlots = ['11:00 AM', '2:00 PM'];
    return !unavailableSlots.contains(timeSlot);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
