import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/donation_card_widget.dart';
import './widgets/donation_stats_widget.dart';
import './widgets/donation_timeline_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';

class DonationHistory extends StatefulWidget {
  const DonationHistory({Key? key}) : super(key: key);

  @override
  State<DonationHistory> createState() => _DonationHistoryState();
}

class _DonationHistoryState extends State<DonationHistory>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedFilter = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _showTimeline = true;

  late TabController _tabController;

  // Mock donation data
  final List<Map<String, dynamic>> _donationHistory = [
    {
      "id": 1,
      "date": "2024-01-15",
      "time": "09:30 AM",
      "location": "Muhimbili National Hospital",
      "address": "Dar es Salaam, Tanzania",
      "donationType": "Whole Blood",
      "volume": "450ml",
      "status": "Completed",
      "processingStage": "Transfused",
      "staffNotes": "Excellent donation, no complications",
      "postVitals": {
        "bloodPressure": "120/80",
        "heartRate": "72 bpm",
        "temperature": "36.5°C"
      },
      "certificateId": "DC2024001",
      "livesImpacted": 3,
      "nextEligible": "2024-04-15",
      "badgeEarned": "Regular Donor",
      "isExpanded": false
    },
    {
      "id": 2,
      "date": "2023-10-20",
      "time": "02:15 PM",
      "location": "Kilimanjaro Christian Medical Centre",
      "address": "Moshi, Tanzania",
      "donationType": "Platelets",
      "volume": "250ml",
      "status": "Completed",
      "processingStage": "Processing",
      "staffNotes": "First-time platelet donor, handled well",
      "postVitals": {
        "bloodPressure": "118/75",
        "heartRate": "68 bpm",
        "temperature": "36.2°C"
      },
      "certificateId": "DC2023045",
      "livesImpacted": 2,
      "nextEligible": "2023-12-20",
      "badgeEarned": "Platelet Hero",
      "isExpanded": false
    },
    {
      "id": 3,
      "date": "2023-07-08",
      "time": "11:00 AM",
      "location": "Bugando Medical Centre",
      "address": "Mwanza, Tanzania",
      "donationType": "Whole Blood",
      "volume": "450ml",
      "status": "Completed",
      "processingStage": "Distributed",
      "staffNotes": "Smooth donation process",
      "postVitals": {
        "bloodPressure": "115/70",
        "heartRate": "70 bpm",
        "temperature": "36.8°C"
      },
      "certificateId": "DC2023028",
      "livesImpacted": 3,
      "nextEligible": "2023-10-08",
      "badgeEarned": "Life Saver",
      "isExpanded": false
    }
  ];

  final Map<String, dynamic> _donationStats = {
    "totalDonations": 3,
    "livesImpacted": 8,
    "nextEligibleDate": "2024-04-15",
    "currentStreak": 3,
    "longestStreak": 5,
    "totalVolume": "1150ml",
    "badges": ["First Timer", "Regular Donor", "Platelet Hero", "Life Saver"],
    "lastDonation": "2024-01-15"
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredDonations {
    List<Map<String, dynamic>> filtered = List.from(_donationHistory);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((donation) {
        final location = (donation['location'] as String).toLowerCase();
        final date = (donation['date'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return location.contains(query) || date.contains(query);
      }).toList();
    }

    if (_selectedFilter != 'All') {
      filtered = filtered.where((donation) {
        return donation['donationType'] == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  void _toggleCardExpansion(int index) {
    setState(() {
      _donationHistory[index]['isExpanded'] =
          !_donationHistory[index]['isExpanded'];
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  void _exportHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Donation history exported successfully'),
        action: SnackBarAction(
          label: 'Share',
          onPressed: () {
            // Share functionality
          },
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Donation history updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Donation History',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _exportHistory,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(12.h),
          child: Column(
            children: [
              // Search Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by location or date...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 3.w),
                  ),
                ),
              ),
              // Tab Bar
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'list',
                          color: _tabController.index == 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('List View'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'timeline',
                          color: _tabController.index == 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('Timeline'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: _donationHistory.isEmpty ? _buildEmptyState() : _buildContent(),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Column(
        children: [
          // Stats Section
          DonationStatsWidget(
            stats: _donationStats,
            onStatsPressed: () {
              // Navigate to detailed stats
            },
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(),
                _buildTimelineView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final filteredDonations = _filteredDonations;

    if (filteredDonations.isEmpty) {
      return _buildNoResultsState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: filteredDonations.length,
      itemBuilder: (context, index) {
        final donation = filteredDonations[index];
        return DonationCardWidget(
          donation: donation,
          isExpanded: donation['isExpanded'] ?? false,
          onTap: () => _toggleCardExpansion(
              _donationHistory.indexWhere((d) => d['id'] == donation['id'])),
          onCertificateDownload: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Certificate downloaded: ${donation['certificateId']}'),
              ),
            );
          },
          onContextMenu: () {
            _showDonationContextMenu(donation);
          },
        );
      },
    );
  }

  Widget _buildTimelineView() {
    return DonationTimelineWidget(
      donations: _filteredDonations,
      stats: _donationStats,
      onDonationTap: (donation) {
        final index =
            _donationHistory.indexWhere((d) => d['id'] == donation['id']);
        if (index != -1) {
          _toggleCardExpansion(index);
        }
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Start Your Donation Journey',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Your donation history will appear here once you make your first blood donation. Every donation saves lives!',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/appointment-booking');
              },
              icon: CustomIconWidget(
                iconName: 'calendar_today',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Book First Donation'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
              ),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/eligibility-checker');
              },
              child: Text('Check Eligibility First'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No donations found',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filter criteria',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = 'All';
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonationContextMenu(Map<String, dynamic> donation) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit Notes'),
              onTap: () {
                Navigator.pop(context);
                // Show edit notes dialog
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Download Certificate'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Certificate downloaded: ${donation['certificateId']}'),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report_problem',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                // Show report issue dialog
              },
            ),
          ],
        ),
      ),
    );
  }
}
