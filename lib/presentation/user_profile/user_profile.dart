import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_preferences_widget.dart';
import './widgets/authentication_section_widget.dart';
import './widgets/donation_preferences_widget.dart';
import './widgets/language_settings_widget.dart';
import './widgets/notification_preferences_widget.dart';
import './widgets/privacy_settings_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/support_section_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 4; // Profile tab is active (index 4)

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Lucy Mwangi",
    "email": "lucy.mwangi@gmail.com",
    "phone": "+255 712 345 678",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "location": "Arusha, Tanzania",
    "bloodType": "O+",
    "emergencyContact": {
      "name": "John Mwangi",
      "phone": "+255 712 987 654",
      "relationship": "Brother"
    },
    "donationCount": 3,
    "lastDonation": "2024-01-15",
    "preferredLanguage": "English",
    "notifications": {
      "appointments": true,
      "eligibility": true,
      "educational": false,
      "impact": true
    },
    "preferences": {
      "offlineContent": true,
      "dataUsage": "wifi_only",
      "accessibility": false
    },
    "authMethod": "email"
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 4);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/donation-centers-map');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/eligibility-checker');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/appointment-booking');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/donation-history');
        break;
      case 5:
        // Already on profile screen
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to logout from DamuCare?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(userData: userData),

            SizedBox(height: 2.h),

            // Settings Sections
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
                  // Personal Information Section
                  SettingsSectionWidget(
                    title: 'Personal Information',
                    userData: userData,
                    onTap: () {
                      // Navigate to edit personal info
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit personal information')),
                      );
                    },
                  ),

                  SizedBox(height: 2.h),

                  // Notification Preferences
                  NotificationPreferencesWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // Language Settings
                  LanguageSettingsWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // App Preferences
                  AppPreferencesWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // Authentication Section
                  AuthenticationSectionWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // Donation Preferences
                  DonationPreferencesWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // Privacy Settings
                  PrivacySettingsWidget(userData: userData),

                  SizedBox(height: 2.h),

                  // Support Section
                  SupportSectionWidget(),

                  SizedBox(height: 3.h),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ElevatedButton(
                      onPressed: _showLogoutDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'logout',
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Logout',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        selectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedLabelStyle,
        unselectedLabelStyle:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedLabelStyle,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'location_on',
              color: _currentIndex == 1
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Centers',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'health_and_safety',
              color: _currentIndex == 2
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Eligibility',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _currentIndex == 3
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _currentIndex == 4
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 5
                  ? AppTheme
                      .lightTheme.bottomNavigationBarTheme.selectedItemColor!
                  : AppTheme
                      .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
