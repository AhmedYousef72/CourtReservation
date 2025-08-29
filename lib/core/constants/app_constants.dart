import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF1976D2);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textLightColor = Color(0xFFBDBDBD);
  
  // App Strings
  static const String appName = 'Sports Court Booking';
  static const String appVersion = '1.0.0';
  
  // Auth Strings
  static const String loginTitle = 'Welcome Back';
  static const String signupTitle = 'Create Account';
  static const String emailHint = 'Email';
  static const String passwordHint = 'Password';
  static const String confirmPasswordHint = 'Confirm Password';
  static const String loginButton = 'Login';
  static const String signupButton = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String noAccount = "Don't have an account? ";
  static const String hasAccount = 'Already have an account? ';
  
  // Home Strings
  static const String homeTitle = 'Sports Courts';
  static const String basketball = 'Basketball';
  static const String football = 'Football';
  static const String tennis = 'Tennis';
  static const String volleyball = 'Volleyball';
  
  // Court Strings
  static const String courtDetails = 'Court Details';
  static const String bookNow = 'Book Now';
  static const String pricePerHour = 'Price per hour: ';
  static const String availableSlots = 'Available Slots';
  static const String noAvailableSlots = 'No available slots for this date';
  
  // Reservation Strings
  static const String selectDate = 'Select Date';
  static const String selectTime = 'Select Time';
  static const String duration = 'Duration';
  static const String totalPrice = 'Total Price';
  static const String confirmBooking = 'Confirm Booking';
  static const String bookingSuccess = 'Booking Successful!';
  static const String bookingFailed = 'Booking Failed';
  
  // Profile Strings
  static const String profile = 'Profile';
  static const String myBookings = 'My Bookings';
  static const String settings = 'Settings';
  static const String logout = 'Logout';
  static const String editProfile = 'Edit Profile';
  
  // Error Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String networkError = 'Network error';
  static const String invalidEmail = 'Invalid email address';
  static const String weakPassword = 'Password is too weak';
  static const String passwordMismatch = 'Passwords do not match';
  static const String userNotFound = 'User not found';
  static const String wrongPassword = 'Wrong password';
  
  // Success Messages
  static const String profileUpdated = 'Profile updated successfully';
  static const String passwordChanged = 'Password changed successfully';
  static const String bookingCancelled = 'Booking cancelled successfully';
  
  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String minLength = 'Minimum length is ';
  static const String maxLength = 'Maximum length is ';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM dd, yyyy HH:mm';
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  // Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusExtraLarge = 16.0;
  
  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  // Button Heights
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
}
