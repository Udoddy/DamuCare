import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationStreakCalendarWidget extends StatelessWidget {
  final int currentStreak;
  final String lastDonationDate;

  const DonationStreakCalendarWidget({
    super.key,
    required this.currentStreak,
    required this.lastDonationDate,
  });

  List<DateTime> _getDonationDates() {
    // Mock donation dates for demonstration
    final now = DateTime.now();
    return [
      DateTime(now.year, now.month - 2, 15),
      DateTime(now.year, now.month - 1, 20),
      DateTime(now.year, now.month, 10),
    ];
  }

  List<DateTime> _getCurrentMonthDays() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);

    final days = <DateTime>[];
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(now.year, now.month, i));
    }
    return days;
  }

  bool _isDonationDate(DateTime date) {
    final donationDates = _getDonationDates();
    return donationDates.any((donationDate) =>
        donationDate.year == date.year &&
        donationDate.month == date.month &&
        donationDate.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    final monthDays = _getCurrentMonthDays();
    final now = DateTime.now();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Donation Streak",
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    "$currentStreak consecutive donations",
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.getSuccessColor(true),
                      size: 20,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "$currentStreak",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Month header
          Text(
            "${_getMonthName(now.month)} ${now.year}",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),

          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: 8.w,
                child: Text(
                  day,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 1.h),

          // Calendar grid
          Wrap(
            children: monthDays.map((date) {
              final isDonation = _isDonationDate(date);
              final isToday = date.day == now.day;

              return Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: isDonation
                      ? AppTheme.lightTheme.colorScheme.primary
                      : isToday
                          ? AppTheme.lightTheme.colorScheme.primaryContainer
                          : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isDonation
                      ? Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Center(
                  child: isDonation
                      ? CustomIconWidget(
                          iconName: 'favorite',
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          "${date.day}",
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isToday
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isToday ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
