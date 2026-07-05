import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/auth_header.dart';
import '../widgets/register_form.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer_register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              AppBackButton(),
              SizedBox(height: 8),
              AuthHeader(
                title: 'Create Account',
                subtitle:
                    'Your journey begins with a single tap, adventures waiting just ahead.',
              ),

              SizedBox(height: 32),

              RegisterForm(),

              SizedBox(height: 24),

              AuthDivider(),

              SizedBox(height: 20),

              AuthFooterRegister(),
            ],
          ),
        ),
      ),
    );
  }
}
