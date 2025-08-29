import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/helpers/validators.dart';
import '../../../core/helpers/navigation_helper.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      NavigationHelper.showErrorSnackBar(
        context, 
        'Please accept the terms and conditions'
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual signup logic with Firebase
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        NavigationHelper.showSuccessSnackBar(
          context, 
          'Account created successfully!'
        );
        NavigationHelper.pop(context);
      }
    } catch (e) {
      if (mounted) {
        NavigationHelper.showErrorSnackBar(
          context, 
          'Signup failed: ${e.toString()}'
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    NavigationHelper.pop(context);
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms and Conditions',
          style: GoogleFonts.montserratAlternates(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            'By using this app, you agree to our terms and conditions...',
            style: GoogleFonts.montserratAlternates(fontSize: 18),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.montserratAlternates(
                fontSize: 18,
                color: const Color(0xff37B261),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: const BoxDecoration(
                    color: Color(0xff37B261),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.sports_basketball,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Text(
                        'SportReserve',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Form Section
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Complete the data to create your account',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingExtraLarge),
                      
                      // Full Name Field
                      CustomTextField(
                        labelText: 'Add your full name',
                        hintText: 'Enter your full name',
                        controller: _fullNameController,
                        keyboardType: TextInputType.name,
                        validator: Validators.validateFullName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Email Field
                      CustomTextField(
                        labelText: 'Add your e-mail',
                        hintText: 'Enter your email address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Password Field
                      CustomPasswordField(
                        labelText: 'Add your password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Confirm Password Field
                      CustomPasswordField(
                        labelText: 'Confirm your password',
                        hintText: 'Confirm your password',
                        controller: _confirmPasswordController,
                        validator: (value) => Validators.validateConfirmPassword(
                          value, 
                          _passwordController.text
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Terms and Conditions
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _showTermsAndConditions,
                              child: Text(
                                'Terms and conditions',
                                style: GoogleFonts.montserratAlternates(
                                  fontSize: 18,
                                  color: const Color(0xff37B261),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingSmall),
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xff37B261),
                          ),
                          Text(
                            'I accept terms and conditions',
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 18,
                              color: AppConstants.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Continue',
                              onPressed: _signup,
                              isLoading: _isLoading,
                              backgroundColor: const Color(0xff37B261),
                              height: AppConstants.buttonHeightMedium,
                            ),
                          ),
                          const SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: CustomButton(
                              text: 'Cancel',
                              onPressed: _navigateToLogin,
                              isOutlined: true,
                              backgroundColor: Colors.white,
                              textColor: const Color(0xff37B261),
                              height: AppConstants.buttonHeightMedium,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppConstants.hasAccount,
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 18,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                          TextButton(
                            onPressed: _navigateToLogin,
                            child: Text(
                              AppConstants.loginButton,
                              style: GoogleFonts.montserratAlternates(
                                fontSize: 18,
                                color: const Color(0xff37B261),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
