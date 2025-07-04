import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupportSectionWidget extends StatelessWidget {
  const SupportSectionWidget({Key? key}) : super(key: key);

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
                  iconName: 'support_agent',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Support & Help',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // FAQ
            _buildSupportOption(
              context,
              'Frequently Asked Questions',
              'Find answers to common questions about blood donation',
              'help',
              () => _showFAQDialog(context),
            ),

            Divider(height: 2.h),

            // Contact Support
            _buildSupportOption(
              context,
              'Contact Support',
              'Get help from our support team',
              'contact_support',
              () => _showContactDialog(context),
            ),

            Divider(height: 2.h),

            // Send Feedback
            _buildSupportOption(
              context,
              'Send Feedback',
              'Share your thoughts and suggestions',
              'feedback',
              () => _showFeedbackDialog(context),
            ),

            Divider(height: 2.h),

            // Report Issue
            _buildSupportOption(
              context,
              'Report an Issue',
              'Report bugs or technical problems',
              'bug_report',
              () => _showReportIssueDialog(context),
            ),

            SizedBox(height: 2.h),

            // App Information
            _buildAppInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(
    BuildContext context,
    String title,
    String subtitle,
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
                  subtitle,
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

  Widget _buildAppInfoSection(BuildContext context) {
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
                iconName: 'info',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                'App Information',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildInfoRow('Version', '1.0.0'),
          _buildInfoRow('Build', '2024.01.15'),
          _buildInfoRow('Developer', 'DamuCare Team'),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Opening app store...')),
                    );
                  },
                  child: Text('Rate App'),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Checking for updates...')),
                    );
                  },
                  child: Text('Check Updates'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showFAQDialog(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'How often can I donate blood?',
        'answer':
            'You can donate whole blood every 56 days (8 weeks). This allows your body time to replenish the donated blood.',
      },
      {
        'question': 'What should I do before donating?',
        'answer':
            'Eat a healthy meal, drink plenty of water, get a good night\'s sleep, and bring a valid ID.',
      },
      {
        'question': 'How long does the donation process take?',
        'answer':
            'The entire process takes about 45-60 minutes, with the actual donation taking only 8-10 minutes.',
      },
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Frequently Asked Questions'),
          content: Container(
            width: double.maxFinite,
            height: 40.h,
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return ExpansionTile(
                  title: Text(
                    faq['question']!,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Text(
                        faq['answer']!,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Get in touch with our support team:'),
              SizedBox(height: 2.h),
              _buildContactMethod('Email', 'support@damucare.co.tz', 'email'),
              SizedBox(height: 1.h),
              _buildContactMethod('Phone', '+255 123 456 789', 'phone'),
              SizedBox(height: 1.h),
              _buildContactMethod('WhatsApp', '+255 123 456 789', 'chat'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactMethod(String method, String contact, String iconName) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 16,
        ),
        SizedBox(width: 2.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              method,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              contact,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('We value your feedback! Help us improve DamuCare.'),
              SizedBox(height: 2.h),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Share your thoughts, suggestions, or experiences...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                  SnackBar(content: Text('Thank you for your feedback!')),
                );
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }

  void _showReportIssueDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report an Issue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Describe the issue you encountered:'),
              SizedBox(height: 2.h),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Please describe the problem in detail...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
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
                      content:
                          Text('Issue report submitted. We\'ll look into it.')),
                );
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
