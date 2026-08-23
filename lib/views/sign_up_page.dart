import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordConller = TextEditingController();
  final _confirmPassword = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  bool termsAgreed = false;

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordConller.text;

    if (!termsAgreed) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Read and accept Terms of Service to create account!',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
          ),
          action: SnackBarAction(
            label: 'Accept',
            onPressed: () {
              setState(() {
                termsAgreed = true;
              });
            },
          ),
        ),
      );
    }

    if (_signUpFormKey.currentState!.validate() && termsAgreed) {
      final result = await context.read<AuthViewModel>().signUp(
        email: email,
        password: password,
      );

      if (result) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An account for $email was successfully created!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
            ),
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          ),
        );

        // reset form
        _emailController.clear();
        _passwordConller.clear();
        _confirmPassword.clear();

        setState(() {
          termsAgreed = true;
        });
      } else {
        if (!mounted) return;
        final errorMessage = context.read<AuthViewModel>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Account creation Failed: $errorMessage',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
            ),
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    termsAgreed = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordConller.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // return button
            Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: Image.asset(
                      height: 13,
                      'assets/images/icons/close.png',
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            // login page
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // animation / icon
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColor.seedColor.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: AppColor.seedColor,
                      ),
                    ),
                    SizedBox(height: 20),

                    // page title
                    Text(
                      'Create an account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 5),

                    // page description
                    Text(
                      'Save your progress, sync your sessions, and stay focused wherever you go',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    ),
                    SizedBox(height: 20),

                    // form
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          // email text form
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(hintText: 'Email ID'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email ID required';
                              }

                              if (!value.contains('@')) {
                                return 'Invalid Email ID';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // password text form
                          TextFormField(
                            obscureText: true,
                            controller: _passwordConller,
                            decoration: InputDecoration(hintText: 'Password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }

                              if (value.length < 8) {
                                return 'Password is too weak';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          // confirm password text form
                          TextFormField(
                            obscureText: true,
                            controller: _confirmPassword,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                            ),
                            validator: (value) {
                              final password = _passwordConller.text;
                              if (value!.isEmpty) {
                                return 'Confirm Password';
                              }

                              if (value != password) {
                                return 'Passowrds do not match';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),

                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 5,
                            ),
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            value: termsAgreed,
                            onChanged: (value) =>
                                setState(() => termsAgreed = value!),
                            title: Text(
                              'By clicking \'sign up\', you agree to the Terms of Service and Privacy Policy.',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ),
                          SizedBox(height: 30),

                          // login elevated button
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _signUp,
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.lightText,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

                    // dont have and account redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Sign In'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
