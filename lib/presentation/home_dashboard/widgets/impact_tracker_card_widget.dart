import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImpactTrackerCardWidget extends StatelessWidget {
  final int totalDonations;
  final int estimatedLivesSaved;

  const ImpactTrackerCardWidget({
    super.key,
    required this.totalDonations,
    required this.estimatedLivesSaved,
  });

  double _getProgressToNextMilestone() {
    const milestones = [1, 5, 10, 25, 50, 100];

    for (int milestone in milestones) {
      if (totalDonations < milestone) {
        final previousMilestone = milestones[milestones.indexOf(milestone) - 1];
        final progress =
            (totalDonations - (previousMilestone > 0 ? previousMilestone : 0)) /
                (milestone - (previousMilestone > 0 ? previousMilestone : 0));
        return progress.clamp(0.0, 1.0);
      }
    }
    return 1.0;
  }

  int _getNextMilestone() {
    const milestones = [1, 5, 10, 25, 50, 100];

    for (int milestone in milestones) {
      if (totalDonations < milestone) {
        return milestone;
      }
    }
    return 100;
  }

  String _getImpactMessage() {
    if (totalDonations == 0) {
      return "Start your donation journey and save lives!";
    } else if (totalDonations == 1) {
      return "Amazing! You've potentially saved up to 3 lives with your first donation.";
    } else {
      return "Incredible impact! Your $totalDonations donations have potentially saved $estimatedLivesSaved lives.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgressToNextMilestone();
    final nextMilestone = _getNextMilestone();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
            AppTheme.getAccentColor(true).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Impact",
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getSuccessColor(true),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "Making a difference in Tanzania",
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.getSuccessColor(true),
                  size: 32,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Statistics Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  value: "$totalDonations",
                  label: "Total Donations",
                  icon: 'bloodtype',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  value: "$estimatedLivesSaved",
                  label: "Lives Saved",
                  icon: 'people',
                  color: AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Progress to next milestone
          if (totalDonations < 100) ...[
            Text(
              "Progress to $nextMilestone donations",
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.getSuccessColor(true),
              ),
              minHeight: 8,
            ),
            SizedBox(height: 1.h),
            Text(
              "${nextMilestone - totalDonations} more donations to reach your next milestone!",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
          ],

          // Impact message
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getImpactMessage(),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 28,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
