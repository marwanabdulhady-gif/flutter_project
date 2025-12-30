import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_role.dart';
import '../providers/app_providers.dart';
import '../factories/section_factory.dart';
import '../factories/adult_male_factory.dart';
import '../factories/adult_female_factory.dart';
import '../factories/child_factory.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  SectionFactory _getFactory(UserRole role) {
    switch (role) {
      case UserRole.adultMale:
        return AdultMaleFactory();
      case UserRole.adultFemale:
        return AdultFemaleFactory();
      case UserRole.child:
        return ChildFactory();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider);
    final dailyEntry = ref.watch(dailyEntryProvider);
    final factory = _getFactory(userRole);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Zone 1: Header
            factory.buildHeader(context, ref),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Row 1: Quran & Prayer Tracker
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: factory.buildQuranZone(context, ref, dailyEntry),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: factory.buildPrayerZone(context, ref, dailyEntry),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Row 2: Knowledge, Fitness, Self Care
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: factory.buildKnowledgeZone(context, ref, dailyEntry),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: factory.buildFitnessZone(context, ref, dailyEntry),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: factory.buildSelfCareZone(context, ref, dailyEntry),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Row 3: Task & Role Specific
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: factory.buildTaskZone(context, ref, dailyEntry),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: factory.buildRoleSpecificZone(context, ref, dailyEntry),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Water Tracker (Full Width)
                  factory.buildWaterTracker(context, ref, dailyEntry),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
