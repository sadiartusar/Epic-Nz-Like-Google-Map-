import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_back_button.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void showPickerOptions(bool isProfile) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1F1C) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isProfile ? "Update Profile Picture" : "Update Cover Photo",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text("Take Photo (Camera)"),
                onTap: () {
                  Get.back();
                  if (isProfile) {
                    controller.pickProfileImage(ImageSource.camera);
                  } else {
                    controller.pickCoverImage(ImageSource.camera);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Get.back();
                  if (isProfile) {
                    controller.pickProfileImage(ImageSource.gallery);
                  } else {
                    controller.pickCoverImage(ImageSource.gallery);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    }

    return Obx(() {
      ImageProvider coverProvider;
      if (controller.selectedCoverImage.value != null) {
        coverProvider = FileImage(controller.selectedCoverImage.value!);
      } else if (controller.coverPic.value.isNotEmpty) {
        coverProvider = NetworkImage(controller.coverPic.value);
      } else {
        coverProvider = const NetworkImage(
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
        );
      }

      ImageProvider profileProvider;

      if (controller.selectedProfileImage.value != null) {
        profileProvider = FileImage(controller.selectedProfileImage.value!);
      } else if (controller.profilePic.value.isNotEmpty) {
        profileProvider = NetworkImage(controller.profilePic.value);
      } else {
        profileProvider = const AssetImage('assets/images/profile.png');
      }

      return SizedBox(
        height: 240,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () => showPickerOptions(false),
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: coverProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(color: Colors.black.withValues(alpha: 0.25)),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 16,
              child: const AppBackButton(),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: GestureDetector(
                onTap: () => showPickerOptions(false),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ),

            Positioned(
              left: 24,
              top: 155,
              child: GestureDetector(
                onTap: () => showPickerOptions(true),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.green, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileProvider,
                      ),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.green,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 24,
              right: 24,
              top: 190,
              child: Padding(
                padding: const EdgeInsets.only(left: 88),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.fullName.value,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
