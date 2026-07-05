import 'package:flutter/material.dart';
import '../widgets/auth_header.dart';
import '../widgets/set_password_form.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 12),

              AuthHeader(
                title: 'Set New Password',
                subtitle:
                    'Create a strong password that you haven’t used before for this account.',
              ),

              SizedBox(height: 32),

              SetPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
