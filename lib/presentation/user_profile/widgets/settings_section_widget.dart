import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> userData;
  final VoidCallback? onTap;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.userData,
    this.onTap,
  }) : super(key: key);

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
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Personal Information Items
            _buildInfoItem(
              context,
              'Full Name',
              userData["name"] as String? ?? "Not provided",
              'edit',
            ),

            Divider(height: 2.h),

            _buildInfoItem(
              context,
              'Email Address',
              userData["email"] as String? ?? "Not provided",
              'email',
            ),

            Divider(height: 2.h),

            _buildInfoItem(
              context,
              'Phone Number',
              userData["phone"] as String? ?? "Not provided",
              'phone',
            ),

            Divider(height: 2.h),

            _buildInfoItem(
              context,
              'Blood Type',
              userData["bloodType"] as String? ?? "Not provided",
              'bloodtype',
            ),

            Divider(height: 2.h),

            // Emergency Contact
            _buildEmergencyContact(context),

            SizedBox(height: 2.h),

            // Edit Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'edit',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text('Edit Information'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, String iconName) {
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
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyContact(BuildContext context) {
    final emergencyContact =
        userData["emergencyContact"] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 18,
            ),
            SizedBox(width: 3.w),
            Text(
              'Emergency Contact',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                emergencyContact?["name"] as String? ?? "Not provided",
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                emergencyContact?["phone"] as String? ?? "No phone number",
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                emergencyContact?["relationship"] as String? ??
                    "No relationship",
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
