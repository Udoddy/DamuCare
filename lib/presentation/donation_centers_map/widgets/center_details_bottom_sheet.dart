import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/app_export.dart';

class CenterDetailsBottomSheet extends StatefulWidget {
  final Map<String, dynamic> center;
  final VoidCallback onClose;

  const CenterDetailsBottomSheet({
    Key? key,
    required this.center,
    required this.onClose,
  }) : super(key: key);

  @override
  State<CenterDetailsBottomSheet> createState() =>
      _CenterDetailsBottomSheetState();
}

class _CenterDetailsBottomSheetState extends State<CenterDetailsBottomSheet> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openDirections(String address) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': address},
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final center = widget.center;
    final isOpen = center['isOpen'] as bool;
    final rating = center['rating'] as double;
    final distance = center['distance'] as double;
    final facilities = (center['facilities'] as List).cast<String>();

    return DraggableScrollableSheet(
      controller: _controller,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: EdgeInsets.only(top: 1.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Center Details',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center image
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomImageWidget(
                                imageUrl: center['image'] as String,
                                width: double.infinity,
                                height: 25.h,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Status badge
                            Positioned(
                              top: 2.h,
                              right: 4.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: isOpen
                                      ? AppTheme.getSuccessColor(true)
                                      : AppTheme.lightTheme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      isOpen ? 'Open Now' : 'Closed',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 3.h),

                      // Center name and rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              center['name'] as String,
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.getAccentColor(true),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: AppTheme.getWarningColor(true),
                                  size: 18,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 2.h),

                      // Distance
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${distance.toStringAsFixed(1)} km away',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Contact info section
                      _buildSectionHeader('Contact Information'),
                      SizedBox(height: 2.h),

                      _buildInfoRow(
                        'location_on',
                        'Address',
                        center['address'] as String,
                      ),

                      SizedBox(height: 2.h),

                      _buildInfoRow(
                        'phone',
                        'Phone',
                        center['phone'] as String,
                      ),

                      SizedBox(height: 3.h),

                      // Hours section
                      _buildSectionHeader('Operating Hours'),
                      SizedBox(height: 2.h),

                      _buildInfoRow(
                        'access_time',
                        'Hours',
                        center['hours'] as String,
                      ),

                      SizedBox(height: 3.h),

                      // Facilities section
                      _buildSectionHeader('Available Facilities'),
                      SizedBox(height: 2.h),

                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: facilities.map((facility) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: _getFacilityIcon(facility),
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 16,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  facility,
                                  style: AppTheme
                                      .lightTheme.textTheme.labelMedium
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: 4.h),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  _makePhoneCall(center['phone'] as String),
                              icon: CustomIconWidget(
                                iconName: 'phone',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 20,
                              ),
                              label: Text(
                                'Call Center',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _openDirections(center['address'] as String),
                              icon: CustomIconWidget(
                                iconName: 'directions',
                                color: Colors.white,
                                size: 20,
                              ),
                              label: Text(
                                'Get Directions',
                                style: AppTheme.lightTheme.textTheme.labelLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  Widget _buildInfoRow(String iconName, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFacilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case 'air conditioning':
        return 'ac_unit';
      case 'parking':
        return 'local_parking';
      case 'wheelchair access':
        return 'accessible';
      case 'cafeteria':
        return 'restaurant';
      case 'emergency services':
        return 'local_hospital';
      case 'laboratory':
        return 'science';
      case 'pharmacy':
        return 'local_pharmacy';
      default:
        return 'check_circle';
    }
  }
}
