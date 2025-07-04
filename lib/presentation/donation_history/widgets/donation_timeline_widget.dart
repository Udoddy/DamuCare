import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> donations;
  final Map<String, dynamic> stats;
  final Function(Map<String, dynamic>) onDonationTap;

  const DonationTimelineWidget({
    Key? key,
    required this.donations,
    required this.stats,
    required this.onDonationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return _buildEmptyTimeline();
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimelineHeader(),
          SizedBox(height: 4.w),
          _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildTimelineHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'timeline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Donation Journey',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildTimelineStatCard(
                  'Current Streak',
                  '${stats['currentStreak']} donations',
                  Icons.local_fire_department,
                  AppTheme.getWarningColor(true),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildTimelineStatCard(
                  'Best Streak',
                  '${stats['longestStreak']} donations',
                  Icons.emoji_events,
                  AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 5.w,
          ),
          SizedBox(height: 1.w),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        for (int i = 0; i < donations.length; i++)
          _buildTimelineItem(donations[i], i == donations.length - 1),
      ],
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> donation, bool isLast) {
    final isCompleted = donation['processingStage'] == 'Transfused' ||
        donation['processingStage'] == 'Distributed';

    return GestureDetector(
      onTap: () => onDonationTap(donation),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getWarningColor(true),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isCompleted
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getWarningColor(true))
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: isCompleted ? 'check' : 'hourglass_empty',
                    color: Colors.white,
                    size: 5.w,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 15.w,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          // Timeline content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          donation['location'],
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: (isCompleted
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.getWarningColor(true))
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          donation['processingStage'],
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isCompleted
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.getWarningColor(true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.w),
                  Text(
                    '${donation['date']} • ${donation['time']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.w),
                  Row(
                    children: [
                      _buildTimelineChip(
                        donation['donationType'],
                        Icons.water_drop,
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      _buildTimelineChip(
                        donation['volume'],
                        Icons.science,
                        AppTheme.getWarningColor(true),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.w),
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'people',
                        color: AppTheme.getSuccessColor(true),
                        size: 4.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${donation['livesImpacted']} lives impacted',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      if (donation['badgeEarned'] != null) ...[
                        CustomIconWidget(
                          iconName: 'military_tech',
                          color: AppTheme.getSuccessColor(true),
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          donation['badgeEarned'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.getSuccessColor(true),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isCompleted) ...[
                    SizedBox(height: 3.w),
                    _buildImpactIndicator(donation),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineChip(String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactIndicator(Map<String, dynamic> donation) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.getAccentColor(true),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'favorite',
            color: AppTheme.getSuccessColor(true),
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Blood Journey Complete',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Your donation has reached patients in need',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTimeline() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'timeline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 4.h),
            Text(
              'Your Timeline Awaits',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start your donation journey to see your impact timeline here',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
