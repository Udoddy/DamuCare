import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const DonationPreferencesWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<DonationPreferencesWidget> createState() =>
      _DonationPreferencesWidgetState();
}

class _DonationPreferencesWidgetState extends State<DonationPreferencesWidget> {
  String selectedCenter = "Arusha Regional Hospital";
  String preferredTime = "Morning (9:00 AM - 12:00 PM)";
  int reminderDays = 7;

  // Mock donation centers
  final List<Map<String, dynamic>> donationCenters = [
    {
      "id": 1,
      "name": "Arusha Regional Hospital",
      "location": "Arusha, Tanzania",
      "distance": "2.5 km",
    },
    {
      "id": 2,
      "name": "Mount Meru Hospital",
      "location": "Arusha, Tanzania",
      "distance": "4.1 km",
    },
    {
      "id": 3,
      "name": "Selian Lutheran Hospital",
      "location": "Arusha, Tanzania",
      "distance": "6.8 km",
    },
  ];

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
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Donation Preferences',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Preferred Center
            _buildPreferenceItem(
              context,
              'Preferred Donation Center',
              selectedCenter,
              'location_on',
              () => _showCenterSelectionDialog(),
            ),

            Divider(height: 2.h),

            // Preferred Time
            _buildPreferenceItem(
              context,
              'Preferred Appointment Time',
              preferredTime,
              'schedule',
              () => _showTimeSelectionDialog(),
            ),

            Divider(height: 2.h),

            // Reminder Settings
            _buildReminderSettings(),

            SizedBox(height: 2.h),

            // Donation Goals
            _buildDonationGoals(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(
    BuildContext context,
    String title,
    String value,
    String iconName,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
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
                  value,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications_active',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Reminder Settings',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remind me $reminderDays days before I\'m eligible to donate again',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Text(
                    'Days: ',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                  Expanded(
                    child: Slider(
                      value: reminderDays.toDouble(),
                      min: 1,
                      max: 14,
                      divisions: 13,
                      label: '$reminderDays days',
                      onChanged: (value) {
                        setState(() {
                          reminderDays = value.round();
                        });
                      },
                    ),
                  ),
                  Text(
                    '$reminderDays',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDonationGoals() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Donation Goals',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Annual Goal:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '4 donations',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '3 of 4 (75%)',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showCenterSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Preferred Center'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: donationCenters.length,
              itemBuilder: (context, index) {
                final center = donationCenters[index];
                final isSelected = selectedCenter == center["name"];

                return RadioListTile<String>(
                  title: Text(center["name"] as String),
                  subtitle:
                      Text('${center["location"]} • ${center["distance"]}'),
                  value: center["name"] as String,
                  groupValue: selectedCenter,
                  onChanged: (value) {
                    setState(() {
                      selectedCenter = value!;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Preferred center updated')),
                    );
                  },
                );
              },
            ),
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

  void _showTimeSelectionDialog() {
    final timeOptions = [
      'Morning (9:00 AM - 12:00 PM)',
      'Afternoon (12:00 PM - 5:00 PM)',
      'Evening (5:00 PM - 8:00 PM)',
      'Any time',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Preferred Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: timeOptions.map((option) {
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: preferredTime,
                onChanged: (value) {
                  setState(() {
                    preferredTime = value!;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preferred time updated')),
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
