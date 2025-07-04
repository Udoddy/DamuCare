import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/donation_countdown_card_widget.dart';
import './widgets/donation_streak_calendar_widget.dart';
import './widgets/educational_articles_widget.dart';
import './widgets/impact_tracker_card_widget.dart';
import './widgets/quick_action_buttons_widget.dart';
import './widgets/testimonials_section_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _selectedIndex = 0;
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Lucy Mwangi",
    "eligibilityStatus": "eligible", // eligible, soon, not_eligible
    "nextDonationDate": "2024-02-15",
    "totalDonations": 3,
    "currentStreak": 2,
    "lastDonationDate": "2023-11-15",
    "estimatedLivesSaved": 9,
  };

  final List<Map<String, dynamic>> educationalArticles = [
    {
      "id": 1,
      "title": "Jinsi ya Kujiandaa kwa Kutoa Damu",
      "thumbnail":
          "https://images.pexels.com/photos/6823568/pexels-photo-6823568.jpeg?auto=compress&cs=tinysrgb&w=400",
      "readTime": "5 min",
      "category": "Preparation"
    },
    {
      "id": 2,
      "title": "Benefits of Regular Blood Donation",
      "thumbnail":
          "https://images.pexels.com/photos/4386467/pexels-photo-4386467.jpeg?auto=compress&cs=tinysrgb&w=400",
      "readTime": "3 min",
      "category": "Health"
    },
    {
      "id": 3,
      "title": "Mahitaji ya Damu Tanzania",
      "thumbnail":
          "https://images.pexels.com/photos/6823564/pexels-photo-6823564.jpeg?auto=compress&cs=tinysrgb&w=400",
      "readTime": "4 min",
      "category": "Statistics"
    }
  ];

  final List<Map<String, dynamic>> testimonials = [
    {
      "id": 1,
      "name": "Amina Hassan",
      "location": "Dar es Salaam",
      "photo":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "story":
          "Kutoa damu ni jambo la kawaida kwangu. Najua nina msaada mtu mwingine kupona.",
      "donationCount": 12
    },
    {
      "id": 2,
      "name": "John Mwalimu",
      "location": "Arusha",
      "photo":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "story":
          "Started donating after my sister needed blood. Now I donate regularly to help others.",
      "donationCount": 8
    }
  ];

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  Color _getEligibilityColor() {
    switch (userData["eligibilityStatus"]) {
      case "eligible":
        return AppTheme.getSuccessColor(true);
      case "soon":
        return AppTheme.getWarningColor(true);
      case "not_eligible":
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getEligibilityText() {
    switch (userData["eligibilityStatus"]) {
      case "eligible":
        return "Eligible to Donate";
      case "soon":
        return "Eligible Soon";
      case "not_eligible":
        return "Not Eligible";
      default:
        return "Unknown Status";
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/donation-centers-map');
        break;
      case 2:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 3:
        Navigator.pushNamed(context, '/donation-history');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              // Sticky Header
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                expandedHeight: 12.h,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Habari ${userData["name"] ?? "User"}!",
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color:
                                _getEligibilityColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getEligibilityColor(),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getEligibilityText(),
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: _getEligibilityColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 2.h),

                    // Donation Countdown Card
                    DonationCountdownCardWidget(
                      nextDonationDate: userData["nextDonationDate"] ?? "",
                      eligibilityStatus:
                          userData["eligibilityStatus"] ?? "unknown",
                    ),

                    SizedBox(height: 3.h),

                    // Quick Action Buttons
                    QuickActionButtonsWidget(
                      onFindCenters: () =>
                          Navigator.pushNamed(context, '/donation-centers-map'),
                      onBookAppointment: () =>
                          Navigator.pushNamed(context, '/appointment-booking'),
                      onCheckEligibility: () =>
                          Navigator.pushNamed(context, '/eligibility-checker'),
                    ),

                    SizedBox(height: 3.h),

                    // Educational Articles
                    EducationalArticlesWidget(articles: educationalArticles),

                    SizedBox(height: 3.h),

                    // Donation Streak Calendar
                    DonationStreakCalendarWidget(
                      currentStreak: userData["currentStreak"] ?? 0,
                      lastDonationDate: userData["lastDonationDate"] ?? "",
                    ),

                    SizedBox(height: 3.h),

                    // Impact Tracker Card
                    ImpactTrackerCardWidget(
                      totalDonations: userData["totalDonations"] ?? 0,
                      estimatedLivesSaved: userData["estimatedLivesSaved"] ?? 0,
                    ),

                    SizedBox(height: 3.h),

                    // Testimonials Section
                    TestimonialsSectionWidget(testimonials: testimonials),

                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _selectedIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'location_on',
              color: _selectedIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Centers',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: _selectedIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: _selectedIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/appointment-booking'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
