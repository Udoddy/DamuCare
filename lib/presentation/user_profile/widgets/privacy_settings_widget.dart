import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacySettingsWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const PrivacySettingsWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<PrivacySettingsWidget> createState() => _PrivacySettingsWidgetState();
}

class _PrivacySettingsWidgetState extends State<PrivacySettingsWidget> {
  bool dataSharing = true;
  bool analytics = false;
  bool locationTracking = true;
  bool personalizedContent = true;

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
                  iconName: 'privacy_tip',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Privacy Settings',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Data Sharing
            _buildPrivacyToggle(
              'Data Sharing',
              'Share anonymized donation data to help improve blood donation services',
              dataSharing,
              'share',
              (value) {
                setState(() {
                  dataSharing = value;
                });
                _showPrivacyUpdateMessage('Data sharing preferences updated');
              },
            ),

            Divider(height: 2.h),

            // Analytics
            _buildPrivacyToggle(
              'Usage Analytics',
              'Help improve the app by sharing usage statistics',
              analytics,
              'analytics',
              (value) {
                setState(() {
                  analytics = value;
                });
                _showPrivacyUpdateMessage('Analytics preferences updated');
              },
            ),

            Divider(height: 2.h),

            // Location Tracking
            _buildPrivacyToggle(
              'Location Services',
              'Allow location access to find nearby donation centers',
              locationTracking,
              'location_on',
              (value) {
                setState(() {
                  locationTracking = value;
                });
                _showPrivacyUpdateMessage('Location preferences updated');
              },
            ),

            Divider(height: 2.h),

            // Personalized Content
            _buildPrivacyToggle(
              'Personalized Content',
              'Receive content tailored to your donation history and preferences',
              personalizedContent,
              'person',
              (value) {
                setState(() {
                  personalizedContent = value;
                });
                _showPrivacyUpdateMessage('Content preferences updated');
              },
            ),

            SizedBox(height: 2.h),

            // Privacy Policy Link
            _buildPrivacyPolicySection(),

            SizedBox(height: 2.h),

            // Data Export/Delete
            _buildDataManagementSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle(
    String title,
    String description,
    bool value,
    String iconName,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                description,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPrivacyPolicySection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'description',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Privacy Information',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'Learn more about how we protect your privacy and handle your data.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening Privacy Policy...')),
                    );
                  },
                  child: Text('Privacy Policy'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening Terms of Service...')),
                    );
                  },
                  child: Text('Terms of Service'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSection() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.errorContainer
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'folder_delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Data Management',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'You have the right to export or delete your personal data.',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showExportDataDialog(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'download',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Export Data'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDeleteAccountDialog(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.error),
                    foregroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'delete_forever',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text('Delete Account'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPrivacyUpdateMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showExportDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Your Data'),
          content: Text(
            'We will prepare a file containing all your personal data and donation history. This may take a few minutes.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Data export started. You will receive an email when ready.'),
                    duration: Duration(seconds: 4),
                  ),
                );
              },
              child: Text('Export'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
          ),
          content: Text(
            'This action cannot be undone. All your data, including donation history, will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Account deletion request submitted'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
              ),
              child: Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }
}
