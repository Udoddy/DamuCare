import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthStatusWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onDataChanged;

  const HealthStatusWidget({
    Key? key,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> chronicConditions = const [
    {
      "id": "diabetes",
      "name": "Diabetes",
      "description": "Type 1 or Type 2 diabetes"
    },
    {
      "id": "hypertension",
      "name": "High Blood Pressure",
      "description": "Chronic hypertension"
    },
    {
      "id": "heart_disease",
      "name": "Heart Disease",
      "description": "Any cardiovascular condition"
    },
    {
      "id": "kidney_disease",
      "name": "Kidney Disease",
      "description": "Chronic kidney problems"
    },
    {
      "id": "liver_disease",
      "name": "Liver Disease",
      "description": "Hepatitis or other liver conditions"
    },
    {
      "id": "cancer",
      "name": "Cancer",
      "description": "Current or recent cancer treatment"
    },
    {
      "id": "hiv_aids",
      "name": "HIV/AIDS",
      "description": "HIV positive status"
    },
    {
      "id": "bleeding_disorder",
      "name": "Bleeding Disorder",
      "description": "Hemophilia or similar conditions"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Status',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your health information helps us ensure safe donation',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Chronic conditions
          _buildSectionCard(
            context,
            title: 'Chronic Health Conditions',
            subtitle: 'Do you have any ongoing health conditions?',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No chronic conditions'),
                  value: false,
                  groupValue: formData['hasChronicConditions'],
                  onChanged: (value) {
                    onDataChanged('hasChronicConditions', value);
                    if (value == false) {
                      onDataChanged('chronicConditions', <String>[]);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I have chronic conditions'),
                  value: true,
                  groupValue: formData['hasChronicConditions'],
                  onChanged: (value) =>
                      onDataChanged('hasChronicConditions', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasChronicConditions'] == true) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Select all that apply:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...chronicConditions.map((condition) => CheckboxListTile(
                        title: Text(condition['name']),
                        subtitle: Text(
                          condition['description'],
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        value:
                            (formData['chronicConditions'] as List<String>? ??
                                    [])
                                .contains(condition['id']),
                        onChanged: (checked) {
                          List<String> current = List<String>.from(
                              formData['chronicConditions'] ?? []);
                          if (checked == true) {
                            current.add(condition['id']);
                          } else {
                            current.remove(condition['id']);
                          }
                          onDataChanged('chronicConditions', current);
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                ],
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Recent illness
          _buildSectionCard(
            context,
            title: 'Recent Illness',
            subtitle: 'Have you been sick in the past 2 weeks?',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No recent illness'),
                  value: false,
                  groupValue: formData['hasRecentIllness'],
                  onChanged: (value) {
                    onDataChanged('hasRecentIllness', value);
                    if (value == false) {
                      onDataChanged('recentIllnessDetails', '');
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I was recently sick'),
                  value: true,
                  groupValue: formData['hasRecentIllness'],
                  onChanged: (value) =>
                      onDataChanged('hasRecentIllness', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasRecentIllness'] == true) ...[
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Describe your recent illness',
                      helperText: 'Include symptoms and recovery status',
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        onDataChanged('recentIllnessDetails', value),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Recent surgery
          _buildSectionCard(
            context,
            title: 'Recent Surgery',
            subtitle: 'Have you had surgery in the past 6 months?',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No recent surgery'),
                  value: false,
                  groupValue: formData['hasRecentSurgery'],
                  onChanged: (value) {
                    onDataChanged('hasRecentSurgery', value);
                    if (value == false) {
                      onDataChanged('recentSurgeryDate', null);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I had recent surgery'),
                  value: true,
                  groupValue: formData['hasRecentSurgery'],
                  onChanged: (value) =>
                      onDataChanged('hasRecentSurgery', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasRecentSurgery'] == true) ...[
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Surgery date (DD/MM/YYYY)',
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
                        onDataChanged('recentSurgeryDate', date);
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          // Gender-specific questions
          if (formData['gender'] == 'female') ...[
            SizedBox(height: 2.h),
            _buildSectionCard(
              context,
              title: 'Pregnancy Status',
              subtitle: 'Current pregnancy or breastfeeding status',
              child: Column(
                children: [
                  CheckboxListTile(
                    title: Text('I am currently pregnant'),
                    value: formData['isPregnant'] ?? false,
                    onChanged: (value) => onDataChanged('isPregnant', value),
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: Text('I am currently breastfeeding'),
                    value: formData['isBreastfeeding'] ?? false,
                    onChanged: (value) =>
                        onDataChanged('isBreastfeeding', value),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
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
                  iconName: 'health_and_safety',
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
