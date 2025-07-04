import 'package:flutter/material.dart';

import '../presentation/appointment_booking/appointment_booking.dart';
import '../presentation/auth/signin_screen.dart';
import '../presentation/auth/signup_screen.dart';
import '../presentation/donation_centers_map/donation_centers_map.dart';
import '../presentation/donation_history/donation_history.dart';
import '../presentation/eligibility_checker/eligibility_checker.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user_profile/user_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String appointmentBooking = '/appointment-booking';
  static const String donationCentersMap = '/donation-centers-map';
  static const String donationHistory = '/donation-history';
  static const String eligibilityChecker = '/eligibility-checker';
  static const String userProfile = '/user-profile';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SignInScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    appointmentBooking: (context) => const AppointmentBooking(),
    donationCentersMap: (context) => const DonationCentersMap(),
    donationHistory: (context) => const DonationHistory(),
    eligibilityChecker: (context) => const EligibilityChecker(),
    userProfile: (context) => const UserProfile(),
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),
    // TODO: Add your other routes here
  };
}
