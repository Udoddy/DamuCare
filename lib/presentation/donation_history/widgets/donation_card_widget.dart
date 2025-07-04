import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonationCardWidget extends StatelessWidget {
  final Map<String, dynamic> donation;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onCertificateDownload;
  final VoidCallback onContextMenu;

  const DonationCardWidget({
    Key? key,
    required this.donation,
    required this.isExpanded,
    required this.onTap,
    required this.onCertificateDownload,
    required this.onContextMenu,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (donation['processingStage']) {
      case 'Completed':
      case 'Transfused':
      case 'Distributed':
        return AppTheme.getSuccessColor(true);
      case 'Processing':
        return AppTheme.getWarningColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon() {
    switch (donation['processingStage']) {
      case 'Completed':
      case 'Transfused':
        return Icons.check_circle;
      case 'Distributed':
        return Icons.local_shipping;
      case 'Processing':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onContextMenu,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildCardHeader(),
            if (isExpanded) _buildExpandedContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'favorite',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      donation['location'],
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${donation['date']} • ${donation['time']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      color: _getStatusColor(),
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      donation['processingStage'],
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              _buildInfoChip(
                icon: 'water_drop',
                label: donation['donationType'],
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              _buildInfoChip(
                icon: 'science',
                label: donation['volume'],
                color: AppTheme.getWarningColor(true),
              ),
              SizedBox(width: 2.w),
              _buildInfoChip(
                icon: 'people',
                label: '${donation['livesImpacted']} lives',
                color: AppTheme.getSuccessColor(true),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (donation['badgeEarned'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.getAccentColor(true),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'military_tech',
                        color: AppTheme.getSuccessColor(true),
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        donation['badgeEarned'],
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              CustomIconWidget(
                iconName: isExpanded ? 'expand_less' : 'expand_more',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            height: 1,
          ),
          SizedBox(height: 3.w),
          _buildDetailSection('Location Details', [
            _buildDetailRow('Address', donation['address']),
            _buildDetailRow('Certificate ID', donation['certificateId']),
          ]),
          SizedBox(height: 3.w),
          _buildDetailSection('Post-Donation Vitals', [
            _buildDetailRow(
                'Blood Pressure', donation['postVitals']['bloodPressure']),
            _buildDetailRow('Heart Rate', donation['postVitals']['heartRate']),
            _buildDetailRow(
                'Temperature', donation['postVitals']['temperature']),
          ]),
          SizedBox(height: 3.w),
          _buildDetailSection('Staff Notes', [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                donation['staffNotes'],
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
          ]),
          SizedBox(height: 4.w),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCertificateDownload,
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  label: Text('Download Certificate'),
                ),
              ),
              SizedBox(width: 3.w),
              ElevatedButton.icon(
                onPressed: () {
                  // Share certificate
                },
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: Colors.white,
                  size: 4.w,
                ),
                label: Text('Share'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.w),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
