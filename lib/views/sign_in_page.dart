import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:productivity_app/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInFormKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    if (_signInFormKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      final deleted = await context.read<ProfileViewModel>().isAccountDeleted(
        email,
      );

      if (!mounted) return;

      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign In failed: failed login attempt',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
            ),
          ),
        );

        return;
      }

      final result = await context.read<AuthViewModel>().signIn(
        email: email,
        password: password,
      );

      if (!result) {
        if (!mounted) return;
        final errorMessage = context.read<AuthViewModel>().errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign In failed: $errorMessage',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
            ),
            action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
          ),
        );
      } else {
        if (!mounted) return;

        // ujust according to auth gate
        Navigator.pushReplacementNamed(context, RouteManager.homePage);
      }

      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // return button
            // Builder(
            //   builder: (context) {
            //     return GestureDetector(
            //       onTap: () => Navigator.pop(context),
            //       child: Container(
            //         padding: const EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(12),
            //           border: Border.all(
            //             color: Theme.of(context).colorScheme.outline,
            //           ),
            //         ),
            //         child: Image.asset(
            //           height: 13,
            //           'assets/images/icons/close.png',
            //           color: Theme.of(context).iconTheme.color,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            SizedBox(height: 50),

            // login page
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // page title
                    Text(
                      'RHABBIT',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        letterSpacing: 6,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                    SizedBox(height: 5),

                    // page description
                    Text(
                      'Sign in to pick up where you left off',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    ),
                    SizedBox(height: 80),

                    // form
                    Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          // email text form
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(hintText: 'Email ID'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email ID is required';
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
                            controller: _passwordController,
                            decoration: InputDecoration(hintText: 'Password'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 5),

                          // forgot password text button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteManager.forgotPasswdPage,
                                  );
                                },
                                child: Text('Forgot Password'),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),

                          // login elevated button
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _signIn,
                              child: Text(
                                'Login',
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

                    // external sign-in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: const Divider(color: AppColor.muted)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Or continue with',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColor.muted),
                          ),
                        ),
                        Expanded(child: const Divider(color: AppColor.muted)),
                      ],
                    ),

                    SizedBox(height: 40),

                    //row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // apple sign in
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Apple sign in coming later ...',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColor.info),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? AppColor.darkFill
                                  : AppColor.lightFill,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              isDarkTheme
                                  ? 'assets/images/logos/apple_logo_light.png'
                                  : 'assets/images/logos/apple_logo_dark.png',
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),

                        // google sign in
                        GestureDetector(
                          onTap: () {
                            context.read<AuthViewModel>().signInWithGoogle();
                          },
                          child: Container(
                            padding: EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? AppColor.darkFill
                                  : AppColor.lightFill,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              'assets/images/logos/google_logo.png',
                              height: 30,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // dont have and account redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account yet?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteManager.signUpPage,
                            );
                          },
                          child: Text('Sign Up'),
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
