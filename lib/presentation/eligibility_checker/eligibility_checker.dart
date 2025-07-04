import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/basic_information_widget.dart';
import './widgets/eligibility_result_widget.dart';
import './widgets/health_status_widget.dart';
import './widgets/medications_widget.dart';
import './widgets/recent_activities_widget.dart';

class EligibilityChecker extends StatefulWidget {
  const EligibilityChecker({Key? key}) : super(key: key);

  @override
  State<EligibilityChecker> createState() => _EligibilityCheckerState();
}

class _EligibilityCheckerState extends State<EligibilityChecker>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form data storage
  Map<String, dynamic> _formData = {
    'age': null,
    'weight': null,
    'gender': null,
    'bloodType': null,
    'hasChronicConditions': null,
    'chronicConditions': [],
    'hasRecentIllness': null,
    'recentIllnessDetails': '',
    'hasRecentSurgery': null,
    'recentSurgeryDate': null,
    'hasRecentTravel': null,
    'recentTravelCountries': [],
    'travelDate': null,
    'hasRecentTattoo': null,
    'tattooDate': null,
    'hasRecentDonation': null,
    'lastDonationDate': null,
    'isPregnant': null,
    'isBreastfeeding': null,
    'currentMedications': [],
    'hasAllergies': null,
    'allergies': [],
  };

  bool _isEligible = false;
  List<String> _restrictions = [];
  String _eligibilityMessage = '';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _checkEligibility();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _updateFormData(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _formData['age'] != null &&
            _formData['weight'] != null &&
            _formData['gender'] != null;
      case 1:
        return _formData['hasChronicConditions'] != null &&
            _formData['hasRecentIllness'] != null &&
            _formData['hasRecentSurgery'] != null;
      case 2:
        return _formData['hasRecentTravel'] != null &&
            _formData['hasRecentTattoo'] != null &&
            _formData['hasRecentDonation'] != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _checkEligibility() {
    List<String> restrictions = [];
    bool eligible = true;

    // Age check
    if (_formData['age'] != null &&
        (_formData['age'] < 18 || _formData['age'] > 65)) {
      eligible = false;
      restrictions.add('Age must be between 18-65 years');
    }

    // Weight check
    if (_formData['weight'] != null && _formData['weight'] < 50) {
      eligible = false;
      restrictions.add('Minimum weight requirement is 50kg');
    }

    // Chronic conditions check
    if (_formData['hasChronicConditions'] == true) {
      eligible = false;
      restrictions.add('Chronic health conditions require medical clearance');
    }

    // Recent illness check
    if (_formData['hasRecentIllness'] == true) {
      eligible = false;
      restrictions.add('Recent illness - wait 2 weeks after full recovery');
    }

    // Recent surgery check
    if (_formData['hasRecentSurgery'] == true) {
      eligible = false;
      restrictions.add('Recent surgery - wait 6 months before donating');
    }

    // Recent travel check
    if (_formData['hasRecentTravel'] == true) {
      eligible = false;
      restrictions
          .add('Recent travel to malaria-endemic areas - wait 3 months');
    }

    // Recent tattoo check
    if (_formData['hasRecentTattoo'] == true) {
      eligible = false;
      restrictions.add('Recent tattoo/piercing - wait 6 months');
    }

    // Recent donation check
    if (_formData['hasRecentDonation'] == true) {
      eligible = false;
      restrictions.add('Previous donation - wait 8 weeks between donations');
    }

    // Pregnancy check
    if (_formData['isPregnant'] == true) {
      eligible = false;
      restrictions.add('Pregnancy - cannot donate during pregnancy');
    }

    // Breastfeeding check
    if (_formData['isBreastfeeding'] == true) {
      eligible = false;
      restrictions.add('Breastfeeding - wait 6 months after delivery');
    }

    setState(() {
      _isEligible = eligible;
      _restrictions = restrictions;
      _eligibilityMessage = eligible
          ? 'Congratulations! You are eligible to donate blood.'
          : 'You are currently not eligible to donate blood.';
      _currentStep = _totalSteps;
    });

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  double get _progress => (_currentStep + 1) / (_totalSteps + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Eligibility Checker',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          if (_currentStep < _totalSteps)
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: Center(
                child: Text(
                  '${_currentStep + 1}/${_totalSteps}',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          if (_currentStep < _totalSteps)
            Container(
              width: double.infinity,
              height: 1.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BasicInformationWidget(
                  formData: _formData,
                  onDataChanged: _updateFormData,
                ),
                HealthStatusWidget(
                  formData: _formData,
                  onDataChanged: _updateFormData,
                ),
                RecentActivitiesWidget(
                  formData: _formData,
                  onDataChanged: _updateFormData,
                ),
                MedicationsWidget(
                  formData: _formData,
                  onDataChanged: _updateFormData,
                ),
                EligibilityResultWidget(
                  isEligible: _isEligible,
                  restrictions: _restrictions,
                  message: _eligibilityMessage,
                  onBookAppointment: () {
                    Navigator.pushNamed(context, '/appointment-booking');
                  },
                  onViewCenters: () {
                    Navigator.pushNamed(context, '/donation-centers-map');
                  },
                ),
              ],
            ),
          ),

          // Bottom navigation buttons
          if (_currentStep < _totalSteps)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: AppTheme.lightTheme.outlinedButtonTheme.style,
                        child: Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 4.w),
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _canProceed() ? _nextStep : null,
                      style: AppTheme.lightTheme.elevatedButtonTheme.style,
                      child: Text(
                        _currentStep == _totalSteps - 1
                            ? 'Check Eligibility'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
