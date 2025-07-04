import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_image_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text);

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.homeDashboard);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(authProvider.errorMessage ?? 'Sign in failed'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error));
      }
    }
  }

  void _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.signInWithGoogle();

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authProvider.errorMessage ?? 'Google sign in failed'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 8.h),

                          // App Logo
                          Center(
                              child:
                                  CustomImageWidget(imageUrl: '', height: 15.h, width: 15.h)),

                          SizedBox(height: 4.h),

                          // Welcome Text
                          Text('Welcome Back!',
                              style: AppTheme
                                  .lightTheme.textTheme.headlineMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary),
                              textAlign: TextAlign.center),

                          SizedBox(height: 1.h),

                          Text(
                              'Sign in to continue your blood donation journey',
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant),
                              textAlign: TextAlign.center),

                          SizedBox(height: 4.h),

                          // Email Field
                          TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: CustomIconWidget(
                                      iconName: 'email',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 20)),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value!)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              }),

                          SizedBox(height: 3.h),

                          // Password Field
                          TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: CustomIconWidget(
                                      iconName: 'lock',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 20),
                                  suffixIcon: IconButton(
                                      onPressed: () => setState(() =>
                                          _obscurePassword = !_obscurePassword),
                                      icon: CustomIconWidget(
                                          iconName: _obscurePassword
                                              ? 'visibility'
                                              : 'visibility_off',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 20))),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter your password';
                                }
                                return null;
                              }),

                          SizedBox(height: 2.h),

                          // Forgot Password
                          Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRoutes.forgotPassword),
                                  child: Text('Forgot Password?'))),

                          SizedBox(height: 3.h),

                          // Sign In Button
                          Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                            return ElevatedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : _handleSignIn,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                child: authProvider.isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text('Sign In',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600)));
                          }),

                          SizedBox(height: 3.h),

                          // Divider
                          Row(children: [
                            Expanded(child: Divider()),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Text('OR',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                            color: AppTheme
                                                .lightTheme
                                                .colorScheme
                                                .onSurfaceVariant))),
                            Expanded(child: Divider()),
                          ]),

                          SizedBox(height: 3.h),

                          // Google Sign In Button
                          Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                            return OutlinedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : _handleGoogleSignIn,
                                style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8))),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomIconWidget(
                                          iconName: 'google',
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          size: 20),
                                      SizedBox(width: 2.w),
                                      Text('Continue with Google'),
                                    ]));
                          }),

                          SizedBox(height: 4.h),

                          // Sign Up Link
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have an account? ",
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium),
                                TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, AppRoutes.signUp),
                                    child: Text('Sign Up',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.lightTheme
                                                .colorScheme.primary))),
                              ]),
                        ])))));
  }
}