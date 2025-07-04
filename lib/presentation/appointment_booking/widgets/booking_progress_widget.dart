import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BookingProgressWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const BookingProgressWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Step indicators
          Row(
            children: List.generate(totalSteps, (index) {
              final isActive = index <= currentStep;
              final isCompleted = index < currentStep;

              return Expanded(
                child: Row(
                  children: [
                    // Step circle
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.outline,
                        border: Border.all(
                          color: isActive
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: Colors.white,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: AppTheme.lightTheme.textTheme.labelMedium
                                    ?.copyWith(
                                  color: isActive
                                      ? Colors.white
                                      : AppTheme.lightTheme.colorScheme.outline,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    // Connecting line
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 1.h),

          // Step labels
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select Center',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 0
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Date & Time',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 1
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 1 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Confirmation',
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: currentStep >= 2
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        currentStep == 2 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
