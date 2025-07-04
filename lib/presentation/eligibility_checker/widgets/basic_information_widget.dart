import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BasicInformationWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onDataChanged;

  const BasicInformationWidget({
    Key? key,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Please provide your basic information to determine eligibility',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Age input
          _buildSectionCard(
            context,
            title: 'Age',
            subtitle: 'Must be between 18-65 years',
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your age',
                suffixIcon: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              onChanged: (value) {
                final age = int.tryParse(value);
                onDataChanged('age', age);
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Weight input
          _buildSectionCard(
            context,
            title: 'Weight',
            subtitle: 'Minimum weight requirement is 50kg',
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your weight (kg)',
                suffixIcon: CustomIconWidget(
                  iconName: 'monitor_weight',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              onChanged: (value) {
                final weight = double.tryParse(value);
                onDataChanged('weight', weight);
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Gender selection
          _buildSectionCard(
            context,
            title: 'Gender',
            subtitle: 'Select your gender',
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text('Male'),
                  value: 'male',
                  groupValue: formData['gender'],
                  onChanged: (value) => onDataChanged('gender', value),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('Female'),
                  value: 'female',
                  groupValue: formData['gender'],
                  onChanged: (value) => onDataChanged('gender', value),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  title: Text('Other'),
                  value: 'other',
                  groupValue: formData['gender'],
                  onChanged: (value) => onDataChanged('gender', value),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Blood type selection (optional)
          _buildSectionCard(
            context,
            title: 'Blood Type (Optional)',
            subtitle: 'If known, select your blood type',
            child: DropdownButtonFormField<String>(
              value: formData['bloodType'],
              decoration: InputDecoration(
                hintText: 'Select blood type',
              ),
              items:
                  ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown']
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
              onChanged: (value) => onDataChanged('bloodType', value),
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
                  iconName: 'info_outline',
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
