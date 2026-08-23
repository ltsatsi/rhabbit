import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ForgotPasswdPage extends StatefulWidget {
  const ForgotPasswdPage({super.key});

  @override
  State<ForgotPasswdPage> createState() => _ForgotPasswdPageState();
}

class _ForgotPasswdPageState extends State<ForgotPasswdPage> {
  final _sendResetEmailFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _sendEmail() async {
    if (_sendResetEmailFormKey.currentState!.validate()) {
      final email = _emailController.text.trim();

      await context.read<AuthViewModel>().resetPasswd(email: email);

      if (!mounted) return;

      final errorMessage = context.read<AuthViewModel>().errorMessage;

      if (errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unexpected error occured: $errorMessage',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColor.lightText),
            ),
          ),
        );
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // icon / animation
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor.success.withOpacity(0.15),
                        ),
                        child: Icon(
                          Icons.email_outlined,
                          size: 40,
                          color: AppColor.success,
                        ),
                      ),
                      SizedBox(height: 20),

                      // title
                      Text(
                        'Email Sent',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 7),

                      // description
                      Text(
                        'Password reset email sent, please check your emails. Please note link sent is subject to expiry.',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),

            // dialog actions
            actions: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.success,
                  ),
                  onPressed: () {
                    // navigate to sign in page
                    Navigator.pushReplacementNamed(
                      context,
                      RouteManager.signInPage,
                    );
                  },
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.lightText,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                      'assets/images/icons/arrow_back.png',
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            Column(
              children: [
                // page icon / animation
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColor.seedColor.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.mail_lock_outlined,
                    size: 40,
                    color: AppColor.seedColor,
                  ),
                ),
                SizedBox(height: 30),

                // page title
                Text(
                  'Forgot Password',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight(600)),
                ),
                SizedBox(height: 10),

                // page desc
                Text(
                  'Enter you Email ID and we\'ll send a password reset email',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 25),

            // Form
            Form(
              key: _sendResetEmailFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // imput field - email
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
                  SizedBox(height: 15),

                  // elevated button
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendEmail,
                      child: Text(
                        'Send email',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
