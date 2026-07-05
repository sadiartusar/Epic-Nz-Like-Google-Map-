import 'package:flutter/material.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/profile_header_edit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            EditProfileHeader(),

            SizedBox(height: 24),

            EditProfileForm(),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
