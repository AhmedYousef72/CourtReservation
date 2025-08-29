import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/helpers/validators.dart';
import '../../../core/helpers/navigation_helper.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement actual login logic with Firebase
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        NavigationHelper.showSuccessSnackBar(context, 'Login successful!');
        // TODO: Navigate to home screen
      }
    } catch (e) {
      if (mounted) {
        NavigationHelper.showErrorSnackBar(context, 'Login failed: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToSignup() {
    NavigationHelper.push(context, const SignupScreen());
  }

  void _recoverAccount() {
    // TODO: Implement recover account functionality
    NavigationHelper.showSnackBar(context, 'Recover account functionality coming soon');
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Login Title
                      Text(
                        'Login',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingExtraLarge),
                      
                      // Email Field
                      CustomTextField(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Password Field
                      CustomPasswordField(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        controller: _passwordController,
                        validator: Validators.validatePassword,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Remember Password Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberPassword,
                            onChanged: (value) {
                              setState(() {
                                _rememberPassword = value ?? false;
                              });
                            },
                            activeColor: const Color(0xff37B261),
                          ),
                          Text(
                            'Remember password',
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 18,
                              color: AppConstants.textPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Login Button
                      CustomButton(
                        text: 'Login',
                        onPressed: _login,
                        isLoading: _isLoading,
                        backgroundColor: const Color(0xff37B261),
                        height: AppConstants.buttonHeightMedium,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingExtraLarge),
                      
                      // Account Options Title
                      Text(
                        'Account Options',
                        style: GoogleFonts.montserratAlternates(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.textPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
                      
                      // Recover Account Button
                      Container(
                        width: double.infinity,
                        height: AppConstants.buttonHeightMedium,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff37B261), width: 1.5),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: TextButton(
                          onPressed: _recoverAccount,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recover Account',
                                      style: GoogleFonts.montserratAlternates(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff37B261),
                                      ),
                                    ),
                                    Text(
                                      'We will verify your identity',
                                      style: GoogleFonts.montserratAlternates(
                                        fontSize: 18,
                                        color: AppConstants.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.lock_person,
                                color: Color(0xff37B261),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingMedium),
                      
                      // Create Account Button
                      Container(
                        width: double.infinity,
                        height: AppConstants.buttonHeightMedium,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff37B261), width: 1.5),
                          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        ),
                        child: TextButton(
                          onPressed: _navigateToSignup,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: GoogleFonts.montserratAlternates(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff37B261),
                                      ),
                                    ),
                                    Text(
                                      'Register for the first time',
                                      style: GoogleFonts.montserratAlternates(
                                        fontSize: 18,
                                        color: AppConstants.textSecondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.person_add,
                                color: Color(0xff37B261),
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: AppConstants.paddingLarge),
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
