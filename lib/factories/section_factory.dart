import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_entry.dart';
import '../models/user_role.dart';
import 'adult_male_factory.dart';
import 'adult_female_factory.dart';
import 'child_factory.dart';

abstract class SectionFactory {
  Widget buildHeader(BuildContext context, WidgetRef ref);
  Widget buildQuranZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildPrayerZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildKnowledgeZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildFitnessZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildSelfCareZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildTaskZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildRoleSpecificZone(BuildContext context, WidgetRef ref, DailyEntry data);
  Widget buildWaterTracker(BuildContext context, WidgetRef ref, DailyEntry data);
}

class SectionFactoryProvider {
  static SectionFactory getFactory(UserRole role) {
    switch (role) {
      case UserRole.adultMale:
        return AdultMaleFactory();
      case UserRole.adultFemale:
        return AdultFemaleFactory();
      case UserRole.child:
        return ChildFactory();
    }
  }
}
