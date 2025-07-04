import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_confirmation_widget.dart';
import './widgets/booking_progress_widget.dart';
import './widgets/center_selection_widget.dart';
import './widgets/date_time_selection_widget.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking>
    with TickerProviderStateMixin {
  int currentStep = 0;
  Map<String, dynamic>? selectedCenter;
  DateTime? selectedDate;
  String? selectedTime;
  late TabController _tabController;

  // Mock data for donation centers
  final List<Map<String, dynamic>> donationCenters = [
    {
      "id": 1,
      "name": "Muhimbili National Hospital Blood Bank",
      "address": "United Nations Rd, Dar es Salaam",
      "distance": "2.3 km",
      "availability": "High",
      "rating": 4.8,
      "image":
          "https://images.pexels.com/photos/263402/pexels-photo-263402.jpeg",
      "phone": "+255 22 215 0302",
      "hours": "Mon-Fri: 8:00 AM - 4:00 PM",
      "facilities": ["Air Conditioning", "Parking", "Wheelchair Access"],
      "nextAvailable": "Today",
    },
    {
      "id": 2,
      "name": "Kilimanjaro Christian Medical Centre",
      "address": "Moshi, Kilimanjaro Region",
      "distance": "5.1 km",
      "availability": "Medium",
      "rating": 4.6,
      "image":
          "https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg",
      "phone": "+255 27 275 4377",
      "hours": "Mon-Sat: 7:30 AM - 5:00 PM",
      "facilities": ["Parking", "Cafeteria", "Wi-Fi"],
      "nextAvailable": "Tomorrow",
    },
    {
      "id": 3,
      "name": "Bugando Medical Centre",
      "address": "Mwanza, Mwanza Region",
      "distance": "8.7 km",
      "availability": "Low",
      "rating": 4.4,
      "image":
          "https://images.pexels.com/photos/356040/pexels-photo-356040.jpeg",
      "phone": "+255 28 250 0854",
      "hours": "Mon-Fri: 8:00 AM - 3:30 PM",
      "facilities": ["Emergency Services", "Parking"],
      "nextAvailable": "Next Week",
    },
  ];

  // Mock available time slots
  final List<String> timeSlots = [
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
      _tabController.animateTo(currentStep);
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _tabController.animateTo(currentStep);
    }
  }

  void _onCenterSelected(Map<String, dynamic> center) {
    setState(() {
      selectedCenter = center;
    });
  }

  void _onDateTimeSelected(DateTime date, String time) {
    setState(() {
      selectedDate = date;
      selectedTime = time;
    });
  }

  void _confirmBooking() {
    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.getSuccessColor(true),
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Booking Confirmed!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your appointment has been successfully booked.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reference: #BD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'SMS confirmation will be sent to your registered number.',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home-dashboard');
              },
              child: Text('Go to Dashboard'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/donation-history');
              },
              child: Text('View History'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Booking Help'),
                  content: Text(
                    'Follow these steps:\n1. Select a donation center\n2. Choose date and time\n3. Confirm your booking',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          BookingProgressWidget(
            currentStep: currentStep,
            totalSteps: 3,
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Step 1: Center Selection
                CenterSelectionWidget(
                  centers: donationCenters,
                  selectedCenter: selectedCenter,
                  onCenterSelected: _onCenterSelected,
                ),

                // Step 2: Date/Time Selection
                DateTimeSelectionWidget(
                  selectedCenter: selectedCenter,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  timeSlots: timeSlots,
                  onDateTimeSelected: _onDateTimeSelected,
                ),

                // Step 3: Booking Confirmation
                BookingConfirmationWidget(
                  selectedCenter: selectedCenter,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                ),
              ],
            ),
          ),

          // Bottom navigation buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Previous'),
                      ),
                    ),
                  if (currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _getNextButtonAction(),
                      child: Text(_getNextButtonText()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback? _getNextButtonAction() {
    switch (currentStep) {
      case 0:
        return selectedCenter != null ? _nextStep : null;
      case 1:
        return (selectedDate != null && selectedTime != null)
            ? _nextStep
            : null;
      case 2:
        return _confirmBooking;
      default:
        return null;
    }
  }

  String _getNextButtonText() {
    switch (currentStep) {
      case 0:
        return 'Select Date & Time';
      case 1:
        return 'Review Booking';
      case 2:
        return 'Confirm Booking';
      default:
        return 'Next';
    }
  }
}
