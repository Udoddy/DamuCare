import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivitiesWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onDataChanged;

  const RecentActivitiesWidget({
    Key? key,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> malariaRiskCountries = const [
    {"id": "kenya", "name": "Kenya"},
    {"id": "uganda", "name": "Uganda"},
    {"id": "rwanda", "name": "Rwanda"},
    {"id": "burundi", "name": "Burundi"},
    {"id": "drc", "name": "Democratic Republic of Congo"},
    {"id": "malawi", "name": "Malawi"},
    {"id": "zambia", "name": "Zambia"},
    {"id": "mozambique", "name": "Mozambique"},
    {"id": "madagascar", "name": "Madagascar"},
    {"id": "other", "name": "Other malaria-endemic country"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activities',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Recent travel, procedures, and previous donations',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Recent travel
          _buildSectionCard(
            context,
            title: 'Recent Travel',
            subtitle:
                'Have you traveled outside Tanzania in the past 3 months?',
            icon: 'flight',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No recent travel'),
                  value: false,
                  groupValue: formData['hasRecentTravel'],
                  onChanged: (value) {
                    onDataChanged('hasRecentTravel', value);
                    if (value == false) {
                      onDataChanged('recentTravelCountries', <String>[]);
                      onDataChanged('travelDate', null);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I traveled recently'),
                  value: true,
                  groupValue: formData['hasRecentTravel'],
                  onChanged: (value) => onDataChanged('hasRecentTravel', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasRecentTravel'] == true) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Select countries visited:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...malariaRiskCountries.map((country) => CheckboxListTile(
                        title: Text(country['name']),
                        value: (formData['recentTravelCountries']
                                    as List<String>? ??
                                [])
                            .contains(country['id']),
                        onChanged: (checked) {
                          List<String> current = List<String>.from(
                              formData['recentTravelCountries'] ?? []);
                          if (checked == true) {
                            current.add(country['id']);
                          } else {
                            current.remove(country['id']);
                          }
                          onDataChanged('recentTravelCountries', current);
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Return date (DD/MM/YYYY)',
                      suffixIcon: CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(Duration(days: 30)),
                        firstDate: DateTime.now().subtract(Duration(days: 90)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        onDataChanged('travelDate', date);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Recent tattoo/piercing
          _buildSectionCard(
            context,
            title: 'Recent Tattoo or Piercing',
            subtitle:
                'Have you gotten a tattoo or piercing in the past 6 months?',
            icon: 'brush',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No recent tattoo/piercing'),
                  value: false,
                  groupValue: formData['hasRecentTattoo'],
                  onChanged: (value) {
                    onDataChanged('hasRecentTattoo', value);
                    if (value == false) {
                      onDataChanged('tattooDate', null);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I got a tattoo/piercing'),
                  value: true,
                  groupValue: formData['hasRecentTattoo'],
                  onChanged: (value) => onDataChanged('hasRecentTattoo', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasRecentTattoo'] == true) ...[
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Date of tattoo/piercing (DD/MM/YYYY)',
                      suffixIcon: CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(Duration(days: 30)),
                        firstDate: DateTime.now().subtract(Duration(days: 180)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        onDataChanged('tattooDate', date);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Previous blood donation
          _buildSectionCard(
            context,
            title: 'Previous Blood Donation',
            subtitle: 'Have you donated blood in the past 8 weeks?',
            icon: 'bloodtype',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No recent donation'),
                  value: false,
                  groupValue: formData['hasRecentDonation'],
                  onChanged: (value) {
                    onDataChanged('hasRecentDonation', value);
                    if (value == false) {
                      onDataChanged('lastDonationDate', null);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I donated recently'),
                  value: true,
                  groupValue: formData['hasRecentDonation'],
                  onChanged: (value) =>
                      onDataChanged('hasRecentDonation', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasRecentDonation'] == true) ...[
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Last donation date (DD/MM/YYYY)',
                      helperText: 'Must wait 8 weeks between donations',
                      suffixIcon: CustomIconWidget(
                        iconName: 'calendar_today',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(Duration(days: 30)),
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        onDataChanged('lastDonationDate', date);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String icon,
    required Widget child,
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
                CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            child,
          ],
        ),
      ),
    );
  }
}
