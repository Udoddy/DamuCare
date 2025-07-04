import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicationsWidget extends StatelessWidget {
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onDataChanged;

  const MedicationsWidget({
    Key? key,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  final List<Map<String, dynamic>> commonMedications = const [
    {
      "id": "aspirin",
      "name": "Aspirin",
      "description": "Pain reliever and blood thinner"
    },
    {
      "id": "antibiotics",
      "name": "Antibiotics",
      "description": "For bacterial infections"
    },
    {
      "id": "blood_thinners",
      "name": "Blood Thinners",
      "description": "Warfarin, Heparin, etc."
    },
    {
      "id": "insulin",
      "name": "Insulin",
      "description": "For diabetes management"
    },
    {
      "id": "bp_medication",
      "name": "Blood Pressure Medication",
      "description": "ACE inhibitors, Beta blockers"
    },
    {
      "id": "antidepressants",
      "name": "Antidepressants",
      "description": "SSRIs, MAOIs, etc."
    },
    {
      "id": "steroids",
      "name": "Steroids",
      "description": "Corticosteroids or anabolic steroids"
    },
    {
      "id": "immunosuppressants",
      "name": "Immunosuppressants",
      "description": "For autoimmune conditions"
    },
  ];

  final List<Map<String, dynamic>> commonAllergies = const [
    {"id": "penicillin", "name": "Penicillin"},
    {"id": "latex", "name": "Latex"},
    {"id": "iodine", "name": "Iodine"},
    {"id": "food_allergies", "name": "Food Allergies"},
    {"id": "seasonal", "name": "Seasonal Allergies"},
    {"id": "other", "name": "Other Allergies"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medications & Allergies',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Information about current medications and known allergies',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Current medications
          _buildSectionCard(
            context,
            title: 'Current Medications',
            subtitle: 'Are you currently taking any medications?',
            icon: 'medication',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select all medications you are currently taking:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                CheckboxListTile(
                  title: Text('No current medications'),
                  value: (formData['currentMedications'] as List<String>? ?? [])
                      .isEmpty,
                  onChanged: (checked) {
                    if (checked == true) {
                      onDataChanged('currentMedications', <String>[]);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                SizedBox(height: 1.h),
                ...commonMedications.map((medication) => CheckboxListTile(
                      title: Text(medication['name']),
                      subtitle: Text(
                        medication['description'],
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      value: (formData['currentMedications'] as List<String>? ??
                              [])
                          .contains(medication['id']),
                      onChanged: (checked) {
                        List<String> current = List<String>.from(
                            formData['currentMedications'] ?? []);
                        if (checked == true) {
                          current.add(medication['id']);
                        } else {
                          current.remove(medication['id']);
                        }
                        onDataChanged('currentMedications', current);
                      },
                      contentPadding: EdgeInsets.zero,
                    )),
                SizedBox(height: 2.h),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Other medications not listed above',
                    helperText: 'Include dosage and frequency if applicable',
                  ),
                  maxLines: 2,
                  onChanged: (value) =>
                      onDataChanged('otherMedications', value),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Allergies
          _buildSectionCard(
            context,
            title: 'Known Allergies',
            subtitle: 'Do you have any known allergies?',
            icon: 'warning',
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text('No known allergies'),
                  value: false,
                  groupValue: formData['hasAllergies'],
                  onChanged: (value) {
                    onDataChanged('hasAllergies', value);
                    if (value == false) {
                      onDataChanged('allergies', <String>[]);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<bool>(
                  title: Text('Yes, I have allergies'),
                  value: true,
                  groupValue: formData['hasAllergies'],
                  onChanged: (value) => onDataChanged('hasAllergies', value),
                  contentPadding: EdgeInsets.zero,
                ),
                if (formData['hasAllergies'] == true) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Select all allergies that apply:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...commonAllergies.map((allergy) => CheckboxListTile(
                        title: Text(allergy['name']),
                        value: (formData['allergies'] as List<String>? ?? [])
                            .contains(allergy['id']),
                        onChanged: (checked) {
                          List<String> current =
                              List<String>.from(formData['allergies'] ?? []);
                          if (checked == true) {
                            current.add(allergy['id']);
                          } else {
                            current.remove(allergy['id']);
                          }
                          onDataChanged('allergies', current);
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                  SizedBox(height: 2.h),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Describe other allergies and reactions',
                      helperText: 'Include severity and symptoms',
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        onDataChanged('allergyDetails', value),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Additional information
          _buildSectionCard(
            context,
            title: 'Additional Information',
            subtitle: 'Any other relevant health information',
            icon: 'note_add',
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Any other health information we should know?',
                helperText: 'Optional - include any relevant details',
              ),
              maxLines: 4,
              onChanged: (value) => onDataChanged('additionalInfo', value),
            ),
          ),

          SizedBox(height: 4.h),

          // Disclaimer
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'This eligibility checker provides preliminary guidance only. Final eligibility will be determined by medical professionals at the donation center.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
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
