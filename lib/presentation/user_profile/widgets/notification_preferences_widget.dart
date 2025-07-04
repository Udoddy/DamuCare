import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const NotificationPreferencesWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  late Map<String, bool> notifications;

  @override
  void initState() {
    super.initState();
    final notificationData =
        widget.userData["notifications"] as Map<String, dynamic>?;
    notifications = {
      'appointments': notificationData?["appointments"] as bool? ?? true,
      'eligibility': notificationData?["eligibility"] as bool? ?? true,
      'educational': notificationData?["educational"] as bool? ?? false,
      'impact': notificationData?["impact"] as bool? ?? true,
    };
  }

  void _updateNotification(String key, bool value) {
    setState(() {
      notifications[key] = value;
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification preferences updated'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Notification Preferences',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Notification Toggles
            _buildNotificationToggle(
              'Appointment Reminders',
              'Get notified about upcoming appointments',
              'appointments',
              notifications['appointments'] ?? false,
              'calendar_today',
            ),

            Divider(height: 2.h),

            _buildNotificationToggle(
              'Eligibility Alerts',
              'Reminders when you\'re eligible to donate again',
              'eligibility',
              notifications['eligibility'] ?? false,
              'health_and_safety',
            ),

            Divider(height: 2.h),

            _buildNotificationToggle(
              'Educational Content',
              'Tips and information about blood donation',
              'educational',
              notifications['educational'] ?? false,
              'school',
            ),

            Divider(height: 2.h),

            _buildNotificationToggle(
              'Impact Updates',
              'Stories about how your donations help others',
              'impact',
              notifications['impact'] ?? false,
              'favorite',
            ),

            SizedBox(height: 2.h),

            // Time Preferences
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 18,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preferred Time',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Morning (9:00 AM - 12:00 PM)',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showTimePreferenceDialog();
                    },
                    child: Text('Change'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    String key,
    bool value,
    String iconName,
  ) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 18,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) => _updateNotification(key, newValue),
        ),
      ],
    );
  }

  void _showTimePreferenceDialog() {
    final List<String> timeOptions = [
      'Morning (9:00 AM - 12:00 PM)',
      'Afternoon (12:00 PM - 5:00 PM)',
      'Evening (5:00 PM - 8:00 PM)',
      'Any time',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preferred Notification Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: timeOptions[0],
                onChanged: (value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Time preference updated to $value')),
                  );
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
