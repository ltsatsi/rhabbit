import 'package:flutter/material.dart';
import 'package:productivity_app/core/constants/app_color.dart';
import 'package:productivity_app/core/routes/route_manager.dart';
import 'package:productivity_app/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class ResetPasswdPage extends StatefulWidget {
  const ResetPasswdPage({super.key});

  @override
  State<ResetPasswdPage> createState() => _ResetPasswdPageState();
}

class _ResetPasswdPageState extends State<ResetPasswdPage> {
  final _updatePasswdFormKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _updatePassword() async {
    if (_updatePasswdFormKey.currentState!.validate()) {
      final password = _newPasswordController.text;

      context.read<AuthViewModel>().updatePasswd(password: password);

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset successfully',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColor.success),
          ),
        ),
      );

      Navigator.pushNamed(context, RouteManager.signInPage);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: SingleChildScrollView(
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
              //           'assets/images/icons/arrow_back.png',
              //           color: Theme.of(context).iconTheme.color,
              //         ),
              //       ),
              //     );
              //   },
              // ),
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
                      Icons.password,
                      size: 40,
                      color: AppColor.seedColor,
                    ),
                  ),
                  SizedBox(height: 30),

                  // page title
                  Text(
                    'Update Password',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight(600),
                    ),
                  ),
                  SizedBox(height: 10),

                  // page desc
                  Text(
                    'Enter your new password. It is recommended not to use the previous password',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColor.muted),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 25),

              // form
              Form(
                key: _updatePasswdFormKey,
                child: Column(
                  children: [
                    // new password
                    TextFormField(
                      obscureText: true,
                      controller: _newPasswordController,
                      decoration: InputDecoration(hintText: 'New Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'New Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),

                    // confirm password
                    TextFormField(
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(hintText: 'Confirm Password'),
                      validator: (value) {
                        final password = _newPasswordController.text;

                        if (value!.isEmpty) {
                          return 'Confirm Password';
                        }

                        if (value != password) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),

              // elevated button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updatePassword,
                  child: Text(
                    'Update Password',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
