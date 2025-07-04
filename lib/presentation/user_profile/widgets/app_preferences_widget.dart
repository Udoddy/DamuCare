import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesWidget extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AppPreferencesWidget({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<AppPreferencesWidget> createState() => _AppPreferencesWidgetState();
}

class _AppPreferencesWidgetState extends State<AppPreferencesWidget> {
  late Map<String, dynamic> preferences;

  @override
  void initState() {
    super.initState();
    final prefData = widget.userData["preferences"] as Map<String, dynamic>?;
    preferences = {
      'offlineContent': prefData?["offlineContent"] as bool? ?? true,
      'dataUsage': prefData?["dataUsage"] as String? ?? "wifi_only",
      'accessibility': prefData?["accessibility"] as bool? ?? false,
    };
  }

  void _updatePreference(String key, dynamic value) {
    setState(() {
      preferences[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('App preferences updated'),
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
                  iconName: 'settings',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'App Preferences',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Offline Content
            _buildTogglePreference(
              'Offline Content',
              'Download educational content for offline viewing',
              'offlineContent',
              preferences['offlineContent'] as bool? ?? false,
              'download',
            ),

            Divider(height: 2.h),

            // Data Usage Settings
            _buildDataUsagePreference(),

            Divider(height: 2.h),

            // Accessibility Options
            _buildTogglePreference(
              'Accessibility Features',
              'Enable enhanced accessibility options',
              'accessibility',
              preferences['accessibility'] as bool? ?? false,
              'accessibility',
            ),

            SizedBox(height: 2.h),

            // Storage Info
            _buildStorageInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildTogglePreference(
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
          onChanged: (newValue) => _updatePreference(key, newValue),
        ),
      ],
    );
  }

  Widget _buildDataUsagePreference() {
    final currentDataUsage = preferences['dataUsage'] as String? ?? "wifi_only";

    return GestureDetector(
      onTap: _showDataUsageDialog,
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'data_usage',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 18,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Usage',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _getDataUsageDescription(currentDataUsage),
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

  Widget _buildStorageInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'storage',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'Storage Usage',
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
                'Offline Content:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '24.5 MB',
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
                'Cache:',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '8.2 MB',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cache cleared successfully')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.h),
              ),
              child: Text('Clear Cache'),
            ),
          ),
        ],
      ),
    );
  }

  String _getDataUsageDescription(String dataUsage) {
    switch (dataUsage) {
      case 'wifi_only':
        return 'Download content only on Wi-Fi';
      case 'mobile_data':
        return 'Use mobile data for downloads';
      case 'ask_always':
        return 'Ask before using mobile data';
      default:
        return 'Wi-Fi only';
    }
  }

  void _showDataUsageDialog() {
    final options = [
      {
        'value': 'wifi_only',
        'title': 'Wi-Fi Only',
        'subtitle': 'Download content only on Wi-Fi'
      },
      {
        'value': 'mobile_data',
        'title': 'Mobile Data',
        'subtitle': 'Use mobile data for downloads'
      },
      {
        'value': 'ask_always',
        'title': 'Ask Always',
        'subtitle': 'Ask before using mobile data'
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Data Usage Preference'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              final isSelected = preferences['dataUsage'] == option['value'];
              return RadioListTile<String>(
                title: Text(option['title'] as String),
                subtitle: Text(option['subtitle'] as String),
                value: option['value'] as String,
                groupValue: preferences['dataUsage'] as String,
                onChanged: (value) {
                  _updatePreference('dataUsage', value);
                  Navigator.of(context).pop();
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
