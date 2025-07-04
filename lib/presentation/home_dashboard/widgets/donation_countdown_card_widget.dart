import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationCountdownCardWidget extends StatelessWidget {
  final String nextDonationDate;
  final String eligibilityStatus;

  const DonationCountdownCardWidget({
    super.key,
    required this.nextDonationDate,
    required this.eligibilityStatus,
  });

  int _getDaysUntilNextDonation() {
    if (nextDonationDate.isEmpty) return 0;

    try {
      final nextDate = DateTime.parse(nextDonationDate);
      final now = DateTime.now();
      final difference = nextDate.difference(now).inDays;
      return difference > 0 ? difference : 0;
    } catch (e) {
      return 0;
    }
  }

  double _getProgressValue() {
    const totalDays = 56; // 8 weeks between donations
    final daysLeft = _getDaysUntilNextDonation();
    final daysPassed = totalDays - daysLeft;
    return daysPassed / totalDays;
  }

  String _getMotivationalMessage() {
    final daysLeft = _getDaysUntilNextDonation();

    if (eligibilityStatus == "eligible") {
      return "Tayari kutoa damu! Your donation can save lives.";
    } else if (daysLeft <= 7) {
      return "Karibu sana! Just $daysLeft days until you can donate again.";
    } else if (daysLeft <= 14) {
      return "Subiri kidogo! $daysLeft days remaining for your next donation.";
    } else {
      return "Muda wa kupumzika. $daysLeft days until your next donation opportunity.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysLeft = _getDaysUntilNextDonation();
    final progressValue = _getProgressValue();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Next Donation",
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      eligibilityStatus == "eligible"
                          ? "Available Now!"
                          : "$daysLeft days",
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        value: eligibilityStatus == "eligible"
                            ? 1.0
                            : progressValue,
                        strokeWidth: 6,
                        backgroundColor: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          eligibilityStatus == "eligible"
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: CustomIconWidget(
                          iconName: eligibilityStatus == "eligible"
                              ? 'favorite'
                              : 'schedule',
                          color: eligibilityStatus == "eligible"
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getMotivationalMessage(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
