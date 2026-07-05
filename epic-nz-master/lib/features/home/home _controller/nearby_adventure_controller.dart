import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NearbyAdventureController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Timer? _timer;
  bool isUserInteracting = false;

  @override
  void onReady() {
    super.onReady();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (scrollController.hasClients && !isUserInteracting) {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.offset;

        if (currentScroll >= maxScroll) {
          scrollController.jumpTo(0);
        } else {
          scrollController.jumpTo(currentScroll + 1.5);
        }
      }
    });
  }

  void pauseScroll() {
    isUserInteracting = true;
  }

  void resumeScroll() {
    Future.delayed(const Duration(seconds: 1), () {
      isUserInteracting = false;
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}
