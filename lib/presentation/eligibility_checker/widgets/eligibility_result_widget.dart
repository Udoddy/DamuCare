import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EligibilityResultWidget extends StatelessWidget {
  final bool isEligible;
  final List<String> restrictions;
  final String message;
  final VoidCallback onBookAppointment;
  final VoidCallback onViewCenters;

  const EligibilityResultWidget({
    Key? key,
    required this.isEligible,
    required this.restrictions,
    required this.message,
    required this.onBookAppointment,
    required this.onViewCenters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 2.h),

          // Result icon and status
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isEligible
                  ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                  : AppTheme.getWarningColor(true).withValues(alpha: 0.1),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isEligible ? 'check_circle' : 'cancel',
                color: isEligible
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getWarningColor(true),
                size: 10.w,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Status message
          Text(
            isEligible ? 'Eligible to Donate!' : 'Not Eligible',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: isEligible
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getWarningColor(true),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Eligible actions
          if (isEligible) ...[
            _buildActionCard(
              context,
              title: 'Ready to Donate?',
              subtitle: 'Book your appointment at a nearby donation center',
              icon: 'calendar_month',
              buttonText: 'Book Appointment',
              onPressed: onBookAppointment,
              color: AppTheme.getSuccessColor(true),
            ),

            SizedBox(height: 2.h),

            _buildActionCard(
              context,
              title: 'Find Donation Centers',
              subtitle: 'View nearby centers and their operating hours',
              icon: 'location_on',
              buttonText: 'View Centers',
              onPressed: onViewCenters,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),

            SizedBox(height: 3.h),

            // Pre-donation tips
            _buildTipsCard(context),
          ] else ...[
            // Restrictions list
            if (restrictions.isNotEmpty) ...[
              Card(
                elevation: AppTheme.lightTheme.cardTheme.elevation,
                shape: AppTheme.lightTheme.cardTheme.shape,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'warning',
                            color: AppTheme.getWarningColor(true),
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Eligibility Restrictions',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      ...restrictions.map((restriction) => Padding(
                            padding: EdgeInsets.only(bottom: 1.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: EdgeInsets.only(top: 1.h, right: 3.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.getWarningColor(true),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    restriction,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3.h),
            ],

            // Educational content for ineligible users
            _buildEducationalCard(context),

            SizedBox(height: 2.h),

            // Still show centers for future reference
            _buildActionCard(
              context,
              title: 'Learn More',
              subtitle: 'Find centers and learn about donation requirements',
              icon: 'school',
              buttonText: 'View Centers',
              onPressed: onViewCenters,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ],

          SizedBox(height: 4.h),

          // Share results
          OutlinedButton.icon(
            onPressed: () => _shareResults(context),
            style: AppTheme.lightTheme.outlinedButtonTheme.style,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Share Results'),
          ),

          SizedBox(height: 2.h),

          // Retake assessment
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            style: AppTheme.lightTheme.textButtonTheme.style,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Retake Assessment'),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String icon,
    required String buttonText,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 6.w,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        subtitle,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all(color),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(BuildContext context) {
    final tips = [
      'Eat a healthy meal 2-3 hours before donation',
      'Drink plenty of water before and after donation',
      'Get a good night\'s sleep before your appointment',
      'Bring a valid ID and any required documents',
      'Wear comfortable clothing with sleeves that roll up easily',
    ];

    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Pre-Donation Tips',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...tips.map((tip) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle_outline',
                        color: AppTheme.getSuccessColor(true),
                        size: 16,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          tip,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalCard(BuildContext context) {
    return Card(
      elevation: AppTheme.lightTheme.cardTheme.elevation,
      shape: AppTheme.lightTheme.cardTheme.shape,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'school',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Don\'t Give Up!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Many restrictions are temporary. Once your situation changes, you may become eligible to donate and help save lives.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Text(
              'In the meantime, you can:',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            ...[
              'Encourage friends and family to donate',
              'Share information about blood donation',
              'Volunteer at donation events',
              'Stay healthy for future donations',
            ].map((action) => Padding(
                  padding: EdgeInsets.only(bottom: 0.5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium),
                      Expanded(
                        child: Text(
                          action,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // Mock share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Eligibility results shared successfully'),
        backgroundColor: AppTheme.getSuccessColor(true),
      ),
    );
  }
}
