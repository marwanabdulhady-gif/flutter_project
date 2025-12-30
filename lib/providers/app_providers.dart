import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/daily_entry.dart';
import '../models/user_role.dart';

// Locale Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  void _loadLocale() {
    final box = Hive.box('settings');
    final savedLocale = box.get('locale', defaultValue: 'en');
    state = Locale(savedLocale);
  }

  void toggleLocale() {
    final newLocale = state.languageCode == 'en' ? 'ar' : 'en';
    state = Locale(newLocale);
    Hive.box('settings').put('locale', newLocale);
  }

  void setLocale(String languageCode) {
    state = Locale(languageCode);
    Hive.box('settings').put('locale', languageCode);
  }
}

// User Role Provider
final userRoleProvider = StateNotifierProvider<UserRoleNotifier, UserRole>((ref) {
  return UserRoleNotifier();
});

class UserRoleNotifier extends StateNotifier<UserRole> {
  UserRoleNotifier() : super(UserRole.adultMale) {
    _loadRole();
  }

  void _loadRole() {
    final box = Hive.box('settings');
    final savedRole = box.get('userRole', defaultValue: 0);
    state = UserRole.values[savedRole];
  }

  void setRole(UserRole role) {
    state = role;
    Hive.box('settings').put('userRole', role.index);
  }
}

// Current Date Provider
final currentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Daily Entry Provider
final dailyEntryProvider = StateNotifierProvider<DailyEntryNotifier, DailyEntry>((ref) {
  final date = ref.watch(currentDateProvider);
  return DailyEntryNotifier(date);
});

class DailyEntryNotifier extends StateNotifier<DailyEntry> {
  final DateTime date;
  late Box<DailyEntry> _box;

  DailyEntryNotifier(this.date) : super(DailyEntry.createDefault(_dateToId(date))) {
    _init();
  }

  static String _dateToId(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _init() async {
    _box = Hive.box<DailyEntry>('daily_entries');
    final id = _dateToId(date);
    final existing = _box.get(id);
    
    if (existing != null) {
      state = existing;
    } else {
      // Check previous day for carry-over data
      final prevDate = date.subtract(const Duration(days: 1));
      final prevId = _dateToId(prevDate);
      final prevEntry = _box.get(prevId);

      state = DailyEntry.createDefault(
        id,
        knowledgeTask: prevEntry?.knowledgeTask,
        mainTask: prevEntry?.mainTask,
      );
      await _save();
    }
  }

  Future<void> _save() async {
    await _box.put(state.id, state);
  }

  void updateQuranRead(bool value) {
    state = DailyEntry(
      id: state.id,
      quranRead: value,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateQuranPages(int pages) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: pages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updatePrayer(String prayer, PrayerDetails details) {
    final newStatus = Map<String, PrayerDetails>.from(state.prayerStatus);
    newStatus[prayer] = details;
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: newStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateAzkar(String type, bool value) {
    final newAzkar = Map<String, bool>.from(state.azkar);
    newAzkar[type] = value;
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: newAzkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateKnowledgeTask(String task) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: task,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateKnowledgeCompleted(bool value) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: value,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateFitnessDuration(int minutes) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: minutes,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateSelfCareProgress(int progress) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: progress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateMainTask(String task) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: task,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateMainTaskCompleted(bool value) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: value,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateSilatRahim(bool value) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: value,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateRoleTask(String task, bool value) {
    final newTasks = Map<String, bool>.from(state.roleSpecificTasks);
    newTasks[task] = value;
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: newTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateWaterIntake(int cups) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: cups,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateChildMood(String mood) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: mood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
    );
    _save();
  }

  void updateQuranSurah(String surah) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: surah,
      quranJuz: state.quranJuz,
    );
    _save();
  }

  void updateQuranJuz(int juz) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: juz,
      familyTiesName: state.familyTiesName,
    );
    _save();
  }

  void updateFamilyTiesName(String name) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: name,
      fitnessActivity: state.fitnessActivity,
    );
    _save();
  }

  void updateFitnessActivity(String activity) {
    state = DailyEntry(
      id: state.id,
      quranRead: state.quranRead,
      quranPages: state.quranPages,
      prayerStatus: state.prayerStatus,
      azkar: state.azkar,
      knowledgeTask: state.knowledgeTask,
      knowledgeCompleted: state.knowledgeCompleted,
      fitnessDuration: state.fitnessDuration,
      selfCareProgress: state.selfCareProgress,
      mainTask: state.mainTask,
      mainTaskCompleted: state.mainTaskCompleted,
      silatRahim: state.silatRahim,
      roleSpecificTasks: state.roleSpecificTasks,
      waterIntake: state.waterIntake,
      childMood: state.childMood,
      quranSurah: state.quranSurah,
      quranJuz: state.quranJuz,
      familyTiesName: state.familyTiesName,
      fitnessActivity: activity,
    );
    _save();
  }
}


