import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> centers;
  final Map<String, dynamic>? selectedCenter;
  final Function(Map<String, dynamic>) onCenterSelected;
  final VoidCallback onRecenter;

  const MapViewWidget({
    Key? key,
    required this.centers,
    this.selectedCenter,
    required this.onCenterSelected,
    required this.onRecenter,
  }) : super(key: key);

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Container (Simulated)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.green.shade100,
                Colors.blue.shade50,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Simulated map background with grid pattern
              CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: MapGridPainter(),
              ),

              // Center markers
              ...widget.centers.asMap().entries.map((entry) {
                final index = entry.key;
                final center = entry.value;
                final isSelected = widget.selectedCenter?['id'] == center['id'];

                return Positioned(
                  left: (20 + (index * 15)) % 80.w,
                  top: (30 + (index * 20)) % 60.h,
                  child: GestureDetector(
                    onTap: () => widget.onCenterSelected(center),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()
                        ..scale(isSelected ? 1.2 : 1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Info window (shown when selected)
                          if (isSelected)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              margin: EdgeInsets.only(bottom: 1.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    center['name'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'location_on',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 12,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${center['distance']} km',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: (center['isOpen'] as bool)
                                              ? AppTheme.getSuccessColor(true)
                                              : AppTheme
                                                  .lightTheme.colorScheme.error,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        (center['isOpen'] as bool)
                                            ? 'Open'
                                            : 'Closed',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: (center['isOpen'] as bool)
                                              ? AppTheme.getSuccessColor(true)
                                              : AppTheme
                                                  .lightTheme.colorScheme.error,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // Map pin
                          Container(
                            width: isSelected ? 40 : 32,
                            height: isSelected ? 40 : 32,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CustomIconWidget(
                              iconName: 'local_hospital',
                              color: Colors.white,
                              size: isSelected ? 20 : 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              // User location (blue dot)
              Positioned(
                left: 40.w,
                top: 40.h,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Recenter button
        Positioned(
          right: 4.w,
          bottom: 12.h,
          child: FloatingActionButton(
            onPressed: widget.onRecenter,
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.lightTheme.primaryColor,
            elevation: 4,
            child: CustomIconWidget(
              iconName: 'my_location',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
        ),

        // Offline indicator
        Positioned(
          top: 2.h,
          left: 4.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'wifi_off',
                  color: AppTheme.getWarningColor(true),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Offline Mode',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.getWarningColor(true),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw some roads/paths
    final roadPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
