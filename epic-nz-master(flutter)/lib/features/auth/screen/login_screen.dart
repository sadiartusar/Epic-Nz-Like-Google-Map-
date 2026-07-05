import 'package:flutter/material.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_form.dart';
import '../widgets/auth_divider.dart';
import '../widgets/auth_footer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                title: 'Login',
                subtitle:
                    'Your journey begins with a single tap, adventures waiting just ahead.',
              ),

              SizedBox(height: 32),

              AuthForm(),

              SizedBox(height: 24),

              AuthDivider(),

              SizedBox(height: 20),

              AuthFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
