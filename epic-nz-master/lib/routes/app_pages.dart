import 'package:epic_nz/features/auth/screen/login_screen.dart';
import 'package:epic_nz/features/home/spot_card_details_screen/spot_detail_screen.dart';
import 'package:epic_nz/features/edit_profile/screen/edit_profile_screen.dart';
import 'package:epic_nz/features/my_submission/screens/new_location_screen.dart';
import 'package:epic_nz/features/my_submission/screens/add_details_screen.dart';
import 'package:epic_nz/features/my_submission/screens/review_submission_screen.dart';
import 'package:epic_nz/features/my_submission/screens/pending_approval_screen.dart';
import 'package:epic_nz/features/offline_maps/screens/offline_maps_screen.dart';
import 'package:epic_nz/features/payment/screens/payment_failed_screen.dart';
import 'package:epic_nz/features/profile/screen/profile_screen.dart';
import 'package:epic_nz/features/save_location/screens/saved_location_screen.dart';
import 'package:epic_nz/features/settings/screen/settings_screen.dart';
import 'package:epic_nz/features/subscription/screens/manage_plan_screen.dart';
import 'package:epic_nz/features/subscription/screens/my_subscription_screen.dart';
import 'package:get/get.dart';

import '../features/auth/screen/forgot_password_screen.dart';
import '../features/auth/screen/register_screen.dart';
import '../features/auth/screen/set_password_screen.dart';
import '../features/auth/screen/verification_screen.dart';
import '../features/help_support/screens/help_support_screen.dart';
import '../features/help_support/screens/support_chat_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/map/screens/map_screen.dart';
import '../features/notification/screens/notification_screen.dart';
import '../features/offline_map_view/screens/offline_map_view_screen.dart';
import '../features/onboarding/screen/onboarding_screen.dart';
import '../features/payment/screens/payment_method_screen.dart';
import '../features/payment/screens/payment_success_screen.dart';
import '../features/preferences/screen/preferences_screen.dart';
import '../features/send_feedback/screens/send_feedback_screen.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(name: AppRoutes.setPassword, page: () => const SetPasswordScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () => const VerificationScreen(),
    ),
    GetPage(name: AppRoutes.preferences, page: () => const PreferencesScreen()),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.spotDetail,
      page: () => SpotDetailScreen(onBack: () => Get.back()),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.sendFeedback,
      page: () => const SendFeedbackScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.notification,
      page: () => NotificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.savedOfflineMaps,
      page: () => const OfflineMapsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.offlineMapView,
      page: () => const OfflineMapViewScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const ManagePlanScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.paymentMethod,
      page: () => const PaymentMethodScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.paymentSuccess,
      page: () => const PaymentSuccessScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.paymentFailed,
      page: () => const PaymentFailedScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.myPlan,
      page: () => const MySubscriptionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.helpSupport,
      page: () => const HelpSupportScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.supportChat,
      page: () => const SupportChatScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => const MapScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.savedLocation,
      page: () => const SavedLocationScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.mySubmission,
      page: () => const NewLocationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addDetails,
      page: () => AddDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.reviewSubmission,
      page: () => const ReviewSubmissionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.submissionReceived,
      page: () => const PendingApprovalScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
