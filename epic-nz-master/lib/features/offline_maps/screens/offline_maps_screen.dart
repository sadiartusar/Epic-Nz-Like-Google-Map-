import 'package:flutter/material.dart';
import '../../../core/widgets/app_back_button.dart';
import '../widgets/offline_map_search.dart';
import '../widgets/offline_map_card.dart';

class OfflineMapsScreen extends StatelessWidget {
  const OfflineMapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  AppBackButton(),
                  Spacer(),
                  Text(
                    'Saved & Offline Maps',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                ],
              ),

              const SizedBox(height: 24),

              const OfflineMapSearch(),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return const OfflineMapCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
