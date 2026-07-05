import 'package:epic_nz/features/map/map_controller/map_controller.dart';
import 'package:epic_nz/features/profile/profile_controller/profile_controller.dart';
import 'package:epic_nz/features/save_location/controller/bookmark_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/screens/home_screen.dart';
import '../../home/spot_card_details_screen/spot_detail_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../notification/notification_controller.dart';
import '../../profile/screen/profile_screen.dart';
import '../../save_location/screens/saved_location_screen.dart';
import 'main_controller.dart';
import 'package:epic_nz/core/service/notification_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final mainController = Get.find<MainController>();

  final NotificationService _notificationService = NotificationService();

  bool _isShowingDetails = false;

  @override
  void initState() {
    super.initState();

    Get.put(MainController(), permanent: true);
    Get.put(NotificationController(), permanent: true);

    _initNotifications();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () async {
          if (Get.isRegistered<NotificationController>()) {
            await Get.find<NotificationController>().fetch();
          }
        },
      ),
    );
  }

  Future<void> _initNotifications() async {
    await _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color navBgColor = isDark ? Colors.white : Colors.black;
    final Color inactiveIcon = isDark ? Colors.grey : Colors.grey[600]!;

    final List<Widget> pages = [
      _isShowingDetails
          ? SpotDetailScreen(
              onBack: () => setState(() => _isShowingDetails = false),
            )
          : HomeScreen(
              onSpotTap: () => setState(() => _isShowingDetails = true),
            ),
      const MapScreen(),
      const SavedLocationScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => IndexedStack(
              index: mainController.selectedIndex.value,
              children: pages,
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: navBgColor,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(0, Icons.home_filled, inactiveIcon),
                  _buildNavIcon(1, Icons.map_outlined, inactiveIcon),
                  _buildNavIcon(2, Icons.bookmark_border, inactiveIcon),
                  _buildNavIcon(3, Icons.person_outline, inactiveIcon),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(int index, IconData icon, Color inactiveColor) {
    final mainController = Get.find<MainController>();

    return Obx(() {
      final bool isSelected = mainController.selectedIndex.value == index;

      return GestureDetector(
        onTap: () {
          final mapController = Get.find<MapController>();

          if (mainController.selectedIndex.value == 1 && index != 1) {
            mapController.clearRoute();
          }

          mainController.selectedIndex.value = index;

          setState(() => _isShowingDetails = false);

          if (index == 3 && Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().refreshAllProfileData();
          }

          if (index == 2 && Get.isRegistered<BookmarkController>()) {
            Get.find<BookmarkController>().fetchSavedLocations();
          }
        },

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.green : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : inactiveColor,
            size: 26,
          ),
        ),
      );
    });
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;

  LifecycleEventHandler({required this.resumeCallBack});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeCallBack();
    }
  }
}
