import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/center_details_bottom_sheet.dart';
import './widgets/list_view_widget.dart';
import './widgets/map_view_widget.dart';

class DonationCentersMap extends StatefulWidget {
  const DonationCentersMap({Key? key}) : super(key: key);

  @override
  State<DonationCentersMap> createState() => _DonationCentersMapState();
}

class _DonationCentersMapState extends State<DonationCentersMap>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isMapView = true;
  bool _isLoading = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _selectedCenter;

  // Mock data for donation centers
  final List<Map<String, dynamic>> _donationCenters = [
    {
      "id": 1,
      "name": "Muhimbili National Hospital Blood Bank",
      "address": "United Nations Rd, Dar es Salaam, Tanzania",
      "phone": "+255 22 215 0302",
      "latitude": -6.7924,
      "longitude": 39.2083,
      "distance": 2.3,
      "isOpen": true,
      "rating": 4.5,
      "hours": "Mon-Fri: 8:00 AM - 5:00 PM, Sat: 8:00 AM - 2:00 PM",
      "facilities": ["Air Conditioning", "Parking", "Wheelchair Access"],
      "image":
          "https://images.pexels.com/photos/263402/pexels-photo-263402.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdated": "2 hours ago"
    },
    {
      "id": 2,
      "name": "Kilimanjaro Christian Medical Centre",
      "address": "Moshi, Kilimanjaro, Tanzania",
      "phone": "+255 27 275 4377",
      "latitude": -3.3488,
      "longitude": 37.3439,
      "distance": 5.7,
      "isOpen": false,
      "rating": 4.2,
      "hours": "Mon-Fri: 7:30 AM - 4:30 PM, Sat: 8:00 AM - 1:00 PM",
      "facilities": ["Parking", "Cafeteria", "Emergency Services"],
      "image":
          "https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdated": "1 hour ago"
    },
    {
      "id": 3,
      "name": "Bugando Medical Centre",
      "address": "Mwanza, Tanzania",
      "phone": "+255 28 250 0465",
      "latitude": -2.5164,
      "longitude": 32.9175,
      "distance": 8.1,
      "isOpen": true,
      "rating": 4.0,
      "hours": "Mon-Fri: 8:00 AM - 4:00 PM, Sat: 9:00 AM - 1:00 PM",
      "facilities": ["Air Conditioning", "Wheelchair Access", "Laboratory"],
      "image":
          "https://images.pexels.com/photos/236380/pexels-photo-236380.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdated": "3 hours ago"
    },
    {
      "id": 4,
      "name": "Arusha Lutheran Medical Centre",
      "address": "Arusha, Tanzania",
      "phone": "+255 27 254 4024",
      "latitude": -3.3869,
      "longitude": 36.6830,
      "distance": 12.4,
      "isOpen": true,
      "rating": 4.3,
      "hours": "Mon-Fri: 8:00 AM - 5:00 PM, Sat: 8:00 AM - 2:00 PM",
      "facilities": ["Parking", "Air Conditioning", "Pharmacy"],
      "image":
          "https://images.pexels.com/photos/668298/pexels-photo-668298.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdated": "30 minutes ago"
    },
    {
      "id": 5,
      "name": "Dodoma Regional Referral Hospital",
      "address": "Dodoma, Tanzania",
      "phone": "+255 26 232 4019",
      "latitude": -6.1630,
      "longitude": 35.7516,
      "distance": 15.2,
      "isOpen": false,
      "rating": 3.8,
      "hours": "Mon-Fri: 7:00 AM - 4:00 PM, Sat: 8:00 AM - 12:00 PM",
      "facilities": ["Emergency Services", "Laboratory", "Wheelchair Access"],
      "image":
          "https://images.pexels.com/photos/1170979/pexels-photo-1170979.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "lastUpdated": "4 hours ago"
    }
  ];

  List<Map<String, dynamic>> get _filteredCenters {
    if (_searchQuery.isEmpty) {
      return _donationCenters;
    }
    return _donationCenters.where((center) {
      final name = (center['name'] as String).toLowerCase();
      final address = (center['address'] as String).toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || address.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  void _onCenterSelected(Map<String, dynamic> center) {
    setState(() {
      _selectedCenter = center;
    });
    _showCenterDetails(center);
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CenterDetailsBottomSheet(
        center: center,
        onClose: () {
          setState(() {
            _selectedCenter = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  Future<void> _refreshCenters() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _recenterMap() {
    // Simulate recentering to user location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recentering to your location...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Donation Centers',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_isMapView) _toggleView();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: _isMapView
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'map',
                          color: _isMapView
                              ? Colors.white
                              : AppTheme.lightTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Map',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: _isMapView
                                ? Colors.white
                                : AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_isMapView) _toggleView();
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: !_isMapView
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'list',
                          color: !_isMapView
                              ? Colors.white
                              : AppTheme.lightTheme.primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'List',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: !_isMapView
                                ? Colors.white
                                : AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search centers or areas...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.6),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: _clearSearch,
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Stack(
              children: [
                _isMapView
                    ? MapViewWidget(
                        centers: _filteredCenters,
                        selectedCenter: _selectedCenter,
                        onCenterSelected: _onCenterSelected,
                        onRecenter: _recenterMap,
                      )
                    : ListViewWidget(
                        centers: _filteredCenters,
                        onCenterSelected: _onCenterSelected,
                        onRefresh: _refreshCenters,
                        isLoading: _isLoading,
                      ),

                // Loading overlay
                if (_isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Updating centers...',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home-dashboard');
              break;
            case 1:
              // Current screen
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
              Navigator.pushReplacementNamed(context, '/user-profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Centers',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Eligibility',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Book',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
